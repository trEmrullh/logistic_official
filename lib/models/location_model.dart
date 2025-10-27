import 'package:logistic_official/models/city_model.dart';

class LocationModel {
  LocationModel({
    this.id,
    this.type,
    this.name,
    required this.city,
    this.maps,
    this.isDeleted,
    required this.createDate,
    required this.updateDate,
    required this.createID,
    required this.updateID,
  });

  final String? id;
  final String? type;
  final String? name;
  final City city;
  final String? maps;
  final bool? isDeleted;
  final String? createDate;
  final String? updateDate;
  final String? createID;
  final String? updateID;

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      type: json['type'],
      name: json['name'],
      city: City.fromJson(json['city']),
      maps: json['maps'],
      isDeleted: json['isDeleted'],
      createDate: json['createDate'],
      updateDate: json['updateDate'],
      createID: json['createID'],
      updateID: json['createID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'name': name,
      'city': city.toJson(),
      'maps': maps,
      'isDeleted': isDeleted,
      'createDate': createDate,
      'updateDate': updateDate,
      'createID': createID,
      'updateID': updateID,
    };
  }

  factory LocationModel.empty() {
    return LocationModel(
      id: '',
      type: '',
      name: '',
      city: City.empty(),
      maps: '',
      isDeleted: false,
      createDate: '',
      updateDate: '',
      createID: '',
      updateID: '',
    );
  }
}
