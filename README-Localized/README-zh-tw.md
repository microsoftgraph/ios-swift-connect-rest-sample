# 使用 Microsoft Graph (Swift) 的 Microsoft Office 365 Connect 範例 (適用於 iOS)

連接到 Microsoft Office 365 是每個 iOS 應用程式要開始使用 Office 365 服務和資料時必須採取的第一個步驟。此範例示範如何透過 Microsoft Graph (之前稱為 Office 365 統一 API) 連接而後呼叫一個 API。

> 附註：如需此範例的 Objective-C 版本，請參閱 [O365-iOS-Microsoft-Graph-Connect](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)。此外，嘗試可簡化註冊的 [Office 365 API 入門](http://dev.office.com/getting-started/office365apis?platform=option-ios#setup)頁面，以便您能更快速地執行這個範例。
 
## 必要條件
* 
            來自 Apple 的 [Xcode](https://developer.apple.com/xcode/downloads/)
* 安裝 [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) 做為相依性管理員。
* Office 365 帳戶。您可以註冊 [Office 365 開發人員訂閱](https://aka.ms/devprogramsignup)，其中包含在開始建置 Office 365 應用程式時，您所需的資源。

     > 附註：如果您已有訂用帳戶，則先前的連結會讓您連到顯示 *抱歉，您無法將之新增到您目前的帳戶* 訊息的頁面。在此情況下，請使用您目前的 Office 365 訂用帳戶所提供的帳戶。
* 用來註冊您的應用程式的 Microsoft Azure 租用戶。Microsoft Azure Active Directory (AD) 會提供識別服務，以便應用程式用於驗證和授權。在這裡可以取得試用版的訂用帳戶：[Microsoft Azure](https://account.windowsazure.com/SignUp)。

     > 重要事項：您還需要確定您的 Azure 訂用帳戶已繫結至您的 Office 365 租用戶。若要執行這項操作，請參閱 Active Directory 小組的部落格文章：[建立和管理多個 Windows Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)。**新增目錄**一節將說明如何執行這項操作。如需詳細資訊，也可以參閱[設定 Office 365 開發環境](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)和**建立 Office 365 帳戶與 Azure AD 的關聯以便建立和管理應用程式**一節。
      
* 在 Azure 中註冊之應用程式的用戶端識別碼和重新導向 URI 值。此範例應用程式必須取得 **Microsoft Graph** 的 [以使用者身分傳送郵件]<e /> 權限。若要建立註冊，請參閱[向 Azure AD 手動註冊您的應用程式以便存取 Office 365 API](https://msdn.microsoft.com/en-us/office/office365/howto/add-common-consent-manually) 中的**在 Azure 管理入口網站中註冊您的原生應用程式**以及範例 wiki 中的[授與適當的權限](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect/wiki/Grant-permissions-to-the-Connect-application-in-Azure)，將適當的權限套用至應用程式。


       
## 在 Xcode 中執行這個範例

1. 複製此儲存機制
2. 使用 CocoaPods 來匯入 Active Directory Authentication Library (ADAL) iOS 相依性：
        
	     pod 'ADALiOS', '= 1.2.4'

 此範例應用程式已經包含可將 ADAL 元件 (pods) 放入專案的 podfile。只需從 **Terminal** 瀏覽至專案並執行： 
        
        pod install
        
   如需詳細資訊，請參閱[其他資訊](#AdditionalResources)中的**使用 CocoaPods**
  
3. 開啟 **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**
4. 開啟 **AuthenticationConstants.swift**。您會發現 **ClientID** 和 **RedirectUri** 值可以新增至檔案的頂端。在此提供必要的值：

        // You will set your application's clientId and redirect URI.
    	static let ClientId = "ENTER_YOUR_CLIENT_ID"
    	static let RedirectUri = NSURL.init(string: "ENTER_YOUR_REDIRECT_URI")
    	static let Authority = "https://login.microsoftonline.com/common"
    	static let ResourceId = "https://graph.microsoft.com"
    
    > 附註：如果您沒有 CLIENT_ID 和 REDIRECT_URI 值，請[在 Azure 中新增原生用戶端應用程式](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding)並記下 CLIENT\_ID 和 REDIRECT_URI。

5. 執行範例。


## 問題與意見

我們很樂於收到您對於 Office 365 iOS Microsoft Graph Connect Swift 專案的意見反應。您可以在此儲存機制的[問題](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect-Swift/issues)區段中，將您的問題及建議傳送給我們。

請在 [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) 提出有關 Office 365 開發的一般問題。務必以 [Office365] 和 [MicrosoftGraph] 標記您的問題或意見。


## 其他資源

* [Office 開發中心](http://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)
* [Microsoft Graph 概觀頁面](https://graph.microsoft.io)
* [使用 CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## 著作權
Copyright (c) 2016 Microsoft.著作權所有，並保留一切權利。



