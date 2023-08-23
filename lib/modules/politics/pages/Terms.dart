import 'package:flutter/material.dart';
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// ignore: camel_case_types
class Terminos extends StatelessWidget{
  const Terminos({super.key});
  
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
## Términos y Condiciones

**Última actualización: 23 de agosto del 2023**

Bienvenido a nuestra aplicación. Antes de utilizarla, te pedimos que leas detenidamente estos Términos y Condiciones.

### 1. Aceptación de los Términos

Al utilizar nuestra aplicación, aceptas automáticamente cumplir con estos Términos y Condiciones. Si no estás de acuerdo con alguno de los términos, te pedimos que dejes de usar la aplicación de inmediato.

### 2. Uso Responsable

Debes utilizar nuestra aplicación de manera responsable y ética. No puedes realizar acciones que puedan dañar la aplicación, otros usuarios o violar las leyes locales o internacionales.

### 3. Privacidad

Respetamos tu privacidad. Consulta nuestra [Política de Privacidad](politics) para obtener información sobre cómo manejamos tus datos personales.

### 4. Contenido Generado por el Usuario

Si contribuyes con contenido a nuestra aplicación, debes asegurarte de que sea apropiado y respetuoso. Nos reservamos el derecho de eliminar cualquier contenido que consideremos inapropiado.

### 5. Modificaciones de los Términos

Nos reservamos el derecho de modificar estos Términos y Condiciones en cualquier momento. Te recomendamos revisarlos periódicamente para estar al tanto de los cambios.

Gracias por utilizar nuestra aplicación. Si tienes alguna pregunta o inquietud, no dudes en contactarnos.

[Contáctanos](mailto:Agsysteminformation@gmail.com)
        
        ''',
      ),

        );
      
    }
   } 