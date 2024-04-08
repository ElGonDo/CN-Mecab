// ignore_for_file: file_names
import 'package:cnmecab/modules/Post_show/show_post_Resenables.dart';
import 'package:cnmecab/modules/Post_show/show_posts_No_Resenables.dart';

Future<Map<String, List<dynamic>>> obtenerMisPublicaciones(
    String uidUsuarioActual,
    List<Publicacion> publicacionesNR,
    List<PublicacionR> publicacionesR) async {
  List<Publicacion> newMisPublicacionesNR = [];
  List<PublicacionR> newMisPublicacionesR = [];

  // Buscar coincidencias en las listas publicacionesNR y publicacionesR
  for (Publicacion publicacion in publicacionesNR) {
    if (publicacion.uid == uidUsuarioActual) {
      newMisPublicacionesNR.add(publicacion);
    }
  }
  for (PublicacionR publicacionR in publicacionesR) {
    if (publicacionR.ruid == uidUsuarioActual) {
      newMisPublicacionesR.add(publicacionR);
    }
  }
  // Retornar las nuevas listas en un Map
  return {
    "mispublicacionesNR": newMisPublicacionesNR,
    "mispublicacionesR": newMisPublicacionesR
  };
}
