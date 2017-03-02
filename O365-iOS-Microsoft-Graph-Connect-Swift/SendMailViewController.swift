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
    
    // MARK: ViewController methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.text = self.userEmailAddress
        
        let idx = self.userEmailAddress.characters.index(of: "@")
        self.headerLabel.text = "Hi, \(self.userEmailAddress.substring(to: idx!) )"
        
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
        AuthenticationManager.sharedInstance!.clearCredentials()
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: Helper methods

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
                let emailValidBody = emailBodyRaw.replacingOccurrences(of: "\"", with: "\\\"")
                
                let emailPostContent = emailContent.replacingOccurrences(of: "<EMAIL>", with: self.emailTextField.text!)
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
    
    func sendMailRestWithContent(_ content: Data) {
        
        // Acquire an access token, if logged in already, this shouldn't bring up an authentication window.
        // However, if the token is expired, user will be asked to sign in again.
        AuthenticationManager.sharedInstance!.acquireAuthToken {
            (result: AuthenticationResult) -> Void in
            
            switch result {

            case .success:
                // Upon success, send mail.
                let request = NSMutableURLRequest(url: URL(string: "https://graph.microsoft.com/v1.0/me/microsoft.graph.sendmail")!)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
                
                request.setValue("Bearer \(AuthenticationManager.sharedInstance!.accessToken!)", forHTTPHeaderField: "Authorization")
                
                request.httpBody = content
                

                
                let task = URLSession.shared.dataTask(with:request as URLRequest, completionHandler: {
                    (data, response, error) in
                    
                    if let _ = error {
                        print(error as Any )
                        self.updateUI(showActivityIndicator: false, statusText: self.failureString)
                        return
                    }
                    
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    
                    if statusCode == 202 {
                        self.updateUI(showActivityIndicator: false, statusText: self.successString)
                    }
                    else {
                        print("response: \(response)")
                        print(String(data: data!, encoding: String.Encoding.utf8) as Any )
                        self.updateUI(showActivityIndicator: false, statusText: self.failureString)
                    }
                })
                
                task.resume()
            
            case .failure(let error):
                // Upon failure, alert and go back.
                print(error)

                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Close", style: .destructive, handler: {
                    (action) -> Void in
                    AuthenticationManager.sharedInstance?.clearCredentials()
                    self.navigationController!.popViewController(animated: true)
                }))
                
                self.present(alertController, animated: true, completion: nil)
            
                
            }
        }
    }
    
    func updateUI(showActivityIndicator: Bool,
        statusText: String? = nil) {
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
