# Microsoft Office 365 Connect-Beispiel für iOS unter Verwendung von Microsoft Graph (Swift)

Für die Arbeit mit Microsoft Office 365-Diensten und -Daten muss jede iOS-App zunächst eine Verbindung zu Microsoft Office 365 herstellen. In diesem Beispiel wird gezeigt, wie die Verbindung zu und dann der Aufruf einer API über Microsoft Graph (wurde zuvor als vereinheitlichte Office 365-API bezeichnet) erfolgt.

> Hinweis: Die Objective-C-Version dieses Beispiels finden Sie unter [O365-iOS-Microsoft-Graph-Connect](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect). Rufen Sie die Seite [Erste Schritte mit Office 365-APIs](http://dev.office.com/getting-started/office365apis?platform=option-ios#setup) auf. Auf dieser wird die Registrierung vereinfacht, damit Sie dieses Beispiel schneller ausführen können.
 
## Voraussetzungen
* [Xcode](https://developer.apple.com/xcode/downloads/) von Apple
* Installation von [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) als ein Abhängigkeits-Manager.
* Ein Office 365-Konto. Sie können sich für ein &lt;a herf="https://portal.office.com/Signup/Signup.aspx?OfferId=6881A1CB-F4EB-4db3-9F18-388898DAF510&amp;DL=DEVELOPERPACK&amp;ali=1#0"&gt;Office 365-Entwicklerabonnement&lt;/a&gt; registrieren, das alle Ressourcen umfasst, die Sie zum Einstieg in die Entwicklung von Office 365-Apps benötigen.

     > Hinweis: Wenn Sie bereits über ein Abonnement verfügen, gelangen Sie über den vorherigen Link zu einer Seite mit der Meldung „Leider können Sie Ihrem aktuellen Konto diesen Inhalt nicht hinzufügen“. Verwenden Sie in diesem Fall ein Konto aus Ihrem aktuellen Office 365-Abonnement.
* Ein Microsoft Azure-Mandant zum Registrieren Ihrer Anwendung. Von Microsoft Azure Active Directory (AD) werden Identitätsdienste bereitgestellt, die durch Anwendungen für die Authentifizierung und Autorisierung verwendet werden. Hier kann ein Testabonnement erworben werden: [Microsoft Azure](https://account.windowsazure.com/SignUp)

     > Wichtig: Sie müssen zudem sicherstellen, dass Ihr Azure-Abonnement an Ihren Office 365-Mandanten gebunden ist. Rufen Sie dafür den Blogpost [Creating and Managing Multiple Windows Azure Active Directories](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx) des Active Directory-Teams auf. In diesem Beitrag finden Sie unter **Adding a new directory** Informationen über die entsprechende Vorgehensweise. Weitere Informationen finden Sie zudem unter [Einrichten Ihrer Office 365-Entwicklungsumgebung](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) im Abschnitt **Verknüpfen Ihres Office 365-Kontos mit Azure AD zum Erstellen und Verwalten von Apps**.
      
* Eine Client-ID und Umleitungs-URI-Werte einer in Azure registrierten Anwendung. Dieser Beispielanwendung muss die Berechtigung **E-Mails unter einem anderen Benutzernamen senden** für **Microsoft Graph** gewährt werden. Informationen über das Erstellen der Registrierung finden Sie unter **Registrieren der systemeigenen App mit dem Azure-Verwaltungsportal** in [Manuelles Registrieren der App mit Azure AD, damit sie auf Office 365-APIs zugreifen kann](https://msdn.microsoft.com/en-us/office/office365/howto/add-common-consent-manually), und [gewähren Sie die entsprechenden Berechtigungen](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect/wiki/Grant-permissions-to-the-Connect-application-in-Azure) im Beispiel-Wiki, um die entsprechenden Berechtigungen darauf anzuwenden.


       
## Ausführen dieses Beispiels in Xcode

1. Klonen Sie dieses Repository
2. Verwenden Sie CocoaPods zum Importieren der Abhängigkeit zwischen Active Directory Authentication Library (ADAL) und iOS:
        
	     pod 'ADALiOS', '= 1.2.4'

 Diese Beispiel-App enthält bereits eine POD-Datei, die die ADAL-Komponenten (pods) in das Projekt überträgt. Navigieren Sie einfach über das **Terminal** zum Projekt, und führen Sie Folgendes aus: 
        
        pod install
        
   Weitere Informationen finden Sie im Thema über das **Verwenden von CocoaPods** in [Zusätzliche Ressourcen](#AdditionalResources).
  
3. Öffnen Sie **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**.
4. Öffnen Sie **AuthenticationConstants.swift**. Sie können sehen, dass die Werte **ClientID** und **RedirectUri** oben in der Datei hinzugefügt werden können. Geben Sie hier die erforderlichen Werte an:

        // You will set your application's clientId and redirect URI.
    	static let ClientId = "ENTER_YOUR_CLIENT_ID"
    	static let RedirectUri = NSURL.init(string: "ENTER_YOUR_REDIRECT_URI")
    	static let Authority = "https://login.microsoftonline.com/common"
    	static let ResourceId = "https://graph.microsoft.com"
    
    > Hinweis: Wenn Sie weder über „CLIENT_ID“- noch über „REDIRECT_URI“-Werte verfügen, müssen Sie [eine native Clientanwendung in Azure hinzufügen](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding) und sich die Werte „CLIENT_ID“ und „REDIRECT_URI“ notieren.

5. Führen Sie das Beispiel aus.


## Fragen und Kommentare

Wir schätzen Ihr Feedback hinsichtlich des Office 365 iOS Microsoft Graph Connect Swift-Projekts. Sie können uns Ihre Fragen und Vorschläge über den Abschnitt [Probleme](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect-Swift/issues) dieses Repositorys senden.

Allgemeine Fragen zur Office 365-Entwicklung sollten in [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API) gestellt werden. Stellen Sie sicher, dass Ihre Fragen oder Kommentare mit [Office365] und [MicrosoftGraph] markiert sind.


## Zusätzliche Ressourcen

* [Office Dev Center](http://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)
* [Microsoft Graph-Übersichtsseite](https://graph.microsoft.io)
* [Verwenden von CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Copyright
Copyright (c) 2016 Microsoft. Alle Rechte vorbehalten.



