# Microsoft Office 365 Connect Sample for iOS Using Microsoft Graph (Swift)

Connecting to Microsoft Office 365 is the first step every iOS app must take to start working with Office 365 services and data. This sample shows how to connect and then call one API through Microsoft Graph.

> Note: For the Objective-C version of this sample, see [O365-iOS-Microsoft-Graph-Connect](https://github.com/microsoftgraph/ios-objectivec-connect-rest-sample). 

## Prerequisites
* [Xcode](https://developer.apple.com/xcode/downloads/) version 8.2.1 from Apple
* An Office 365 account. You can sign up for [an Office 365 Developer subscription](https://aka.ms/devprogramsignup) that includes the resources that you need to start building Office 365 apps.

     > Note: If you already have a subscription, the previous link sends you to a page with the message *Sorry, you can’t add that to your current account*. In that case, use an account from your current Office 365 subscription.
* A client id (application id) of an application registered in Azure. This sample application must be granted the **Send mail as a user** permission for **Microsoft Graph**. To create the registration, see [Grant permissions to the Connect application in Azure](https://github.com/microsoftgraph/ios-swift-connect-rest-sample/wiki/Grant-permissions-to-the-Connect-application-in-Azure).

>**Note:** The sample was tested on Xcode 9.1. This sample supports Xcode 8+ and iOS 10, which uses the Swift 3.0+ framework.

## Connect sample features
This sample demonstrates several REST calls to the Microsoft Graph REST endpoint. 

- [GETs the signed in user's profile photo](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/profilephoto_get) from the *user* endpoint.
- PUT request to [upload the profile photo to the user's OneDrive root folder](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/driveitem_put_content) 
- POST a request to OneDrive to [create a sharing link for a drive item](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/driveitem_createlink) to give other user's access to the uploaded photo
- POSTS a request to [send a mail message](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/user_sendmail) with a photo attachment
  ​     
## Running this sample in Xcode

1. Clone this repository
2. [Install Carthage](https://github.com/Carthage/Carthage/blob/master/README.md#installing-carthage) to import the Microsoft Authentication Library (MSAL) iOS dependency. Download the latest version of Carthage [here](https://github.com/Carthage/Carthage/releases).

### Build the MSAL framework

The preview version of MSAL is distributed as source code using Carthage. To build the source code, do these steps:

1. Open the Bash terminal and go to the app root folder.
2. Create a **cartfile**: Copy `echo "github \"AzureAD/microsoft-authentication-library-for-objc\" == 0.4.0" > Cartfile`  into the terminal and run the command.
3. Build the MSAL library: Copy `carthage update` into the terminal and run the command.        

### Update the sample with your client id

1. Open **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**

2. Open **AuthenticationConstants.swift** to update the redirect uri and client id:

   ```objective-c
   /*
        To enable brokered auth, redirect uri must be in the form of "msauth.<your-bundle-id-here>://auth".
        The redirect uri needs to be registered for your app in Azure Portal
        */
       static let kRedirectUri = "msauth.com.microsoft.O365-iOS-Microsoft-Graph-Connect-Swift-REST://auth"
           
       // Put your client id here
       static let kClientId = "<your-client-id>"
   ```
> **Note:** The redirect uri and client id need to be exactly as they exist in the Azure Portal app registration.
> <br/>

3. Open **Info.plist** as source code and register the scheme part of your redirect uri in step 2 by putting it under `CFBundleURLSchemes`.

   ```xml
   <key>CFBundleURLTypes</key>
   <array>
   	<dict>
   		<key>CFBundleTypeRole</key>
   		<string>Editor</string>
   		<key>CFBundleURLName</key>
   		<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
   		<key>CFBundleURLSchemes</key>
   		<array>
   			<string>msauth.com.microsoft.O365-iOS-Microsoft-Graph-Connect-Swift-REST</string>
   		</array>
   	</dict>
   </array>
   ```

4. Open **Info.plist** as source code and add the following to enable broker detection:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>msauthv2</string>
	<string>msauth</string>
</array>
```

4. Run the sample.

<a name="contributing"></a>
## Contributing ##

If you'd like to contribute to this sample, see [CONTRIBUTING.MD](/CONTRIBUTING.md).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Questions and comments

We'd love to get your feedback about the Office 365 iOS Microsoft Graph Connect Swift project. You can send your questions and suggestions to us in the [Issues](https://github.com/microsoftgraph/ios-swift-connect-rest-sample/issues) section of this repository.

Questions about Microsoft Graph development in general should be posted to [Stack Overflow](http://stackoverflow.com/questions/tagged/MicrosoftGraph). Make sure that your questions or comments are tagged with [MicrosoftGraph].


## Additional resources

* [Office Dev Center](https://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/microsoftgraph/ios-objectivec-connect-rest-sample)
* [Microsoft Graph overview page](https://developer.microsoft.com/en-us/graph/docs)
* [Carthage](https://github.com/Carthage/Carthage)

## Copyright
Copyright (c) 2017 Microsoft. All rights reserved.

