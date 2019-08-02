---
page_type: sample
products:
- office-365
- ms-graph
languages:
- swift
extensions:
  contentType: samples
  technologies:
  - Microsoft Graph
  - Azure AD
  - Microsoft identity platform
  services:
  - Office 365
  - Microosft identity platform
  platforms:
  - iOS
  createdDate: 1/27/2016 3:56:28 PM
---
# Microsoft Office 365 Connect Sample for iOS Using Microsoft Graph (Swift)

Connecting to Microsoft Office 365 is the first step every iOS app must take to start working with Office 365 services and data. This sample shows how to connect and then call one API through Microsoft Graph.

> **Note:** For the Objective-C version of this sample, see [O365-iOS-Microsoft-Graph-Connect](https://github.com/microsoftgraph/ios-objectivec-connect-rest-sample).

## Prerequisites

- [Xcode](https://developer.apple.com/xcode/downloads/) version 10.2.1
- [CocoaPods](https://cocoapods.org)
- An Office 365 account. You can sign up for [an Office 365 Developer subscription](https://aka.ms/devprogramsignup) that includes the resources that you need to start building Office 365 apps.

## Connect sample features

This sample demonstrates several REST calls to the Microsoft Graph REST endpoint.

- [GETs the signed in user's profile photo](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/profilephoto_get) from the *user* endpoint.
- PUT request to [upload the profile photo to the user's OneDrive root folder](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/driveitem_put_content)
- POST a request to OneDrive to [create a sharing link for a drive item](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/driveitem_createlink) to give other user's access to the uploaded photo
- POSTS a request to [send a mail message](https://developer.microsoft.com/en-us/graph/docs/api-reference/v1.0/api/user_sendmail) with a photo attachment

## Register and configure the app

1. Open a browser and navigate to the [Azure Active Directory admin center](https://aad.portal.azure.com) and login using a **personal account** (aka: Microsoft Account) or **Work or School Account**.

1. Select **Azure Active Directory** in the left-hand navigation, then select **App registrations** under **Manage**.

1. Select **New registration**. On the **Register an application** page, set the values as follows.

    - Set **Name** to `Swift REST Connect Sample`.
    - Set **Supported account types** to **Accounts in any organizational directory and personal Microsoft accounts**.
    - Under **Redirect URI**, change the drop down to **Public client (mobile & desktop)**, and set the value to `msauth.com.microsoft.O365-iOS-Microsoft-Graph-Connect-Swift-REST://auth`.

1. Choose **Register**. On the **Swift REST Connect Sample** page, copy the value of the **Application (client) ID** and save it, you will need it in the next step.

### Update the sample with your client id

1. Open **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**

1. Open **AuthenticationConstants.swift** and replace `<your-client-id>` with the application ID you copied in the previous step.

1. Run the sample.

## Contributing

If you'd like to contribute to this sample, see [CONTRIBUTING.MD](/CONTRIBUTING.md).

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/). For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Questions and comments

We'd love to get your feedback about the Office 365 iOS Microsoft Graph Connect Swift project. You can send your questions and suggestions to us in the [Issues](https://github.com/microsoftgraph/ios-swift-connect-rest-sample/issues) section of this repository.

Questions about Microsoft Graph development in general should be posted to [Stack Overflow](http://stackoverflow.com/questions/tagged/MicrosoftGraph). Make sure that your questions or comments are tagged with [MicrosoftGraph].

## Copyright

Copyright (c) 2017 Microsoft. All rights reserved.
