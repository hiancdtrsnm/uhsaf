import 'package:meta/meta.dart';

class SAFModel {
  int id;
  final String municipality;
  final String saf;
  final String name;
  final String address;
  final String identifier;
  final String assistance;
  final String satisfaction;
  final String quality;
  final String opinions;
  final String causes;

  SAFModel({
    @required this.municipality,
    @required this.saf,
    @required this.name,
    @required this.address,
    @required this.identifier,
    @required this.assistance,
    @required this.satisfaction,
    @required this.quality,
    @required this.opinions,
    @required this.causes,
    this.id,
  });

  static SAFModel fromJson(Map<String, dynamic> json) {
    return SAFModel(
      municipality: json['municipality'] as String,
      saf: json['saf'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      identifier: json['identifier'] as String,
      assistance: json['assistance'] as String,
      satisfaction: json['satisfaction'] as String,
      quality: json['quality'] as String,
      opinions: json['opinions'] as String,
      causes: json['causes'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'municipality': municipality,
      'saf': saf,
      'name': name,
      'address': address,
      'identifier': identifier,
      'assistance': assistance,
      'satisfaction': satisfaction,
      'quality': quality,
      'opinions': opinions,
      'causes': causes,
    };
  }
}
