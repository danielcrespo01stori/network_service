# Guideline Network Service IOS Library

This library was developed with the purpose of creating a totally abstract layer in charge of consuming Rest API web services, implementing the main Apple urlSession library, based on good development practices (solid principles), unit tests implementing the pattern (GWT) with The Test doubles strategies were carried out in Swift 5.0 language, designed to be reusable and scalable in the future.

# Implementación

# Installation with SPM :
Add AFNetworking to your IOS project via spm pointing to the main branch:
Repository link: https://github.com/danielcrespo01stori/network_service/tree/main

# Implementation example :
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/08a4bedd-4834-435a-9d7d-7ace4daa59bb)

Import the library into the implementation class:

<img width="284" alt="imagen" src="https://github.com/danielcrespo01stori/network_service/assets/119959720/ec1004c7-7623-4334-ae79-fb8f53bd9b91">

Build your endPoint element with which you can parameterize your decodable response structure, request method, relative package for the url, service parameters, customizable headers, authorization token and api key.
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/026fe7f1-5ea2-46f7-b301-e25f079a55cf)

Make the call to your API by calling request and assigning your endPoint Object, this will return the generic success or failure response in your completionHandler.
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/c28d633d-10c6-47f5-adb7-cfda7b6b8507)

At the unit testing level, 89.3% coverage was reached in the package, demonstrating the quality of the software and the tests for the different scenarios of the library.
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/239ef41b-0154-40bf-b41a-32f6394336cc)

