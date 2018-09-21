/*
* Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
* See LICENSE in the project root for license information.
*/

import UIKit
import MSAL

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    // @brief Handles inbound URLs. Checks if the URL matches the redirect URI for a pending AppAuth
    // authorization request and if so, will look for the code in the response.
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("Received callback!")
        MSALPublicClientApplication.handleMSALResponse(url)

        return true
    }
}
