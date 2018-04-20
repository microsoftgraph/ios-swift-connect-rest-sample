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

class SendMailViewController : UIViewController {
    
    enum HTTPError: Error {
        case InvalidRequest
        case UnsupportedOperation
        case Unauthorized
        case NoError
        
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
    var userProfilePicture: UIImage? = nil
    var userPictureUrl: String? = ""
    
    
    // MARK: ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Get user state values before creating mail message to be sent
        do
        {
            try self.userName = AuthenticationClass.sharedInstance?.authenticationProvider.users()[0].name!
            try self.emailTextField.text = AuthenticationClass.sharedInstance?.authenticationProvider.users()[0].displayableId
            self.userEmailAddress = self.emailTextField.text
            self.headerLabel.text = "Hi, \(self.userName! )"
            
            updateUI(showActivityIndicator: true, statusText: "Getting picture", sendMail: true)

            //Important: Break out of async promise chain by declaring result returns Void
            _ = self.userPictureWork().then{
                result -> Void in
                    self.userPictureUrl = (result[1] as! String)
                    self.userProfilePicture = (result[0] as! UIImage)
                    self.updateUI(showActivityIndicator: false, statusText: "", sendMail: true)

            }.catch{err -> Void  in
                self.updateUI(showActivityIndicator: false, statusText: "", sendMail: false)

            }
        } catch _ as NSError{
            self.updateUI(showActivityIndicator: false,
                          statusText: "Error getting user profile picture.", sendMail: false)
        }
    }

    /**
     Asynchronous
       returns 501 (Not implemented) for msa accounts
     Gets the authenticated user's profile picture, uploads it to the user's OneDrive root folder,
     Requests a new web url sharing link to the uploaded photo.
     - returns:
        A Promise wrapping an array of AnyObject. Element 0: the sharing url. Element 1: the picture as UIImage

    */
    func userPictureWork() ->Promise<[AnyObject]> {
        return firstly {
            self.getUserPicture()
            }.then {picture in
                self.uploadPicture(photo: picture!)
            }.then {DriveItem in
                self.createSharingLink(itemId: DriveItem[1]as! String, image: DriveItem[0]as! UIImage)}
    }

    /**
      Async func. Get user's profile photo, upload photo to OneDrive, and get sharing link
     - returns:
        Promise<UIImage>. The user's profile picture
     */
    func getUserPicture()->Promise<UIImage?>{
        return Promise{ fulfill, reject in
            let urlRequest = buildRequest(operation: "GET", resource: "photo/$value") as URLRequest
            let task = URLSession.shared.dataTask(with:urlRequest){ data , res , err in
                if let err:Error = err {
                    print(err.localizedDescription)
                    return reject(err)
                }
                if ((self.checkResult(result: res!)) != HTTPError.NoError) {
                    return fulfill(self.getDefaultPicture())
                }
                if let data = data {
                    if let userImage: UIImage = UIImage(data:data) {
                        self.userProfilePicture = userImage
                        return fulfill(userImage)
                    } else {
                        return reject("no image" as! Error)
                    }
                } else {
                    return fulfill(self.getDefaultPicture())
                }
            }
            task.resume()
        }
    }
    
    func getDefaultPicture() ->UIImage {
        var returnImage:UIImage!
        if let userImage: UIImage = UIImage(named: "test") {
            self.userProfilePicture = userImage
            returnImage = userImage
        }

        return returnImage
    }
    /**
     Async func. Uploads a UIImage object to the signed in user's OneDrive root folder
     - Returns:
        A Promise encapsulating an array of AnyObject. Element 0 contains the user profile photo obtained in the previous chained async call
        Element 1 contains the web sharing URL of the photo in OneDrive as a String
     - Parameters:
     - UIImage: The image to upload to OneDrive
     */
    func uploadPicture(photo: UIImage) -> Promise<[AnyObject]> {
        return Promise<[AnyObject]>{ fulfill, reject in
            let uploadRequestUrl = self.buildRequest(operation: "PUT", resource: "drive/root:/me.jpg:/content", content: UIImageJPEGRepresentation(photo, 1.0)!) as URLRequest
            
            let task = URLSession.shared.dataTask(with:uploadRequestUrl){ data, res, err in
                if let err = err{
                    return reject(err)
                }
                if ((self.checkResult(result: res!)) != HTTPError.NoError) {
                    return reject(HTTPError.InvalidRequest)
                }
                
                //data can be serialized to a DriveItem object
                //https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/resources/driveitem
                var itemId: String = "";
                
                if let responseContent = data {
                    itemId = self.getValueFromResponse(json: responseContent, key: "id" )
                    var returnValues = [AnyObject]();
                    returnValues.append(photo as AnyObject)
                    returnValues.append(itemId as AnyObject)
                    return fulfill(returnValues)
                }
            }
            task.resume()
        }
    }

    /**
     Async func. Requests a new sharing link for the OneDrive item specified by the item id.
     - returns:
     - Promise<String: AnyObject>. The new sharing link and the image wrapped in a Promise
     */
    func createSharingLink(itemId: String, image: UIImage) ->Promise<[AnyObject]>{
        
        return Promise<[AnyObject]>{ fulfill, reject in
            
            //Create Data object for the JSON payload
            
            if let sharingLinkFilePath = Bundle.main.path(forResource: "CreateSharingLink", ofType: "json")
               
            {
                do {
                    let sharingLinkcontent = try String(contentsOfFile: sharingLinkFilePath, encoding: String.Encoding.utf8)
                    let jsonPayload: Data = sharingLinkcontent.data(using: String.Encoding.utf8)!
                    let uploadRequestUrl = self.buildRequest(
                        operation: "POST", resource: "drive/items/"+itemId+"/createLink", content: jsonPayload) as URLRequest
                    
                    let task = URLSession.shared.dataTask(with:uploadRequestUrl){ data, res, err in
                        if let err = err{
                            return reject(err)
                        }
                        if ((self.checkResult(result: res!)) != HTTPError.NoError) {
                            return reject(HTTPError.InvalidRequest)
                        }
                        
                        //data can be serialized to a DriveItem object
                        //https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/resources/driveitem
                        var sharingLink: String = "";
                        
                        if let responseContent = data {
                            do {
                                let resultJson = try JSONSerialization.jsonObject(
                                    with: responseContent, options: []) as? [String:AnyObject]
                                sharingLink = (OneDriveFileLink.init(json:resultJson!)?.webUrl)!

                            } catch let error as NSError {
                                print(error)
                            }
                            var returnValues = [AnyObject]();
                            returnValues.append(image as AnyObject)
                            returnValues.append(sharingLink as AnyObject)
                            return fulfill(returnValues)
                        }
                    }
                    task.resume()

                }
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
    func checkResult(result: URLResponse) -> HTTPError? {
        var returnValue:HTTPError = HTTPError.NoError
        var statusCode: Int  = 0;
        if let httpresponse = result as? HTTPURLResponse{
            statusCode = httpresponse.statusCode
        }
        var responseCodeString: String
        switch statusCode {
        case 400:
            responseCodeString = "Invalid request"
            returnValue = HTTPError.InvalidRequest
        case 403:
            responseCodeString = "Permissions error"
            returnValue = HTTPError.Unauthorized
        case 501:
            responseCodeString = "Unsupported operation"
            returnValue = HTTPError.UnsupportedOperation
        case 401:
            responseCodeString = "Unauthorized"
            returnValue = HTTPError.Unauthorized
        default:
            responseCodeString = "Success"
            
        }

        if (responseCodeString != "Success") {
            print(returnValue)
        }
        
        return returnValue
    }
    

    /**
     Gets a value from a JSON key/value pair by using the key parameter.
     - returns:
     The desired value as String
     
     - parameters:
        - Data: The JSON data to extract value from
        - String: The desired key
     */
    func getValueFromResponse(json: Data, key:String) -> String {
        var returnValue: String = " ";
            do {
                let resultJson = try JSONSerialization.jsonObject(with: json, options: []) as? [String:AnyObject]
                returnValue = self.getValueFromJsonObject(key: key, jsonObject: resultJson!)
            } catch let error as NSError {
                print(error)
            }
        return returnValue;
    }
    
    func getValueFromJsonObject(key:String, jsonObject: [String:AnyObject]) -> String{
        
        var returnValue: String = " "
        let jsonValue = jsonObject[key]
        if let stringArray = jsonValue as? [String:AnyObject] {
          _ =  self.getValueFromJsonObject(key: key, jsonObject: stringArray)
        }
        else {
            returnValue = jsonValue as! String
        }
        return returnValue

    }
    // MARK: IBActions
    
    /**
     Created an email message and sends it to a REST endpoint
     */
    @IBAction func sendMail(_ sender: AnyObject) {
        // Fetch content from file
        updateUI(showActivityIndicator: true, statusText: "Sending", sendMail: false)
        
        if let uploadContent = mailContent() {
            sendMailRESTWithContent(uploadContent)
        }
        else {
            updateUI(showActivityIndicator: false,
                     statusText: "Error assembling the mail content.", sendMail: false)
        }
    }
    
    
    
    // MARK: REST mail helper methods
    
    /**
     Prepare mail content by loading the files from resources and replacing placeholders with the
     HTML body.
     */
    func mailContent() -> Data? {
        
        if let emailFilePath = Bundle.main.path(forResource: "EmailPostContent", ofType: "json"),
            let emailBodyFilePath = Bundle.main.path(forResource: "EmailBody", ofType: "html")
        {
            do {
                // Prepare upload content
                let emailContent = try String(contentsOfFile: emailFilePath, encoding: String.Encoding.utf8)
                let emailBodyRaw = try String(contentsOfFile: emailBodyFilePath, encoding: String.Encoding.utf8)
                // Request doesn't accept a single quotation mark("), so change it to the acceptable form (\")
                var emailValidBody: String;
                emailValidBody = emailBodyRaw.replacingOccurrences(of: "\"", with: "\\\"")
                emailValidBody = emailValidBody.replacingOccurrences(of: "a href=%s", with: ("a href=" + self.userPictureUrl!))
                
                let imageData: NSData = UIImagePNGRepresentation(self.userProfilePicture!)! as NSData;
                
                let emailPostContent = emailContent.replacingOccurrences(of: "<EMAIL>", with: self.emailTextField.text!)
                    .replacingOccurrences(of: "<CONTENTTYPE>", with: "HTML")
                    .replacingOccurrences(of: "<CONTENT>", with: emailValidBody)
                    .replacingOccurrences(of: "<ODATA.TYPE>", with: "#microsoft.graph.fileAttachment")
                    .replacingOccurrences(of: "<IMAGE.TYPE>", with: "image\\/png")
                    .replacingOccurrences(of: "<CONTENTBYTES>", with: imageData.base64EncodedString())
                    .replacingOccurrences(of: "<NAME>", with: "me.png")
                
                return emailPostContent.data(using: String.Encoding.utf8)
            }
            catch {
                // Error handling in case file loading fails.
                return nil
            }
        }
        // Error handling in case files aren't present.
        return nil
    }
    
    /**
     POSTS a new message to the sendmail resource
     - parameters:
        - Data: The body of the message
     */
    func sendMailRESTWithContent(_ content: Data) {
        let _ = self.sendCRUDMessage(resource: "microsoft.graph.sendmail",
                                     operation: "POST",
                                     content: content)
    }
    
    /**
     Send a create, read, update, delete (CRUD) nessage.
     Create= POST, Update= PUT, Delete= DELETE.
     Read= GET. Use sendGETMessage(resource: String) to read Graph contents
     - returns:
     JSON response as Data
     - parameters:
        - String: The REST resource receiving the CRUD request
        - String: the REST operation requested
        - Data: The json (as Data) representing the values to update
     */
    func sendCRUDMessage(resource: String, operation:String, content: Data)->Data  {
        
        var returnData: Data;
        returnData = Data.init();
        
        if  (self.connectToGraph()){
            
            if (operation == "GET") {
                return self.sendGETMessage(resource: resource)
            }
            
            let request = self.buildRequest(operation: operation, resource: resource, content:content);
            
            let task = URLSession.shared.dataTask(with:request as URLRequest, completionHandler:{ data, res, err in
                if let err = err{
                    self.updateUI(showActivityIndicator: false,
                             statusText: "Error assembling the mail content." + err.localizedDescription, sendMail: false)
                }
                let nttpError = self.checkResult(result: res!)
                if (nttpError != HTTPError.NoError) {
                    self.updateUI(showActivityIndicator: false,
                                  statusText: "Error sending the mail.", sendMail: false)
                }
                else {
                    self.updateUI(showActivityIndicator: false, statusText: "", sendMail: true)
                }
            }) // let task
             task.resume()
        }
        return returnData;
        
    }
    
    
    /**
     Creates an URLRequest with the operation and resource parameters
    
     - returns:
        - NSURLRequest
     */
    func buildRequest(operation: String, resource:String) -> NSURLRequest {
        let request = NSMutableURLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me/" + resource)!)
        request.httpMethod = operation;
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
        
        let accessToken = AuthenticationClass.sharedInstance?.accessToken
        request.setValue("Bearer \(accessToken!)" as String, forHTTPHeaderField: "Authorization")
        return request as NSURLRequest
    }

    /**
     Createsan URLRequest with JSON body using operation, resource, and content parameters
     
     -returns:
        - NSURLREQUEST
     */
    func buildRequest(operation: String, resource:String, content: Data) -> NSURLRequest {
        let mutableRequest: NSMutableURLRequest = self.buildRequest(
            operation: operation, resource:resource) as! NSMutableURLRequest;
        mutableRequest.httpBody = content
        return mutableRequest as NSURLRequest
    }


    
    /**
     Sends a GET request. Internal helper method is only called by SendCRUDRequest()
     
     - returns:
     Data. The response returned by the GET request
     - parameters:
        - String: The resource to request the GET operation on
     */
    func sendGETMessage(resource: String) -> Data {
        var returnData: Data;
        returnData = Data.init();
        
        let request = self.buildRequest(operation: "GET", resource: resource)
        
        let task = URLSession.shared.dataTask(with:request as URLRequest, completionHandler: {
            (data, response, error) in
            
            if let _ = error {
                print(error as Any )
                self.updateUI(showActivityIndicator: false, statusText: self.failureString, sendMail: false)
                return
            }
            
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 202 {
                self.updateUI(showActivityIndicator: false, statusText: self.successString, sendMail: true)
                returnData = data!;
            }
            else {
                print("response: \(response!)")
                print(String(data: data!, encoding: String.Encoding.utf8) as Any )
                self.updateUI(showActivityIndicator: false, statusText: self.failureString, sendMail: false)
            }
        }) // let task
        
        task.resume()
        
        return returnData;
    }
    
    /**
     Calls into the AuthenticationClass to get an access token for the user.  Authentication class handles the mechanics of
     authenticating the user.
     - returns:
     True if the user is authenticated and an access token is returned.
     */
    func connectToGraph() -> Bool {
        
        // Acquire an access token, if logged in already, this shouldn't bring up an authentication window.
        // However, if the token is expired, user will be asked to sign in again.
        var authenticated: Bool;
        authenticated = ((AuthenticationClass.sharedInstance?.connectToGraph(scopes: ApplicationConstants.kScopes) {
            (result: ApplicationConstants.MSGraphError?, accessToken: String) -> Bool in
            
            if  ((AuthenticationClass.sharedInstance?.accessToken) == nil){
                // Upon failure, alert and go back.
                let localizedDescription: String = ApplicationConstants.MSGraphError.nsErrorType(error: result! as NSError).localizedDescription
                print(localizedDescription)
                
                let alertController = UIAlertController(
                    title: "Error", message: ApplicationConstants.MSGraphError.nsErrorType(
                        error: result! as NSError).localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: {
                    (action) -> Void in
                    AuthenticationClass.sharedInstance?.disconnect()
                    self.navigationController!.popViewController(animated: true)
                }))
                
                self.present(alertController, animated: true, completion: nil)
                return false;
                
            } else {
                
                return true;
                
            } // else authentication token != nil
            }) != nil)
        return authenticated;
    }
    
    func updateUI(showActivityIndicator: Bool,
                  statusText: String? = nil, sendMail: Bool) {
        if showActivityIndicator {
            DispatchQueue.main.async(execute: { () -> Void in
                self.sendMailButton.isEnabled = false
                self.activityIndicator.startAnimating()
            })
        }
        else {
            DispatchQueue.main.async(execute: { () -> Void in
                self.sendMailButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            })
        }
        if let _ = statusText {
            DispatchQueue.main.async(execute: { () -> Void in
                self.statusTextView.text = statusText
            })
        }
    }
}
