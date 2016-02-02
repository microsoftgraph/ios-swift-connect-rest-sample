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
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTextField.text = self.userEmailAddress
        
        let idx = self.userEmailAddress.characters.indexOf("@")
        self.headerLabel.text = "Hi, \(self.userEmailAddress.substringToIndex(idx!) )"
        
    }
    
    // MARK: IBActions
    @IBAction func sendMail(sender: AnyObject) {
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
    
    @IBAction func disconnect(sender: AnyObject) {
        AuthenticationManager.sharedInstance!.clearCredentials()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: Helper methods

    /**
     Prepare mail content by loading the files from resources and replacing placeholders with the
     HTML body.
     */
    func mailContent() -> NSData? {
        
        if let emailFilePath = NSBundle.mainBundle().pathForResource("EmailPostContent", ofType: "json"),
            emailBodyFilePath = NSBundle.mainBundle().pathForResource("EmailBody", ofType: "html")
        {
            do {
                // Prepare upload content
                let emailContent = try String(contentsOfFile: emailFilePath, encoding: NSUTF8StringEncoding)
                let emailBodyRaw = try String(contentsOfFile: emailBodyFilePath, encoding: NSUTF8StringEncoding)
                // Request doesn't accept a single quotation mark("), so change it to the acceptable form (\")
                let emailValidBody = emailBodyRaw.stringByReplacingOccurrencesOfString("\"", withString: "\\\"")
                
                let emailPostContent = emailContent.stringByReplacingOccurrencesOfString("<EMAIL>", withString: self.emailTextField.text!)
                    .stringByReplacingOccurrencesOfString("<CONTENTTYPE>", withString: "HTML")
                    .stringByReplacingOccurrencesOfString("<CONTENT>", withString: emailValidBody)
                
                return emailPostContent.dataUsingEncoding(NSUTF8StringEncoding)
            }
            catch {
                // Error handling in case file loading fails.
                return nil
            }
        }
        // Error handling in case files aren't present.
        return nil
    }
    
    func sendMailRestWithContent(content: NSData) {
        // Acquire an access token, if logged in already, this shouldn't bring up an authentication window.
        // However, if the token is expired, user will be asked to sign in again.
        AuthenticationManager.sharedInstance!.acquireAuthToken {
            (result: AuthenticationResult) -> Void in
            
            switch result {

            case .Success:
                // Upon success, send mail.
                let request = NSMutableURLRequest(URL: NSURL(string: "https://graph.microsoft.com/v1.0/me/microsoft.graph.sendmail")!)
                request.HTTPMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json, text/plain, */*", forHTTPHeaderField: "Accept")
                
                request.setValue("Bearer \(AuthenticationManager.sharedInstance!.accessToken!)", forHTTPHeaderField: "Authorization")
                
                request.HTTPBody = content
                
                let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler:
                    {
                        (data, response, error) -> Void in

                        if let _ = error {
                            print(error)
                            self.updateUI(showActivityIndicator: false, statusText: self.failureString)
                            return
                        }

                        let statusCode = (response as! NSHTTPURLResponse).statusCode
                        
                        if statusCode == 202 {
                            self.updateUI(showActivityIndicator: false, statusText: self.successString)
                        }
                        else {
                            print("response: \(response)")
                            print(String(data: data!, encoding: NSUTF8StringEncoding))
                            self.updateUI(showActivityIndicator: false, statusText: self.failureString)
                        }
                })
                
                task.resume()
            
            case .Failure(let error):
                // Upon failure, alert and go back.
                print(error)

                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                alertController.addAction(UIAlertAction(title: "Close", style: .Destructive, handler: {
                    (action) -> Void in
                    AuthenticationManager.sharedInstance?.clearCredentials()
                    self.navigationController!.popViewControllerAnimated(true)
                }))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            
                
            }
        }
    }
    
    func updateUI(showActivityIndicator showActivityIndicator: Bool,
        statusText: String? = nil) {
            if showActivityIndicator {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.sendMailButton.enabled = false
                    self.activityIndicator.startAnimating()
                })
            }
            else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.sendMailButton.enabled = true
                    self.activityIndicator.stopAnimating()
                })
            }
            if let _ = statusText {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.statusTextView.text = statusText
                })
            }
    }
}
