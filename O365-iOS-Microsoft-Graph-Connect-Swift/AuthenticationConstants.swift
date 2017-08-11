/*
* Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
* See LICENSE in the project root for license information.
*/

import Foundation

// You'll set your application's ClientId and RedirectURI here. These values are provided by your Microsoft Azure app
//registration. See README.MD for more details.

struct ApplicationConstants {

    static let ClientId    = "[ENTER_YOUR_CLIENT_ID]"
    static let ResourceId  = "https://graph.microsoft.com"
    static let kAuthority  = "https://login.microsoftonline.com/common/oauth2/v2.0"
    static let kGraphURI   = "https://graph.microsoft.com/v1.0/me/"
    static let kScopes: [String] = ["https://graph.microsoft.com/Mail.ReadWrite","https://graph.microsoft.com/Mail.Send","https://graph.microsoft.com/Files.ReadWrite","https://graph.microsoft.com/User.ReadBasic.All"]

    /**
     Simple construct to encapsulate NSError. This could be expanded for more types of graph errors in future.
     */
    enum MSGraphError: Error {
        case nsErrorType(error: NSError)
        
    }

}


