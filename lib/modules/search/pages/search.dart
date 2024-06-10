// ignore_for_file: use_key_in_widget_constructors, file_names, prefer_interpolation_to_compose_strings, avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'package:cnmecab/modules/profile/services/objectUser.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsNoResenables.dart';
import 'package:cnmecab/modules/publications/getPublications/services/getPublicationsResenables.dart';
import 'package:cnmecab/modules/search/components/filterStars.dart';
import 'package:cnmecab/modules/search/services/displayProfileDataSearch.dart';
import 'package:cnmecab/modules/search/services/filterStarsData.dart';
import 'package:cnmecab/modules/search/services/searchService.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Search extends StatefulWidget {
  const Search({Key? key});

  @override
  State<Search> createState() => SearchState();
}

class SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  SearchService searchService = SearchService();
  List<Publicacion> publicacionesList = [];
  List<PublicacionR> publicacionesListR = [];
  String URlString = "";
  UserProfile? userProfile;
  int? selectedStarFilter;

  @override
  void initState() {
    super.initState();
    initializeSearch();
  }

  Future<void> initializeSearch() async {
    UserProfile? updatedProfile =
        await UserProfileSingleton().initializeUserProfile();
    setState(() {
      userProfile = updatedProfile;
      URlString = userProfile?.profileImageURL ?? '';
    });

    List<dynamic> values = await Future.wait([obtenerDatos(), obtenerDatosR()]);
    publicacionesList = values[0] as List<Publicacion>;
    publicacionesListR = values[1] as List<PublicacionR>;
  }

  void applyStarFilter(int starCount) async {
    List<PublicacionR> publicacionesFiltradas =
        await obtenerPublicacionesPorEstrellas(starCount);
    showFilteredResultsModal(context, publicacionesFiltradas, userProfile!.uid,
        TextEditingController(), URlString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    hintText: 'Busqueda',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.black),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchService.searchUsersByName(value);
                    });
                  },
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt, color: Colors.white),
              onPressed: () {
                FilterStars(onFilterSelected: applyStarFilter)
                    .showFilterModal(context);
              },
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: searchService.searchUsersByName(searchController.text),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("No se encontró nada");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 56,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return ListView(
            children: snapshot.data!.docs
                .where((doc) => doc['Nombre']
                    .toString()
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()))
                .map((QueryDocumentSnapshot doc) {
              String name = doc['Nombre'] ?? '';
              String role = doc['Rol'] ?? '';
              String uid = doc.id;
              return GestureDetector(
                onTap: () {
                  showPopupProfileDataSearch(
                      context,
                      name,
                      role,
                      uid,
                      URlString,
                      userProfile!.uid,
                      publicacionesList,
                      publicacionesListR);
                },
                child: Card(
                  child: ListTile(
                    title: Text(name),
                    subtitle: Text(role),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
