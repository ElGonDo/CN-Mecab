// ignore_for_file: file_names, prefer_const_constructors, avoid_print, non_constant_identifier_names
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/search/services/ProfileDataDialog.dart';
import 'package:flutter/material.dart';

Future<void> showPopupProfileDataSearch(
    BuildContext context,
    String name,
    String role,
    String uid,
    String URlString,
    String currentUser,
    List<Publicacion> publicacionesNR,
    List<PublicacionR> publicacionesR) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ProfileDataDialog(
          name: name,
          role: role,
          uid: uid,
          URlString: URlString,
          currentUser: currentUser,
          publicacionesNR: publicacionesNR,
          publicacionesR: publicacionesR);
    },
  );
}
