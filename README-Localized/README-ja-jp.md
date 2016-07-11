# Microsoft Graph (Swift) を使った iOS 用 Microsoft Office 365 Connect サンプル

Office 365 への接続は、各 iOS アプリが Microsoft Office 365 のサービスおよびデータの操作を開始するために必要な最初の手順です。このサンプルは、Microsoft Graph (旧称 Office 365 統合 API) を介して、1 つの API に接続して呼び出す方法を示しています。

> 注:このサンプルの Objective-C バージョンについては、「[O365-iOS-Microsoft-Graph-Connect](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)」をご覧ください。また、このサンプルをより迅速に実行するため、「[Office 365 API を使う](http://dev.office.com/getting-started/office365apis?platform=option-ios#setup)」ページに記載された登録の簡略化もお試しください。
 
## 前提条件
* 
            Apple 社の [Xcode](https://developer.apple.com/xcode/downloads/)。
* 依存関係マネージャーとしての [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) のインストール。
* Office 365 アカウント。&lt;a herf="https://profile.microsoft.com/RegSysProfileCenter/wizardnp.aspx?wizid=14b845d0-938c-45af-b061-f798fbb4d170"&gt;Office 365 Developer&lt;/a&gt; サブスクリプションにサイン アップすることができます。ここには、Office 365 アプリのビルドを開始するために必要なリソースが含まれています。

     > 注: サブスクリプションが既に存在する場合、上記のリンクをクリックすると、*申し訳ありません、現在のアカウントに追加できません* と表示されたページに移動します。その場合は、現在使用している Office 365 サブスクリプションのアカウントをご利用いただけます。Mic
* アプリケーションを登録する Microsoft Azure テナント。Microsoft Azure Active Directory (AD) は、アプリケーションが認証と承認に使用する ID サービスを提供します。試用版サブスクリプションは、[Microsoft Azure](https://account.windowsazure.com/SignUp) で取得できます。

     > 重要事項：Azure サブスクリプションが Office 365 テナントにバインドされていることを確認する必要があります。確認するには、Active Directory チームのブログ投稿「[複数の Windows Azure Active Directory を作成および管理する](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx)」を参照してください。「**新しいディレクトリを追加する**」セクションで、この方法について説明しています。また、詳細については、「[Office 365 開発環境をセットアップする](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription)」や「**Office 365 アカウントを Azure AD と関連付けてアプリを作成および管理する**」セクションも参照してください。
      
* Azure に登録されたアプリケーションのクライアント ID とリダイレクト URI の値。このサンプル アプリケーションには、**Microsoft Graph** の**ユーザーとしてメールを送信する**アクセス許可を付与する必要があります。登録を作成するには、「[Office 365 API にアクセスできるようにアプリを Azure AD に手動で登録する](https://msdn.microsoft.com/en-us/office/office365/howto/add-common-consent-manually)」の「**Azure 管理ポータルにネイティブ アプリを登録する**」と、適切なアクセス許可を付与するためのサンプル Wiki の「[適切なアクセス許可を付与する](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect/wiki/Grant-permissions-to-the-Connect-application-in-Azure)」をご覧ください。


       
## Xcode でこのサンプルを実行する

1. このリポジトリの複製を作成する
2. CocoaPods を使って、Active Directory 認証ライブラリ (ADAL) iOS の依存関係をインポートします。
        
	     pod 'ADALiOS', '= 1.2.4'

 このサンプル アプリには、プロジェクトに ADAL コンポーネント (pods) を取り込む podfile がすでに含まれています。**ターミナル**からプロジェクトに移動して次を実行するだけです。 
        
        pod install
        
   詳しくは、[その他の技術情報](#AdditionalResources)の「**CocoaPods を使う**」をご覧ください。
  
3. **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace** を開きます。
4. **AuthenticationConstants.swift** を開きます。**ClientID** と **RedirectUri** の各値がファイルの一番上に追加されていることが分かります。ここで必要な値を指定します。

        // You will set your application's clientId and redirect URI.
    	static let ClientId = "ENTER_YOUR_CLIENT_ID"
    	static let RedirectUri = NSURL.init(string: "ENTER_YOUR_REDIRECT_URI")
    	static let Authority = "https://login.microsoftonline.com/common"
    	static let ResourceId = "https://graph.microsoft.com"
    
    > 注: CLIENT_ID と REDIRECT_URI の値がない場合は、[ネイティブ クライアント アプリケーションを Azure に追加](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding)し、CLIENT_ID と REDIRECT_URI を書き留めます。

5. サンプルを実行します。


## 質問とコメント

Office 365 iOS Microsoft Graph Connect Swift プロジェクトについて、Microsoft にフィードバックをお寄せください。質問や提案につきましては、このリポジトリの「[問題](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect-Swift/issues)」セクションに送信できます。

Office 365 開発全般の質問につきましては、「[スタック オーバーフロー](http://stackoverflow.com/questions/tagged/Office365+API)」に投稿してください。質問またはコメントには、必ず [Office365] および [MicrosoftGraph] のタグを付けてください。


## その他の技術情報

* [Office デベロッパー センター](http://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)
* [Microsoft Graph 概要ページ](https://graph.microsoft.io)
* [CocoaPods を使う](https://guides.cocoapods.org/using/using-cocoapods.html)

## 著作権
Copyright (c) 2016 Microsoft. All rights reserved.



