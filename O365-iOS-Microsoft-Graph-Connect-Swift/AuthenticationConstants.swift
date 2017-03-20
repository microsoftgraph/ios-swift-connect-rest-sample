/*
* Copyright (c) Microsoft. All rights reserved. Licensed under the MIT license.
* See LICENSE in the project root for license information.
*/

import Foundation

// You'll set your application's ClientId and RedirectURI here. These values are provided by your Microsoft Azure app
//registration. See README.MD for more details.

struct AuthenticationConstants {

    static let ClientId    = "ENTER_YOUR_CLIENT_ID"
    static let RedirectUri = URL.init(string: "urn:ietf:wg:oauth:2.0:oob")
    static let Authority   = "https://login.microsoftonline.com/common"
    static let ResourceId  = "https://graph.microsoft.com"

}


