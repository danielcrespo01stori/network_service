# network_service
Guideline Librería network service IOS

Esta librería fue desarrollada con la finalidad de crear una capa totalmente abstracta encargada del consumo de servicios web api Rest, implementando la librería principal de apple urlSession, basada en buenas practicas de desarrollo (principios solid), pruebas unitarias implementando el patron(GWT) con las estrategias de Test doubles, se realizo en lenguaje swift 5.0 pensada para ser reutilizable y escalable a futuro.

Implementación
Instalación con SPM :
Agregar AFNetworking a su proyecto IOS por medio de spm apuntando a la branch de main : 
Link del repositorio: https://github.com/danielcrespo01stori/network_service/tree/main
Ejemplo de implementación:
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/08a4bedd-4834-435a-9d7d-7ace4daa59bb)

Importe la libreria en la clase de implementación:

<img width="284" alt="imagen" src="https://github.com/danielcrespo01stori/network_service/assets/119959720/ec1004c7-7623-4334-ae79-fb8f53bd9b91">

Construya su elemento endPoint con el cual podrá parametrizar su estructura de respuesta tipo decodable, método del request, paquete relativo para la url, parámetros del servicio, cabeceras customizables, token de autorización y api key.
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/026fe7f1-5ea2-46f7-b301-e25f079a55cf)

Realice el llamado a su API llamando request y asignando su Objeto endPoint este retornara en su completionHandler la respuesta genérica satisfactoria o fallida.
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/c28d633d-10c6-47f5-adb7-cfda7b6b8507)

A nivel de pruebas unitarias se llego a un 89.3% de cobertura en el paquete demostrando la calidad de software y las pruebas a los diferentes escenarios de la librería.
![imagen](https://github.com/danielcrespo01stori/network_service/assets/119959720/239ef41b-0154-40bf-b41a-32f6394336cc)

