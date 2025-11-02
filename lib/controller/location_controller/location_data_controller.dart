import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/models/location_model.dart';

class LocationDataState {
  LocationDataState({
    this.isLoading,
    this.isLoadingAddOrEdit,
    required this.locations,
  });

  bool? isLoading;
  bool? isLoadingAddOrEdit;
  List<LocationModel> locations;

  LocationDataState copyWith({
    bool? isLoading,
    bool? isLoadingAddOrEdit,
    List<LocationModel>? locations,
  }) {
    return LocationDataState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingAddOrEdit: isLoadingAddOrEdit ?? this.isLoadingAddOrEdit,
      locations: locations ?? this.locations,
    );
  }
}

class LocationDataController extends StateNotifier<LocationDataState> {
  LocationDataController(super.state);

  final String _collectionName = 'Locations';
  StreamSubscription? _locationsSubscription;
  List<LocationModel>? _fullLocationList;

  /// Yerleri Getirir.
  Future<void> locationsStream() async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoading: true);

    await Future.delayed(Duration(milliseconds: 500));

    await _locationsSubscription?.cancel();

    Query<Map<String, dynamic>> query = collection.where(
      'isDeleted',
      isEqualTo: false,
    );

    _locationsSubscription = query.snapshots().listen(
      (QuerySnapshot<Map<String, dynamic>> event) {
        if (event.docs.isNotEmpty) {
          final locations = event.docs.map((doc) {
            return LocationModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            });
          }).toList();

          _fullLocationList = List.from(locations);

          locations.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

          state = state.copyWith(
            locations: locations,
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            locations: [],
            isLoading: false,
          );
        }
      },
    );
  }

  /// Yeni Yer Ekler.
  Future<LocationModel?> addLocation(LocationModel location) async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoadingAddOrEdit: true);

    await Future.delayed(Duration(milliseconds: 500));

    try {
      DocumentReference<Map<String, dynamic>> response = await collection.add(location.toJson());

      if (response.id != '') {
        state = state.copyWith(isLoadingAddOrEdit: false);

        return LocationModel.fromJson({
          'id': response.id,
          ...location.toJson(),
        });
      } else {
        return null;
      }
    } catch (e) {
      state = state.copyWith(isLoadingAddOrEdit: false);
      throw Exception(e.toString());
    }
  }

  /// Yer Düzenleme
  Future<void> updateLocation(String locationID, Map<String, dynamic> location) async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoadingAddOrEdit: true);

    await Future.delayed(Duration(milliseconds: 500));

    try {
      await collection.doc(locationID).update(location);

      state = state.copyWith(isLoadingAddOrEdit: false);
    } catch (e) {
      state = state.copyWith(isLoadingAddOrEdit: false);
      throw Exception(e.toString());
    }
  }

  /// Yer Silme
  Future<void> deleteLocation(String locationID, String userID) async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoadingAddOrEdit: true);

    await Future.delayed(Duration(milliseconds: 500));

    try {
      await collection.doc(locationID).update({
        'isDeleted': true,
        'updateDate': '${DateTime.now()}',
        'updateID': userID,
      });

      state = state.copyWith(isLoadingAddOrEdit: false);
    } catch (e) {
      state = state.copyWith(isLoadingAddOrEdit: false);
      throw Exception(e.toString());
    }
  }

  /// Yerleri İsimlerine Göre Sıralar
  void sortLocationsByName(String orderType, String orderField) {
    List<LocationModel> sortedLocations = List.from(state.locations);

    if (orderType == 'ASC') {
      switch (orderField) {
        case 'name':
          sortedLocations.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
          break;
        case 'city':
          sortedLocations.sort((a, b) => a.city.cityName.toLowerCase().compareTo(b.city.cityName.toLowerCase()));
          break;
        case 'type':
          sortedLocations.sort((a, b) => a.type!.toLowerCase().compareTo(b.type!.toLowerCase()));
          break;
      }
    } else {
      switch (orderField) {
        case 'name':
          sortedLocations.sort((a, b) => b.name!.toLowerCase().compareTo(a.name!.toLowerCase()));
          break;
        case 'city':
          sortedLocations.sort((a, b) => b.city.cityName.toLowerCase().compareTo(a.city.cityName.toLowerCase()));
          break;
        case 'type':
          sortedLocations.sort((a, b) => b.type!.toLowerCase().compareTo(a.type!.toLowerCase()));
          break;
      }
    }

    state = state.copyWith(locations: sortedLocations);
  }

  // void searchItem(String searchText, String orderField) {
  //   if (searchText.isEmpty) {
  //     locationsStream();
  //   } else {
  //     List<LocationModel> filteredLocations = state.locations.where((location) {
  //       switch (orderField) {
  //         case 'name':
  //           return location.name!.toLowerCase().contains(searchText.toLowerCase());
  //         case 'city':
  //           return location.city.cityName.toLowerCase().contains(searchText.toLowerCase());
  //         case 'type':
  //           return location.type!.toLowerCase().contains(searchText.toLowerCase());
  //         default:
  //           return false;
  //       }
  //     }).toList();
  //
  //     state = state.copyWith(locations: filteredLocations);
  //   }
  // }

  void searchItem(String searchText) {
    if (searchText.isEmpty) {
      state = state.copyWith(locations: _fullLocationList);
    } else {
      List<LocationModel> filteredLocations = _fullLocationList!.where((location) {
        // Herhangi bir alanda arama metni geçiyorsa true döner
        return location.name!.toLowerCase().contains(searchText.toLowerCase()) ||
            location.city.cityName.toLowerCase().contains(searchText.toLowerCase()) ||
            location.type!.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      state = state.copyWith(locations: filteredLocations);
    }
  }
}

final locationDataCP = StateNotifierProvider.autoDispose<LocationDataController, LocationDataState>(
  (ref) {
    return LocationDataController(
      LocationDataState(
        locations: [],
      ),
    );
  },
);
