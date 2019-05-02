//
//  AuthenticationClass.swift
//  Graph-iOS-Swift-Connect

import Foundation
import MSAL

class AuthenticationClass {
    // MARK: Properties and variables
    // Singleton class
    static let sharedInstance = AuthenticationClass()

    var authenticationProvider = MSALPublicClientApplication.init()
    var accessToken: String = ""
    var lastInitError: String?
    
    init () {
        do {
            // Get the MSAL client Id for this Azure app registration. We store it in the main bundle
            guard let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path),
                  let urlTypes = dict.object(forKey: "CFBundleURLTypes") as? NSArray else {
                fatalError("Can't find MSAL Client ID in your Info.plist")
            }

            let redirectUrl = getRedirectUrlFromMSALArray(array: urlTypes)

            guard let msalRange = redirectUrl.range(of: "msal") else {
                fatalError("Invalid Redirect URL")
            }

            let kClientId = String(redirectUrl[msalRange.upperBound...])
            let authority = try MSALAADAuthority.init(url: URL(string:ApplicationConstants.kAuthority)!)
            
            let pcaConfig = MSALPublicClientApplicationConfig.init(clientId: kClientId, redirectUri: nil, authority: authority)
            authenticationProvider = try MSALPublicClientApplication.init(configuration: pcaConfig)

        } catch let error as NSError {
            self.lastInitError = error.userInfo.description
            authenticationProvider = MSALPublicClientApplication.init()
        }
    }

    /**
     Authenticates to Microsoft Graph.
     If a user has previously signed in before and not disconnected, silent log in
     will take place.
     If not, authentication will ask for credentials
     */
    func connectToGraph(scopes: [String],
                        completion: @escaping (_ error: ApplicationConstants.MSGraphError?,
                                               _ accessToken: String) -> Void) {
        do {
            if let initError = self.lastInitError {
                throw NSError.init(domain: initError, code: 0, userInfo: nil)
            }

            // We check to see if we have a current logged in user. If we don't, then we need to sign someone in.
            // We throw an interactionRequired so that we trigger the interactive signin.

            // Acquire a token for an existing user silently
            guard let account = try authenticationProvider.allAccounts().first else {
                throw NSError.init(domain: "MSALErrorDomain",
                                   code: MSALError.interactionRequired.rawValue,
                                   userInfo: nil)
            }
            
            let parameters = MSALSilentTokenParameters.init(scopes: scopes, account:account)
            let authority = try MSALAADAuthority.init(url: URL(string:ApplicationConstants.kAuthority)!)
            parameters.authority = authority
            authenticationProvider.acquireTokenSilent(with: parameters) { result, error in
                // Could not acquire token silently
                guard let accessToken = result?.accessToken else {
                    completion(ApplicationConstants.MSGraphError.nsErrorType(error: error! as NSError), "")
                    return
                }
                
                self.accessToken = accessToken
                completion(nil, accessToken)
            }
        } catch let error {
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            switch (error as NSError).code {
            case MSALError.interactionRequired.rawValue:
                authenticationProvider.acquireToken(forScopes: scopes) { result, error in
                    guard let accessToken = result?.accessToken else {
                        completion(ApplicationConstants.MSGraphError.nsErrorType(error: error! as NSError), "")
                        return
                    }

                    self.accessToken = accessToken
                    completion(nil, accessToken)
                }
            default:
                completion(ApplicationConstants.MSGraphError.nsErrorType(error: error as NSError),
                           error.localizedDescription)
            }
        }
    }

    func disconnect() {
        let accounts = try? authenticationProvider.allAccounts()
        guard accounts != nil && !(accounts!.isEmpty) else {
            return
        }

        try? authenticationProvider.remove(accounts![0])
    }
    
    // Get client id from bundle
    func getRedirectUrlFromMSALArray(array: NSArray) -> String {
        guard let arrayElement = array.object(at: 0) as? NSDictionary,
              let redirectArray = arrayElement.value(forKeyPath: "CFBundleURLSchemes") as? NSArray,
              let subString = redirectArray.object(at: 0) as? String else {
            return ""
        }

        return subString
    }
}
