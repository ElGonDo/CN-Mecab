// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/src/material/icons.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

// ignore: camel_case_types
class comunity extends StatelessWidget {
  const comunity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Center(
          child: RichText(
            text: const TextSpan(
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
## Normas de la Comunidad

**Última actualización: 23 de agosto del 2023**

La comunidad de CnMecab tiene una normativa que ayuda a mantener una comunidad sana entre los usuarios. Si tu comentario o publicación promueve el odio o se considera algún tipo de gravedad dentro de las normas de la comunidad, será eliminado por nosotros los administradores. Recuerda que si incumples 5 normas de la comunidad, serás vetado de la app. Para más información, consulta las normas de la comunidad dentro de la app de CnMecab.

### Normas Principales

1. **Respeto y Civismo**:
   - Fomenta un ambiente de respeto y cortesía en todas las interacciones.
   - Los ataques personales, el acoso y los insultos están prohibidos.
   - Mantén un lenguaje adecuado y evita el uso de palabras ofensivas.

2. **Contenido Apropiado**:
   - No se permite contenido que promueva el odio, la violencia o la discriminación.
   - Esto incluye, pero no se limita a, contenido basado en raza, etnia, religión, género, orientación sexual, discapacidad u otras características protegidas.
   - Evita publicar contenido que pueda resultar ofensivo o perturbador para otros usuarios.

3. **Privacidad y Seguridad**:
   - No compartas información personal tuya o de otros sin consentimiento.
   - No está permitido el uso de la plataforma para actividades fraudulentas o engañosas.
   - Protege tus datos personales y evita compartir contraseñas o información confidencial.

4. **Integridad y Autenticidad**:
   - No publiques contenido falso o engañoso.
   - Evita la suplantación de identidad o la creación de perfiles falsos.
   - Asegúrate de que toda la información que compartes sea verídica y esté bien documentada.

5. **Seguridad de Menores**:
   - No se permite contenido que explote o ponga en peligro a menores de edad.
   - Protege la identidad y la privacidad de los menores en cualquier contenido que publiques.
   - Denuncia cualquier comportamiento sospechoso que involucre a menores.

6. **No Promoción de Actividades Ilegales**:
   - No se permite contenido que promueva actividades ilegales o peligrosas.
   - Esto incluye, pero no se limita a, drogas, armas, fraude y cualquier otra actividad delictiva.
   - Reporta cualquier contenido que consideres ilegal o perjudicial.

7. **Propiedad Intelectual**:
   - Respeta los derechos de autor y la propiedad intelectual de otros.
   - No publiques contenido que no te pertenezca sin el permiso adecuado.
   - Asegúrate de tener los derechos necesarios para compartir cualquier contenido que publiques.

8. **Evitar el Spam**:
   - No se permite el envío de mensajes no solicitados o spam.
   - Evita la autopromoción excesiva o el uso de la plataforma para fines comerciales no autorizados.
   - Participa en la comunidad de manera auténtica y respetuosa.

### Consecuencias por Incumplimiento

- **Eliminación de Comentarios y Publicaciones**:
  - Si tu comentario o publicación promueve el odio o se considera de gravedad, será eliminada por los administradores.
  - Mantén un comportamiento adecuado para evitar sanciones.

- **Veto de la App**:
  - Si incumples 5 normas de la comunidad, serás vetado de la app, perdiendo acceso a tu cuenta y a todas las funcionalidades de CnMecab.
  - El veto es una medida seria para proteger a la comunidad.

- **Borrado de la Cuenta**:
  - El incumplimiento reiterado de las normas de la comunidad resultará en el borrado de tu cuenta. Esto sucede después de haber incumplido nuestras normas 5 veces. Al perder tu cuenta, perderás acceso a todas tus publicaciones, comentarios y cualquier otra interacción dentro de la app.
  - La protección de la comunidad es nuestra prioridad y tomaremos las medidas necesarias para mantenerla segura.

### Información Adicional

Para más información y detalles sobre las normas de la comunidad, consulta la sección de normas dentro de la app de CnMecab. Mantener la comunidad de CnMecab segura y respetuosa es responsabilidad de todos. 

---

Gracias por ser parte de nuestra comunidad y por contribuir a un entorno seguro y respetuoso.
        ''',
      ),
    );
  }
}