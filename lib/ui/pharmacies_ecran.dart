// lib/screens/pharmacies_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_pharmacies_2023/models/pharmacie.dart';
import 'package:flutter_pharmacies_2023/services/pharmacie_service.dart';

class PharmaciesEcran extends StatefulWidget {
  @override
  _PharmaciesEcranState createState() => _PharmaciesEcranState();
}

class _PharmaciesEcranState extends State<PharmaciesEcran> {
  final PharmacieService pharmacieService = PharmacieService();

  Future<List<Pharmacie>> chargerPharmacies() async {
    try {
      final pharmacies = await pharmacieService.chargerPharmacies();
      return pharmacies;
    } catch (e) {
      throw Exception('Erreur de chargement des pharmacies: $e');
    }
  }

  List<Pharmacie> _pharmacies = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des pharmacies'),
      ),
      body: FutureBuilder<List<Pharmacie>>(
        future: chargerPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('Aucune pharmacie disponible.'),
            );
          } else {
            final pharmacies = snapshot.data!;
            return ListView.builder(
              itemCount: pharmacies.length,
              itemBuilder: (context, index) {
                final pharmacie = pharmacies[index];
                return ListTile(
                   title: Text(pharmacie.nom),
                  subtitle: Text('Quartier: ${pharmacie.quartier}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => supprimerPharmacie(pharmacie.id),
                  ),
                  //Compléter l'affichage
                  // Un bouton pour la suppression
                  onTap: () {
                    //Affichage de la page de détails
                       Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PharmacieDetailsPage(pharmacie: pharmacie),
                           ),
                           );
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: //Ajout d'une pharmacie
                  () async {
    // Navigate to the AddPharmacieScreen and wait for the result
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => AddPharmacieScreen()),
    );

    // If a pharmacy was added, refresh the list
    if (result == true) {
      setState(() {
        futurePharmacies = chargerPharmacies();
      });
    }
  },
            
        tooltip: 'Ajouter une pharmacie',
        child: Icon(Icons.add),
      ),
    );
  }
}
