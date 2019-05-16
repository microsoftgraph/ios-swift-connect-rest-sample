/*
* Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
* See LICENSE in the project root for license information.
*/

import Foundation

// You'll set your application's ClientId and RedirectURI here. These values are provided by your Microsoft Azure app
//registration. See README.MD for more details.

struct ApplicationConstants {
    static let ResourceId  = "https://graph.microsoft.com"
    static let kAuthority  = "https://login.microsoftonline.com/common"
    static let kGraphURI   = "https://graph.microsoft.com/v1.0/me/"
    static let kScopes     = ["https://graph.microsoft.com/Mail.ReadWrite",
                              "https://graph.microsoft.com/Mail.Send",
                              "https://graph.microsoft.com/Files.ReadWrite",
                              "https://graph.microsoft.com/User.ReadBasic.All"]
    
    /*
     To enable brokered auth, redirect uri must be in the form of "msauth.<your-bundle-id-here>://auth".
     The redirect uri needs to be registered for your app in Azure Portal
     The scheme, i.e. "msauth.<your-bundle-id-here>" needs to be registered in the info.plist of the project
     */
    static let kRedirectUri = "msauth.com.microsoft.O365-iOS-Microsoft-Graph-Connect-Swift-REST://auth"
    // Put your client id here
    static let kClientId = "<your-client-id>"

    /**
     Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future.
     */
    enum MSGraphError: Error {
        case nsErrorType(error: NSError)
    }
}
