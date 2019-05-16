//
//  AuthenticationClass.swift
//  Graph-iOS-Swift-Connect

import Foundation
import MSAL

class AuthenticationClass {
    // MARK: Properties and variables
    // Singleton class
    static let sharedInstance = AuthenticationClass()

    var authenticationProvider: MSALPublicClientApplication!
    var accessToken: String = ""
    var lastInitError: Error?
    
    init () {
        do {
            let authority = try MSALAADAuthority(url: URL(string:ApplicationConstants.kAuthority)!)
            
            let pcaConfig = MSALPublicClientApplicationConfig(clientId: ApplicationConstants.kClientId, redirectUri: ApplicationConstants.kRedirectUri, authority: authority)
            authenticationProvider = try MSALPublicClientApplication(configuration: pcaConfig)

        } catch let error as NSError {
            self.lastInitError = error
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
                throw initError
            }

            // We check to see if we have a current logged in user. If we don't, then we need to sign someone in.
            // We throw an interactionRequired so that we trigger the interactive signin.

            // Acquire a token for an existing user silently
            guard let account = try authenticationProvider.allAccounts().first else {
                throw NSError(domain: "MSALErrorDomain",
                                   code: MSALError.interactionRequired.rawValue,
                                   userInfo: nil)
            }
            
            let parameters = MSALSilentTokenParameters(scopes: scopes, account:account)
            let authority = try MSALAADAuthority(url: URL(string:ApplicationConstants.kAuthority)!)
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
                let parameters = MSALInteractiveTokenParameters(scopes: scopes)
                authenticationProvider.acquireToken(with: parameters) { result, error in
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
        guard let account = accounts?.first else { return }
        
        try? authenticationProvider.remove(account)
    }
}
