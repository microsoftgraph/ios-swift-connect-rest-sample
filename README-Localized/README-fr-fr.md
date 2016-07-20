# Exemple de connexion d’iOS à Microsoft Office 365 avec Microsoft Graph (Swift)

La connexion à Microsoft Office 365 est la première étape que chaque application iOS doit suivre pour commencer à travailler avec les données et services Office 365. Cet exemple explique comment connecter, puis appeler une API via Microsoft Graph (anciennement appelé API unifiée Office 365).

> Remarque : pour la version Objective-C de cet exemple, voir [O365-iOS-Microsoft-Graph-Connect](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect). Consultez également la page relative à la [prise en main des API Office 365](http://dev.office.com/getting-started/office365apis?platform=option-ios#setup) pour enregistrer plus facilement votre application et exécuter plus rapidement cet exemple.
 
## Conditions requises
* [Xcode](https://developer.apple.com/xcode/downloads/) d’Apple
* Installation de [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) comme gestionnaire de dépendances.
* Un compte Office 365. Vous pouvez souscrire à [un abonnement Office 365 Développeur](https://aka.ms/devprogramsignup) comprenant les ressources dont vous avez besoin pour commencer à créer des applications Office 365.

     > Remarque : si vous avez déjà un abonnement, le lien précédent vous renvoie vers une page avec le message suivant : « Désolé, vous ne pouvez pas ajouter ceci à votre compte existant ». Dans ce cas, utilisez un compte lié à votre abonnement Office 365 existant.
* Un client Microsoft Azure pour enregistrer votre application. Microsoft Azure Active Directory (AD) fournit des services d’identité que les applications utilisent à des fins d’authentification et d’autorisation. Un abonnement d’évaluation peut être demandé ici : [Microsoft Azure](https://account.windowsazure.com/SignUp).

     > Important : vous devrez également vous assurer que votre abonnement Azure est lié à votre client Office 365. Pour cela, consultez le billet du blog de l’équipe d’Active Directory relatif à la [création et la gestion de plusieurs fenêtres dans les répertoires Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). La section sur l’**ajout d’un nouveau répertoire** vous explique comment procéder. Pour en savoir plus, vous pouvez également consulter la rubrique relative à la [configuration de votre environnement de développement Office 365](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) et la section sur l’**association de votre compte Office 365 à Azure Active Directory pour créer et gérer des applications**.
      
* Un ID client et des valeurs d’URI de redirection d’une application enregistrée dans Azure. Cet exemple d’application doit obtenir l’autorisation **Envoyer un courrier électronique en tant qu’utilisateur** pour **Microsoft Graph**. Pour enregistrer votre application, consultez la section relative à l’**enregistrement d’une application native avec le portail de gestion Azure** dans la rubrique relative à l’[enregistrement manuel d’une application avec Azure AD pour accéder aux API Office 365](https://msdn.microsoft.com/en-us/office/office365/howto/add-common-consent-manually) et la page relative à l’[octroi d’autorisations appropriées](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect/wiki/Grant-permissions-to-the-Connect-application-in-Azure) dans le wiki pour lui accorder les autorisations appropriées.


       
## Exécution de cet exemple dans Xcode

1. Cloner ce référentiel
2. Utilisez CocoaPods pour importer la dépendance iOS Active Directory Authentication Library (ADAL) :
        
	     pod 'ADALiOS', '= 1.2.4'

 Cet exemple d’application contient déjà un podfile qui recevra les composants ADAL (pods) dans le projet. Ouvrez simplement le projet à partir de **Terminal** et exécutez : 
        
        pod install
        
   Pour plus d’informations, consultez **Utilisation de CocoaPods** dans [Ressources supplémentaires](#AdditionalResources)
  
3. Ouvrez **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**
4. Ouvrez **AuthenticationConstants.swift**. Vous verrez que les valeurs **ClientID** et **RedirectUri** peuvent être ajoutées en haut du fichier. Indiquez les valeurs requises ici :

        // You will set your application's clientId and redirect URI.
    	static let ClientId = "ENTER_YOUR_CLIENT_ID"
    	static let RedirectUri = NSURL.init(string: "ENTER_YOUR_REDIRECT_URI")
    	static let Authority = "https://login.microsoftonline.com/common"
    	static let ResourceId = "https://graph.microsoft.com"
    
    > Remarque : si vous ne connaissez pas les valeurs de CLIENT_ID et de REDIRECT_URI, [ajoutez une application cliente native dans Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding) pour les noter.

5. Exécutez l’exemple.


## Questions et commentaires

Nous serions ravis de connaître votre opinion sur le projet Swift de connexion d’iOS à Office 365 avec Microsoft Graph. Vous pouvez nous faire part de vos questions et suggestions dans la rubrique [Problèmes](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect-Swift/issues) de ce référentiel.

Si vous avez des questions sur le développement d’Office 365, envoyez-les sur [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Veillez à poser vos questions ou à rédiger vos commentaires avec les tags [MicrosoftGraph] et [Office 365].


## Ressources supplémentaires

* [Centre de développement Office](http://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)
* [Page de présentation de Microsoft Graph](https://graph.microsoft.io)
* [Utilisation de CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Copyright
Copyright (c) 2016 Microsoft. Tous droits réservés.



