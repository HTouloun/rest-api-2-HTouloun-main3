import 'package:uuid/uuid.dart';

class Pharmacie {
  String id; // Mappé à recordid
  String nom; // Mappé à pharmacie
  String quartier; // Mappé à quartier
  double latitude;
  double longitude;

  Pharmacie({
    String? id,
    required this.nom,
    required this.quartier,
    required this.latitude,
    required this.longitude,
  }) : id = id ?? const Uuid().v4();

  //Ajouter ce qu'il faut pour les conversions JSON: Pharmacie.fromJson et toJson

  factory Pharmacie.fromJson(Map<String, dynamic> json) {
    return Pharmacie(
      id: json['id'].toString(),
      nom: json['name'],
      quartier: json['address']['city'],
      latitude: double.parse(json['address']['geo']['lat']),
      longitude: double.parse(json['address']['geo']['lng']),
    );
  }

  // Method for converting Pharmacie instance to a map (JSON).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': nom,
      'address': {
        'city': quartier,
        'geo': {
          'lat': latitude.toString(),
          'lng': longitude.toString(),
        },
      },
    };
  }

}
