# 使用 Microsoft Graph (Swift) 的 iOS Microsoft Office 365 Connect 示例

连接到 Microsoft Office 365 是每个 iOS 应用开始使用 Office 365 服务和数据必须采取的第一步。该示例演示如何通过 Microsoft Graph（旧称 Office 365 统一 API）连接并调用一个 API。

> 注意：有关此示例的 Objective-C 版本，请参阅 [O365-iOS-Microsoft-Graph-Connect](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)。此外，请尝试 [Office 365 API 入门](http://dev.office.com/getting-started/office365apis?platform=option-ios#setup)页面，其简化了注册，使您可以更快地运行该示例。
 
## 先决条件
* 
            Apple [Xcode](https://developer.apple.com/xcode/downloads/)
* 安装 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 成为依存关系管理器。
* Office 365 帐户。您可以注册 &lt;a herf="https://profile.microsoft.com/RegSysProfileCenter/wizardnp.aspx?wizid=14b845d0-938c-45af-b061-f798fbb4d170"&gt;Office 365 开发人员订阅&lt;/a&gt;，其中包含开始构建 Office 365 应用所需的资源。

     > 注意：如果您已经订阅，之前的链接会将您转至包含以下信息的页面：*抱歉，您无法将其添加到当前帐户*。在这种情况下，请使用当前 Office 365 订阅中的帐户。Mic
* 用于注册您的应用程序的 Microsoft Azure 租户。Microsoft Azure Active Directory (AD) 为应用程序提供了用于进行身份验证和授权的标识服务。您还可在此处获得试用订阅：[Microsoft Azure](https://account.windowsazure.com/SignUp)。

     > 重要说明：您将还需要确保您的 Azure 订阅已绑定到 Office 365 租户。要执行这一操作，请参阅 Active Directory 团队的博客文章：[创建和管理多个 Microsoft Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)。**添加新目录**一节将介绍如何执行此操作。您还可以参阅[设置 Office 365 开发环境](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)和**关联您的 Office 365 帐户和 Azure AD 以创建并管理应用**一节获取详细信息。
      
* 在 Azure 中注册的应用程序的客户端 ID 和重定向 URI 值。必须向该示例应用程序授予**以用户身份发送邮件**权限以使用 **Microsoft Graph**。要创建注册，请参阅[使用 Azure AD 手动注册应用并使其能够访问 Office 365 API](https://msdn.microsoft.com/en-us/office/office365/howto/add-common-consent-manually) 中的**使用 Azure 管理门户注册本机应用程序**和示例 wiki 中的[授予适当权限](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect/wiki/Grant-permissions-to-the-Connect-application-in-Azure)向其授予适当的权限。


       
## 在 Xcode 中运行该示例

1. 克隆该存储库
2. 使用 CocoaPods 导入 Active Directory Authentication Library (ADAL) iOS 依存关系：
        
	     pod 'ADALiOS', '= 1.2.4'

 该示例应用已经包含了可将 ADAL 组件 (pod) 导入到项目中的 pod 文件。只需从**终端**中导航到该项目并运行： 
        
        pod install
        
   更多详细信息，请参阅[其他资源](#AdditionalResources)中的**使用 CocoaPods**
  
3. 打开 **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**
4. 打开 **AuthenticationConstants.swift**。您会发现，**ClientID** 和 **RedirectUri** 值可以添加到文件的顶部。在此提供必须值：

        // You will set your application's clientId and redirect URI.
    	static let ClientId = "ENTER_YOUR_CLIENT_ID"
    	static let RedirectUri = NSURL.init(string: "ENTER_YOUR_REDIRECT_URI")
    	static let Authority = "https://login.microsoftonline.com/common"
    	static let ResourceId = "https://graph.microsoft.com"
    
    > 注意：如果您没有 CLIENT_ID 和 REDIRECT_URI 值，请[在 Azure 中添加本机客户端应用程序](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding)并记录 CLIENT\_ID 和 REDIRECT_URI。

5. 运行示例。


## 问题和意见

我们乐意倾听您有关 Office 365 iOS Microsoft Graph Connect Swift 项目的反馈。您可以在该存储库中的[问题](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect-Swift/issues)部分将问题和建议发送给我们。

与 Office 365 开发相关的问题一般应发布到[堆栈溢出](http://stackoverflow.com/questions/tagged/Office365+API)。确保您的问题或意见使用了 [Office365] 和 [MicrosoftGraph] 标记。


## 其他资源

* [Office 开发人员中心](http://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)
* [Microsoft Graph 概述页](https://graph.microsoft.io)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## 版权
版权所有 (c) 2016 Microsoft。保留所有权利。



