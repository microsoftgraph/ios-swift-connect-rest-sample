# Exemplo de conexão com o Microsoft Office 365 para iOS usando o Microsoft Graph (Swift)

A primeira etapa para que os aplicativos iOS comecem a funcionar com dados e serviços do Microsoft Office 365 é estabelecer uma conexão com essa plataforma. Este exemplo mostra como se conectar e chamar uma única API do Microsoft Graph (antiga API unificada do Office 365).

> Observação: Para a versão Objective-C deste exemplo, confira [O365-iOS-Microsoft-Graph-Connect](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect). Além disso, experimente a página [Introdução às APIs do Office 365](http://dev.office.com/getting-started/office365apis?platform=option-ios#setup), que simplifica o registro para que você possa executar esse exemplo com mais rapidez.
 
## Pré-requisitos
* [Xcode](https://developer.apple.com/xcode/downloads/) da Apple
* A instalação do [CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html) como um gerenciador de dependências.
* Uma conta do Office 365. Você pode se inscrever para &lt;a herf="https://portal.office.com/Signup/Signup.aspx?OfferId=6881A1CB-F4EB-4db3-9F18-388898DAF510&amp;DL=DEVELOPERPACK&amp;ali=1#0"&gt;uma assinatura do Office 365 Developer&lt;/a&gt;, que inclui os recursos de que você precisa para começar a criar aplicativos do Office 365.

     > Observação: Caso já tenha uma assinatura, o link anterior direciona você para uma página com a mensagem *Não é possível adicioná-la à sua conta atual*. Nesse caso, use uma conta de sua assinatura atual do Office 365.
* Um locatário do Microsoft Azure para registrar o seu aplicativo. O Microsoft Azure Active Directory (AD) fornece serviços de identidade que os aplicativos usam para autenticação e autorização. Você pode adquirir uma assinatura de avaliação aqui: [Microsoft Azure](https://account.windowsazure.com/SignUp).

     > Importante: Você também deve assegurar que a sua assinatura do Azure esteja vinculada ao locatário do Office 365. Para saber como fazer isso, confira a postagem de blog da equipe do Active Directory: [Criar e gerenciar vários Microsoft Azure Active Directory](http://blogs.technet.com/b/ad/archive/2013/11/08/creating-and-managing-multiple-windows-azure-active-directories.aspx). A seção **Adicionar um novo diretório** explica como fazer isso. Para saber mais, confira o artigo [Configurar o seu ambiente de desenvolvimento do Office 365](https://msdn.microsoft.com/office/office365/howto/setup-development-environment#bk_CreateAzureSubscription) e a seção **Associar a sua conta do Office 365 ao Azure AD para criar e gerenciar aplicativos**.
      
* Valores de ID do cliente e de URI de redirecionamento de um aplicativo registrado no Azure. Esse aplicativo de exemplo deve receber permissão para **Enviar email como usuário** para o **Microsoft Graph**. Para criar o registro, confira o tópico **Registrar o aplicativo nativo com o Portal de Gerenciamento do Azure**, no artigo [Registrar o aplicativo manualmente com o AD do Azure para que ele possa acessar as APIs do Office 365](https://msdn.microsoft.com/en-us/office/office365/howto/add-common-consent-manually) e [conceda as permissões adequadas](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect/wiki/Grant-permissions-to-the-Connect-application-in-Azure) na wiki de exemplo para aplicá-las no registro.


       
## Executar esse exemplo no Xcode

1. Clonar esse repositório
2. Use o CocoaPods para importar a dependência de iOS da ADAL (Biblioteca de Autenticação do Active Directory):
        
	     pod 'ADALiOS', '= 1.2.4'

 Esse exemplo de aplicativo já contém um podfile que receberá os componentes ADAL (pods) no projeto. Basta navegar para o projeto no **Terminal** e executar: 
        
        pod install
        
   Para saber mais, confira o artigo **Usar o CocoaPods** em [Recursos adicionais](#AdditionalResources)
  
3. Abra **O365-iOS-Microsoft-Graph-Connect-Swift.xcworkspace**
4. Abra **AuthenticationConstants.swift**. Observe que você pode adicionar os valores de **ClientID** e **RedirectUri** na parte superior do arquivo. Forneça os valores necessários aqui:

        // You will set your application's clientId and redirect URI.
    	static let ClientId = "ENTER_YOUR_CLIENT_ID"
    	static let RedirectUri = NSURL.init(string: "ENTER_YOUR_REDIRECT_URI")
    	static let Authority = "https://login.microsoftonline.com/common"
    	static let ResourceId = "https://graph.microsoft.com"
    
    > Observação: Caso não tenha os valores CLIENT_ID e REDIRECT_URI, [adicione um aplicativo cliente nativo no Azure](https://msdn.microsoft.com/library/azure/dn132599.aspx#BKMK_Adding) e anote os valores de CLIENT\_ID e de REDIRECT_URI.

5. Execute o exemplo.


## Perguntas e comentários

Gostaríamos de saber sua opinião sobre o projeto Swift de conexão com o Office 365 para iOS usando o Microsoft Graph. Você pode enviar perguntas e sugestões na seção [Problemas](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect-Swift/issues) deste repositório.

As perguntas sobre o desenvolvimento do Office 365 em geral devem ser postadas no [Stack Overflow](http://stackoverflow.com/questions/tagged/Office365+API). Não deixe de marcar as perguntas ou comentários com [Office365] e [MicrosoftGraph].


## Recursos adicionais

* [Centro de Desenvolvimento do Office](http://dev.office.com/)
* [O365-iOS-Microsoft-Graph-Connect-Obj-C](https://github.com/OfficeDev/O365-iOS-Microsoft-Graph-Connect)
* [Página de visão geral do Microsoft Graph](https://graph.microsoft.io)
* [Usar o CocoaPods](https://guides.cocoapods.org/using/using-cocoapods.html)

## Direitos autorais
Copyright © 2016 Microsoft. Todos os direitos reservados.



