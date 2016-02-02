/*
* Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
* See LICENSE in the project root for license information.
*/

import Foundation

// You'll set your application's ClientId and RedirectURI here. These values are provided by your Microsoft Azure app
//registration. See README.MD for more details.

struct AuthenticationConstants {

    static let ClientId    = "ENTER_CLIENT_ID_HERE"
    static let RedirectUri = NSURL.init(string: "ENTER_REDIRECT_URI_HERE")
    static let Authority   = "https://login.microsoftonline.com/common"
    static let ResourceId  = "https://graph.microsoft.com"

}


