/*
 * Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
 * See LICENSE in the project root for license information.
 */

import UIKit

/**
 ConnectViewController is responsible for authenticating the user.
 Upon success, open SendMailViewController using predefined segue.
 Otherwise, show an error.
 
 In this sample a user-invoked cancellation is considered an error.
 */
class ConnectViewController: UIViewController {
    // Constants
    private static let SendMailIdentifier = "sendMail"
    
    // Outlets
    @IBOutlet var connectButton: UIButton!
    
    // Actions
    @IBAction func connect(_ sender: AnyObject) {
        
        AuthenticationManager.sharedInstance.acquireAuthToken {
            (result: AuthenticationResult) -> Void in
            
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: ConnectViewController.SendMailIdentifier, sender: self)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ConnectViewController.SendMailIdentifier,
            let vc = segue.destination as? SendMailViewController {
            vc.userEmailAddress = AuthenticationManager.sharedInstance.userInformation?.userId
        }
    }
}

