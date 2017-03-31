/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import UIKit

/**
 SendMailViewController is responsible for sending email using the Microsoft Graph API.
 Recipient address is pre-filled with the signed-in user's email address, and it can
 be modified.
 
 */
class SendMailViewController : UIViewController {
    
    // Constants struct for SendMail
    struct SendMailConstants {
        static let GraphUrl = "https://graph.microsoft.com/v1.0/me/microsoft.graph.sendmail"
        static let HttpMethod = "POST"
        static let ContentType = "application/json"
        static let AcceptType = "application/json, text/plain, */*"
        
        static let AuthorizationField = "Authorization"
        static let AcceptField = "Accept"
        static let ContentTypeField = "Content-Type"
        
        static let SuccessStatus = 202
    }
    
    // MARK: Constants, Outlets, and Properties
    // Outlets
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var sendMailButton: UIButton!
    @IBOutlet var statusTextView: UITextView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // Constants
    private let successString = "Check your Inbox, you have a new message."
    private let failureString = "The email couldn't be sent. Check the log for errors."
    
    // Properties
    var userEmailAddress: String!
    
    // MARK: ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.text = self.userEmailAddress
        
        if let idx = self.userEmailAddress.characters.index(of: "@") {
            self.headerLabel.text = "Hi, \(self.userEmailAddress.substring(to: idx) )"
        } else {
            self.headerLabel.text = "Not a valid email address"
        }
    }
    
    // MARK: IBActions
    @IBAction func sendMail(_ sender: AnyObject) {
        
        // Fetch content from file
        updateUI(showActivityIndicator: true, statusText: "Sending")
        
        if let uploadContent = mailContent() {
            sendMailRestWithContent(uploadContent)
        }
        else {
            updateUI(showActivityIndicator: false,
                     statusText: "Error assembling the mail content.")
        }
    }
    
    @IBAction func disconnect(_ sender: AnyObject) {
        
        AuthenticationManager.sharedInstance.clearCredentials()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Helper methods
    
    /**
     Prepare mail content by loading the files from resources and replacing placeholders with the
     HTML body.
     */
    func mailContent() -> Data? {
        
        if let emailFilePath = Bundle.main.path(forResource: "EmailPostContent", ofType: "json"),
            let emailBodyFilePath = Bundle.main.path(forResource: "EmailBody", ofType: "html"),
            let emailText = self.emailTextField.text {
            do {
                // Prepare upload content
                let emailContent = try String(contentsOfFile: emailFilePath, encoding: String.Encoding.utf8)
                let emailBodyRaw = try String(contentsOfFile: emailBodyFilePath, encoding: String.Encoding.utf8)
                // Request doesn't accept a single quotation mark("), so change it to the acceptable form (\")
                let emailValidBody = emailBodyRaw.replacingOccurrences(of: "\"", with: "\\\"")
                
                let emailPostContent = emailContent.replacingOccurrences(of: "<EMAIL>", with: emailText)
                    .replacingOccurrences(of: "<CONTENTTYPE>", with: "HTML")
                    .replacingOccurrences(of: "<CONTENT>", with: emailValidBody)
                
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
     Sending Email with REST API and update UI.
     */
    func sendMailRestWithContent(_ content: Data) {
        
        // Acquire an access token, if logged in already, this shouldn't bring up an authentication window.
        // However, if the token is expired, user will be asked to sign in again.
        AuthenticationManager.sharedInstance.acquireAuthToken {
            (result: AuthenticationResult) in
            
            switch result {
                
            case .success:
                if let accessToken = AuthenticationManager.sharedInstance.accessToken,
                    let sendMailUrl = URL(string: SendMailConstants.GraphUrl) {
                    // Upon success, send mail.
                    let request = NSMutableURLRequest(url: sendMailUrl)
                    
                    request.httpMethod = SendMailConstants.HttpMethod
                    request.setValue(SendMailConstants.ContentType, forHTTPHeaderField: SendMailConstants.ContentTypeField)
                    request.setValue(SendMailConstants.AcceptType, forHTTPHeaderField: SendMailConstants.AcceptField)
                    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: SendMailConstants.AuthorizationField)
                    request.httpBody = content
                    
                    let task = URLSession.shared.dataTask(with:request as URLRequest) { (data, response, error) in
                        
                        if let _ = error {
                            print(error as Any )
                            self.updateUI(showActivityIndicator: false, statusText: self.failureString)
                            return
                        }
                        
                        if let response = response as? HTTPURLResponse {
                            if response.statusCode == SendMailConstants.SuccessStatus {
                                self.updateUI(showActivityIndicator: false, statusText: self.successString)
                            }
                            else {
                                if let data = data {
                                    print("response: \(String(describing: response))")
                                    print(String(data: data, encoding: String.Encoding.utf8) as Any )
                                    self.updateUI(showActivityIndicator: false, statusText: self.failureString)
                                }
                            }
                        }
                    }
                    task.resume()
                }
                
            case .failure(let error):
                // Upon failure, alert and go back.
                print(error)
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Close", style: .destructive) { (action) in
                    AuthenticationManager.sharedInstance.clearCredentials()
                    self.navigationController?.popViewController(animated: true)
                })
                
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    /**
     Update UI
     */
    func updateUI(showActivityIndicator: Bool, statusText: String? = nil) {
        
        if showActivityIndicator {
            DispatchQueue.main.async {
                self.sendMailButton.isEnabled = false
                self.activityIndicator.startAnimating()
            }
        }
        else {
            DispatchQueue.main.async {
                self.sendMailButton.isEnabled = true
                self.activityIndicator.stopAnimating()
            }
        }
        if statusText != nil {
            DispatchQueue.main.async {
                self.statusTextView.text = statusText
            }
        }
    }
}
