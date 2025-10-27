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

  @override
  void dispose() {
    _locationsSubscription?.cancel();
    print('LOCATİON AUTO DİSPOSE');
    super.dispose();
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
