import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// ignore: camel_case_types
class politics extends StatelessWidget{
  const politics({super.key});
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: [
                
                TextSpan(
                  text: 'CN',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' MECAB',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        
      ),
      body: const Markdown(
        data: '''
## Política de Privacidad

**Última actualización: 1 de enero de 2023**

Bienvenido a nuestra aplicación. En esta política de privacidad, explicamos cómo recopilamos, utilizamos y protegemos tus datos personales. Al utilizar nuestra aplicación, aceptas esta política.

### Datos que Recopilamos

- **Información de Registro**: Cuando creas una cuenta, recopilamos tu nombre, dirección de correo electrónico y contraseña.
- **Datos de Uso**: Recopilamos información sobre cómo utilizas nuestra aplicación, como las acciones que realizas y el tiempo que pasas en la aplicación.
- **Datos de Dispositivo**: Podemos recopilar información sobre tu dispositivo, como el modelo, la versión del sistema operativo y la dirección IP.

### Uso de tus Datos

Utilizamos tus datos para:

- **Proporcionar y Mantener el Servicio**: Utilizamos tus datos para ofrecer nuestros servicios y garantizar su funcionamiento.
- **Mejorar el Servicio**: Analizamos tus datos para mejorar la calidad y la funcionalidad de nuestra aplicación.
- **Comunicación**: Podemos enviarte correos electrónicos relacionados con el servicio, como actualizaciones y notificaciones.
- **Seguridad**: Protegemos tus datos y tomamos medidas para garantizar la seguridad de tu cuenta.

### Compartir tus Datos

No compartimos tus datos personales con terceros, excepto en las siguientes situaciones:

- **Cumplimiento Legal**: Podemos divulgar tus datos si estamos obligados por la ley.
- **Protección de Derechos**: Podemos compartir tus datos para proteger nuestros derechos y los derechos de otros usuarios.

### Tus Derechos

Tienes derecho a:

- Acceder a tus datos personales.
- Corregir tus datos si son inexactos.
- Eliminar tus datos si deseas cerrar tu cuenta.
- Oponerte al procesamiento de tus datos en ciertas circunstancias.

### Cambios en la Política de Privacidad

Nos reservamos el derecho de modificar esta política en cualquier momento. Te notificaremos sobre cambios significativos a través de nuestra aplicación.

Si tienes preguntas o inquietudes sobre esta política, contáctanos en [Agsysteminformation@gmail.com](mailto:Agsysteminformation@gmail.com).

Gracias por utilizar nuestra aplicación.

    ''',
        ),

      );
      
    }
   } 
  
  
 