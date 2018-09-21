/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import UIKit
import Foundation
import PromiseKit

/**
 SendMailViewController is responsible for sending email using the Microsoft Graph API.
 Recipient address is pre-filled with the signed-in user's email address, and it can
 be modified.
 
 */
class SendMailViewController: UIViewController {
    enum HTTPError: Error {
        typealias ErrorCode = Int

        case invalidRequest
        case unsupportedOperation
        case unauthorized
        case anyError
        case noError

        init(statusCode: ErrorCode) {
            switch statusCode {
            case 200...299:
                self = .noError
            case 400:
                self = .invalidRequest
            case 403:
                self = .unauthorized
            case 501:
                self = .unsupportedOperation
            case 401:
                self = .unauthorized
            default:
                self = .anyError
            }
        }
    }

    // MARK: Constants, Outlets, and Properties
    // Outlets
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendMailButton: UIButton!
    @IBOutlet var statusTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // Constants
    let successString = "Check your Inbox, you have a new message."
    let failureString = "The email couldn't be sent. Check the log for errors."
    
    // Properties
    var userEmailAddress: String!
    var userName: String!
    var userProfilePicture: UIImage?
    var userPictureUrl: String? = ""

    // MARK: ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get user state values before creating mail message to be sent
        do {
            self.userName = try AuthenticationClass.sharedInstance.authenticationProvider.users()[0].name!
            self.emailTextField.text = try AuthenticationClass.sharedInstance.authenticationProvider.users()[0].displayableId
            self.userEmailAddress = self.emailTextField.text
            self.headerLabel.text = "Hi, \(self.userName!)"

            updateUI(showActivityIndicator: true, statusText: "Getting picture", sendMail: true)

            //Important: Break out of async promise chain by declaring result returns Void
            _ = self.userPictureWork()
                .then { image, url -> Void in
                    self.userPictureUrl = url
                    self.userProfilePicture = image
                    self.updateUI(showActivityIndicator: false, statusText: "", sendMail: true)
                }
                .catch { _ in
                    return self.updateUI(showActivityIndicator: false, statusText: "", sendMail: false)
                }
        } catch {
            self.updateUI(showActivityIndicator: false,
                          statusText: "Error getting user profile picture.",
                          sendMail: false)
        }
    }

    /**
     Asynchronous
       returns 501 (Not implemented) for msa accounts
     Gets the authenticated user's profile picture, uploads it to the user's OneDrive root folder,
     Requests a new web url sharing link to the uploaded photo.
     - returns:
        A Promise wrapping a tuple with the Image and its URL.
    */
    func userPictureWork() -> Promise<(UIImage, String)> {
        return firstly { self.getUserPicture() }
            .then { self.uploadPicture(photo: $0!) }
            .then { image, itemId -> Promise<(UIImage, String)> in
                return self.createSharingLink(itemId: itemId,
                                              image: image)
            }
    }

    /**
      Async func. Get user's profile photo, upload photo to OneDrive, and get sharing link
     - returns:
        Promise<UIImage>. The user's profile picture
     */
    func getUserPicture() -> Promise<UIImage?> {
        return Promise { fulfill, reject in
            let urlRequest = buildRequest(operation: "GET", resource: "photo/$value")
            URLSession.shared.dataTask(with: urlRequest) { data, res, err in
                if let err = err {
                    print(err.localizedDescription)
                    return reject(err)
                }

                guard self.checkResult(result: res!) == .noError else {
                    fulfill(self.getDefaultPicture())
                    return
                }

                guard let data = data else {
                    fulfill(self.getDefaultPicture())
                    return
                }

                guard let userImage = UIImage(data: data) else {
                    reject(HTTPError.invalidRequest)
                    return
                }

                self.userProfilePicture = userImage
                return fulfill(userImage)
            }.resume()
        }
    }
    
    func getDefaultPicture() -> UIImage {
        self.userProfilePicture = UIImage(named: "test") ?? self.userProfilePicture

        return self.userProfilePicture!
    }

    /**
     Async func. Uploads a UIImage object to the signed in user's OneDrive root folder
     - Returns:
        A Promise encapsulating a tuple of the user's profile image and its URL as a String.
     - Parameters:
     - UIImage: The image to upload to OneDrive
     */
    func uploadPicture(photo: UIImage) -> Promise<(UIImage, String)> {
        return Promise { fulfill, reject in
            let uploadRequestUrl = self.buildRequest(operation: "PUT",
                                                     resource: "drive/root:/me.jpg:/content",
                                                     withBody: photo.jpegData(compressionQuality: 1.0)!)
            
            URLSession.shared.dataTask(with: uploadRequestUrl) { data, res, err in
                if let err = err {
                    reject(err)
                    return
                }

                guard let responseContent = data,
                      self.checkResult(result: res!) == .noError else {
                    reject(HTTPError.invalidRequest)
                    return
                }
                
                // Data can be serialized to a DriveItem object
                // https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/resources/driveitem
                let itemId = self.getValueFromResponse(json: responseContent, key: "id")
                return fulfill((photo, itemId))
            }.resume()
        }
    }

    /**
     Async func. Requests a new sharing link for the OneDrive item specified by the item id.
     - returns:
     - Promise<String: AnyObject>. The new sharing link and the image wrapped in a Promise
     */
    func createSharingLink(itemId: String, image: UIImage) -> Promise<(UIImage, String)> {
        return Promise { fulfill, reject in

            // Create Data object for the JSON payload
            guard let sharingLinkFilePath = Bundle.main.path(forResource: "CreateSharingLink", ofType: "json") else {
                reject(HTTPError.invalidRequest)
                return
            }

            do {
                let sharingLinkcontent = try String(contentsOfFile: sharingLinkFilePath, encoding: String.Encoding.utf8)
                let jsonPayload: Data = sharingLinkcontent.data(using: String.Encoding.utf8)!
                let uploadRequestUrl = self.buildRequest(operation: "POST",
                                                         resource: "drive/items/\(itemId)/createLink",
                                                         withBody: jsonPayload)

                URLSession.shared.dataTask(with: uploadRequestUrl) { data, res, err in
                    if let err = err {
                        reject(err)
                        return
                    }

                    guard let responseContent = data,
                          self.checkResult(result: res!) == .noError else {
                        reject(HTTPError.invalidRequest)
                        return
                    }

                    // Data can be serialized to a DriveItem object
                    // https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/resources/driveitem
                    do {
                        let resultJson = try JSONSerialization.jsonObject(with: responseContent,
                                                                          options: [])
                        let sharingLink = (OneDriveFileLink(json: resultJson as? [String: AnyObject] ?? [:])?.webUrl)!
                        fulfill((image, sharingLink))
                    } catch let error as NSError {
                        print(error)
                    }
                }.resume()
            }
        }
    }

    // MARK: HTTPS helper functions
    
    /**
     Gets the HTTP status code from an URLResponse and returns a custom HTTPError set to an emuneration from
     expected HTTP codes
     - Returns:
     Custom HTTPError object of type Error
     - Parameters
        - URLResponse: The response to an HTTPRequest
     */
    func checkResult(result: URLResponse) -> HTTPError {
        let statusCode = (result as? HTTPURLResponse)?.statusCode ?? 400

        return HTTPError(statusCode: statusCode)
    }

    /**
     Gets a value from a JSON key/value pair by using the key parameter.
     - returns:
     The desired value as String
     
     - parameters:
        - Data: The JSON data to extract value from
        - String: The desired key
     */
    func getValueFromResponse(json: Data, key: String) -> String {
        do {
            let resultJson = try JSONSerialization.jsonObject(with: json, options: []) as? [String: AnyObject]
            return self.getValueFromJsonObject(key: key, jsonObject: resultJson!)
        } catch let error as NSError {
            print("Failed deserializing JSON: \(error)")
            return ""
        }
    }
    
    func getValueFromJsonObject(key: String,
                                jsonObject: [String: AnyObject]) -> String {
        let jsonValue = jsonObject[key]

        if let stringArray = jsonValue as? [String: AnyObject] {
          return self.getValueFromJsonObject(key: key, jsonObject: stringArray)
        } else {
            return jsonValue as? String ?? ""
        }
    }

    // MARK: IBActions
    
    /**
     Created an email message and sends it to a REST endpoint
     */
    @IBAction func sendMail(_ sender: AnyObject) {
        // Fetch content from file
        updateUI(showActivityIndicator: true, statusText: "Sending", sendMail: false)

        guard let uploadContent = mailContent() else {
            updateUI(showActivityIndicator: false,
                     statusText: "Error assembling the mail content.", sendMail: false)
            return
        }

        sendMailRESTWithContent(uploadContent)
    }
    
    // MARK: REST mail helper methods
    /**
     Prepare mail content by loading the files from resources and replacing placeholders with the
     HTML body.
     */
    func mailContent() -> Data? {
        guard let emailFilePath = Bundle.main.path(forResource: "EmailPostContent", ofType: "json"),
              let emailBodyFilePath = Bundle.main.path(forResource: "EmailBody", ofType: "html") else {
            return nil
        }

        do {
            // Prepare upload content
            let emailContent = try String(contentsOfFile: emailFilePath, encoding: String.Encoding.utf8)
            let emailBodyRaw = try String(contentsOfFile: emailBodyFilePath, encoding: String.Encoding.utf8)

            // Request doesn't accept a single quotation mark("), so change it to the acceptable form (\")
            let emailValidBody = emailBodyRaw
                .replacingOccurrences(of: "\"", with: "\\\"")
                .replacingOccurrences(of: "a href=%s", with: ("a href=" + self.userPictureUrl!))

            let imageData = self.userProfilePicture!.jpegData(compressionQuality: 1.0)!

            let emailPostContent = emailContent
                .replacingOccurrences(of: "<EMAIL>", with: self.emailTextField.text!)
                .replacingOccurrences(of: "<CONTENTTYPE>", with: "HTML")
                .replacingOccurrences(of: "<CONTENT>", with: emailValidBody)
                .replacingOccurrences(of: "<ODATA.TYPE>", with: "#microsoft.graph.fileAttachment")
                .replacingOccurrences(of: "<IMAGE.TYPE>", with: "image\\/png")
                .replacingOccurrences(of: "<CONTENTBYTES>", with: imageData.base64EncodedString())
                .replacingOccurrences(of: "<NAME>", with: "me.png")

            return emailPostContent.data(using: .utf8)
        } catch {
            return nil
        }
    }
    
    /**
     POSTS a new message to the sendmail resource
     - parameters:
        - Data: The body of the message
     */
    func sendMailRESTWithContent(_ content: Data) {
        _ = self.sendCRUDMessage(resource: "microsoft.graph.sendmail",
                                 operation: "POST",
                                 content: content)
    }
    
    /**
     Send a create, read, update, delete (CRUD) message.
     Create= POST, Update= PUT, Delete= DELETE.
     Read= GET. Use sendGETMessage(resource: String) to read Graph contents
     - returns:
     JSON response as Data
     - parameters:
        - String: The REST resource receiving the CRUD request
        - String: the REST operation requested
        - Data: The json (as Data) representing the values to update
     */
    func sendCRUDMessage(resource: String, operation: String, content: Data) -> Promise<Data> {
        let sendRequest: Promise<Data>

        switch operation {
        case "GET":
            sendRequest = self.sendGETMessage(resource: resource)
        default:
            let request = self.buildRequest(operation: operation, resource: resource, withBody: content)

            sendRequest = Promise<Data> { fulfill, reject in
                URLSession.shared.dataTask(with: request) { data, res, err in
                    if let err = err {
                        self.updateUI(showActivityIndicator: false,
                                      statusText: "Error assembling the mail content. " + err.localizedDescription,
                                      sendMail: false)
                        reject(err)
                        return
                    }

                    switch self.checkResult(result: res!) {
                    case .noError:
                        self.updateUI(showActivityIndicator: false,
                                      statusText: "",
                                      sendMail: true)
                        fulfill(data!)
                    default:
                        self.updateUI(showActivityIndicator: false,
                                      statusText: "Error sending the mail.", sendMail: false)
                        reject(HTTPError.invalidRequest)
                    }
                }.resume()
            }
        }

        return firstly { connectToGraph() }
            .then { _ in sendRequest }
    }

    /**
     Creates an URLRequest with the operation and resource parameters
    
     - returns:
        - NSURLRequest
     */
    func buildRequest(operation: String, resource: String, withBody: Data? = nil) -> URLRequest {
        var request = URLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me/\(resource)")!)
        request.httpMethod = operation
        request.httpBody = withBody
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        
        let accessToken = AuthenticationClass.sharedInstance.accessToken
        request.setValue("Bearer \(accessToken)" as String, forHTTPHeaderField: "Authorization")
        return request
    }

    /**
     Sends a GET request. Internal helper method is only called by SendCRUDRequest()
     
     - returns:
     Data. The response returned by the GET request
     - parameters:
        - String: The resource to request the GET operation on
     */
    func sendGETMessage(resource: String) -> Promise<Data> {
        let request = self.buildRequest(operation: "GET", resource: resource)
        return Promise { fulfill, reject in
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    reject(error)
                    self.updateUI(showActivityIndicator: false, statusText: self.failureString, sendMail: false)
                    return
                }

                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 400

                switch statusCode {
                case 200...299:
                    self.updateUI(showActivityIndicator: false, statusText: self.successString, sendMail: true)
                    fulfill(data!)
                default:
                    print("response: \(response!)")
                    print(String(data: data!, encoding: String.Encoding.utf8) as Any )
                    self.updateUI(showActivityIndicator: false, statusText: self.failureString, sendMail: false)
                    reject(error ?? HTTPError.invalidRequest)
                }
            }.resume()
        }
    }
    
    /**
     Calls into the AuthenticationClass to get an access token for the user.
     Authentication class handles the mechanics of authenticating the user.
     - returns:
     True if the user is authenticated and an access token is returned.
     */
    func connectToGraph() -> Promise<String> {
        return Promise { resolve, reject in
            // Acquire an access token. If logged in already, this shouldn't bring up an authentication window.
            // However, if the token is expired, user will be asked to sign in again.
            AuthenticationClass.sharedInstance
                .connectToGraph(scopes: ApplicationConstants.kScopes) { error, accessToken in
                if let error = error {
                    let errorMessage = ApplicationConstants.MSGraphError
                                        .nsErrorType(error: error as NSError).localizedDescription
                    let alertController = UIAlertController(title: "Error",
                                                            message: errorMessage,
                                                            preferredStyle: .alert)

                    alertController.addAction(UIAlertAction(title: "Close", style: .destructive) { _ in
                        AuthenticationClass.sharedInstance.disconnect()
                        self.navigationController!.popViewController(animated: true)
                    })

                    self.present(alertController, animated: true, completion: nil)

                    reject(error)
                }

                resolve(accessToken)
            }
        }
    }
    
    func updateUI(showActivityIndicator: Bool,
                  statusText: String? = nil, sendMail: Bool) {
        DispatchQueue.main.async {
            self.statusTextView.text = statusText ?? ""
            self.sendMailButton.isEnabled = !showActivityIndicator
            showActivityIndicator ? self.activityIndicator.startAnimating()
                                  : self.activityIndicator.stopAnimating()
        }
    }
}
