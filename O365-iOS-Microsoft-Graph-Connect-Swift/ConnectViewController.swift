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

    // Outlets
    @IBOutlet var connectButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
}

// MARK: Actions
private extension ConnectViewController {
    @IBAction func connect(_ sender: AnyObject) {
        authenticate()
    }

    @IBAction func disconnect(_ sender: AnyObject) {
        AuthenticationClass.sharedInstance.disconnect()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: Authentication
private extension ConnectViewController {
    func authenticate() {
        loadingUI(show: true)

        let scopes = ApplicationConstants.kScopes

        AuthenticationClass.sharedInstance
            .connectToGraph(scopes: scopes) { result, _ in
                defer { self.loadingUI(show: false) }

                if let graphError = result {
                    switch graphError {
                    case .nsErrorType(let nsError):
                        print(NSLocalizedString("ERROR", comment: ""), nsError.userInfo)
                        self.showError(message: NSLocalizedString("CHECK_LOG_ERROR", comment: ""))
                    }
                } else {
                    // Run on main thread
                    DispatchQueue.main.async { [unowned self] in
                        self.performSegue(withIdentifier: "sendMail", sender: nil)
                    }
                }
        }
    }
}

// MARK: UI Helper
private extension ConnectViewController {
    func loadingUI(show: Bool) {
        DispatchQueue.main.async {
            if show {
                self.activityIndicator.startAnimating()
                self.connectButton.setTitle(NSLocalizedString("CONNECTING", comment: ""), for: .normal)
                self.connectButton.isEnabled = false
            } else {
                self.activityIndicator.stopAnimating()
                self.connectButton.setTitle(NSLocalizedString("CONNECT", comment: ""), for: .normal)
                self.connectButton.isEnabled = true
            }
        }
    }

    func showError(message: String) {
        DispatchQueue.main.async { [unowned self] in
            let alertControl = UIAlertController(title: NSLocalizedString("ERROR", comment: ""),
                                                 message: message,
                                                 preferredStyle: .alert)

            alertControl.addAction(UIAlertAction(title: NSLocalizedString("CLOSE", comment: ""),
                                                 style: .default,
                                                 handler: nil))

            self.present(alertControl, animated: true, completion: nil)
        }
    }
}
