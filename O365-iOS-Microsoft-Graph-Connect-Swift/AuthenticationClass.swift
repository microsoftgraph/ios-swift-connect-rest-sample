//
//  AuthenticationClass.swift
//  Graph-iOS-Swift-Connect

import Foundation
import MSAL

class AuthenticationClass {
    
    // MARK: Properties and variables
    // Singleton class
    class var sharedInstance: AuthenticationClass? {
        struct Singleton {
            static let instance = AuthenticationClass.init()
        }
        return Singleton.instance
    }

    var authenticationProvider = MSALPublicClientApplication.init()
    var accessToken: String = ""
    var lastInitError: String? = ""
    
    init () {

        do {
            authenticationProvider = try MSALPublicClientApplication.init(clientId: ApplicationConstants.ClientId, authority: ApplicationConstants.kAuthority)
        } catch  let error as NSError  {
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
                        completion:@escaping (_ error: ApplicationConstants.MSGraphError?, _ accessToken: String) -> Void)  {
        
        var accessToken = String()
        do {
            if let initError = self.lastInitError {
                if initError.lengthOfBytes(using: String.Encoding.ascii) > 1 {
                    throw NSError.init(domain: initError, code: 0, userInfo: nil)
                }
            }
            // We check to see if we have a current logged in user. If we don't, then we need to sign someone in.
            // We throw an interactionRequired so that we trigger the interactive signin.
            
            if  try authenticationProvider.users().isEmpty {
                throw NSError.init(domain: "MSALErrorDomain", code: MSALErrorCode.interactionRequired.rawValue, userInfo: nil)
            } else {
                
                // Acquire a token for an existing user silently
                
                try authenticationProvider.acquireTokenSilent(forScopes: scopes, user: authenticationProvider.users().first) { (result, error) in
                    
                    if error == nil {
                        self.accessToken = (result?.accessToken)!
                        completion(nil, accessToken);
                        
                        
                    } else {
                        
                        //"Could not acquire token silently: \(error ?? "No error information" as! Error )"
                        completion(ApplicationConstants.MSGraphError.nsErrorType(error: error! as NSError), "");
                        
                    }
                }
            }
        }  catch let error as NSError {
            
            // interactionRequired means we need to ask the user to sign-in. This usually happens
            // when the user's Refresh Token is expired or if the user has changed their password
            // among other possible reasons.
            
            if error.code == MSALErrorCode.interactionRequired.rawValue {
                
                authenticationProvider.acquireToken(forScopes: scopes) { (result, error) in
                    if error == nil {
                        accessToken = (result?.accessToken)!
                        completion(nil, accessToken);
                        
                        
                    } else  {
                        completion(ApplicationConstants.MSGraphError.nsErrorType(error: error! as NSError), "");
                        
                    }
                }
                
            } else {
                completion(ApplicationConstants.MSGraphError.nsErrorType(error: error as NSError), error.localizedDescription);

            }
            
        } catch {
            
            // This is the catch all error.
            
            
            completion(ApplicationConstants.MSGraphError.nsErrorType(error: error as NSError), error.localizedDescription);
            
        }
    }
    func disconnect() {
        
        do {
            try authenticationProvider.remove(authenticationProvider.users().first)
            
        } catch _ {
            
        }
        
    }

}
