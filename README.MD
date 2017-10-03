# Microsoft Office 365 Connect Sample for iOS Using Microsoft Graph (Swift)

Connecting to Microsoft Office 365 is the first step every iOS app must take to start working with Office 365 services and data. This sample shows how to connect and then call one API through Microsoft Graph.

> Note: For the Objective-C version of this sample, see [O365-iOS-Microsoft-Graph-Connect](https://github.com/microsoftgraph/ios-objectivec-connect-rest-sample). 
 
## Prerequisites
* [Xcode](https://developer.apple.com/xcode/downloads/) version 8.2.1 from Apple
* An Office 365 account. You can sign up for [an Office 365 Developer subscription](https://aka.ms/devprogramsignup) that includes the resources that you need to start building Office 365 apps.

     > Note: If you already have a subscription, the previous link sends you to a page with the message *Sorry, you can’t add that to your current account*. In that case, use an account from your current Office 365 subscription.
* A client id (application id) of an application registered in Azure. This sample application must be granted the **Send mail as a user** permission for **Microsoft Graph**. To create the registration, see [Grant permissions to the Connect application in Azure](https://github.com/microsoftgraph/ios-swift-connect-rest-sample/wiki/Grant-permissions-to-the-Connect-application-in-Azure).

>**Note:** The sample was tested on Xcode 8.2.1. This sample supports Xcode 8 and iOS10, which uses the Swift 3.0 framework.

       
## Running this sample in Xcode

1. Clone this repository
2. Use [Carthage](https://github.com/Carthage/Carthage) to import the Microsoft Authenticaion Library (MSAL) iOS dependency. Download the latest version of Carthage [here](https://github.com/Carthage/Carthage/releases).

### Build the MSAL framework

The preview version of MSAL is distributed as source code using Carthage. To build the source code, do these steps:

1. Open the Bash terminal and go to the app root folder.
2. Create a **cartfile**: Copy `echo "github \"AzureAD/microsoft-authentication-library-for-objc\" \"master\"" > Cartfile`  into the terminal and run the command.
3. Build the MSAL library: Copy `carthage update` into the terminal and run the command.        

### Update the sample with your client id

1. Open **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**
3. Open **Info.plist** as source code and update the client id:

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
                <string>msalENTER_YOUR_CLIENT_ID</string>
                <string>auth</string>
            </array>
        </dict>
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

