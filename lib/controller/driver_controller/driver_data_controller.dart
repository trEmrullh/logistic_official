import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/models/driver_model.dart';

class DriverDataState {
  DriverDataState({
    this.isLoading,
    this.isLoadingAddOrEdit,
    required this.drivers,
  });

  bool? isLoading;
  bool? isLoadingAddOrEdit;
  List<DriverModel> drivers;

  DriverDataState copyWith({
    bool? isLoading,
    bool? isLoadingAddOrEdit,
    List<DriverModel>? drivers,
  }) {
    return DriverDataState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingAddOrEdit: isLoadingAddOrEdit ?? this.isLoadingAddOrEdit,
      drivers: drivers ?? this.drivers,
    );
  }
}

class DriverDataController extends StateNotifier<DriverDataState> {
  DriverDataController(super.state);

  final String _collectionName = 'Drivers';
  StreamSubscription? _driverSubscription;
  List<DriverModel>? _fullDriverList;

  /// Şoförleri Getirir.
  Future<void> driversStream() async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoading: true);

    await Future.delayed(Duration(milliseconds: 500));

    await _driverSubscription?.cancel();

    Query<Map<String, dynamic>> query = collection.where('isDeleted', isEqualTo: false);

    _driverSubscription = query.snapshots().listen(
      (QuerySnapshot<Map<String, dynamic>> event) {
        if (event.docs.isNotEmpty) {
          final drivers = event.docs.map((doc) {
            return DriverModel.fromJson({
              'id': doc.id,
              ...doc.data(),
            });
          }).toList();

          _fullDriverList = List.from(drivers);

          drivers.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));

          state = state.copyWith(
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            isLoading: false,
          );
        }
      },
    );
  }

  /// Yeni Şoför Ekler.
  Future<DriverModel?> addDriver(DriverModel location) async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoadingAddOrEdit: true);

    await Future.delayed(Duration(milliseconds: 500));

    try {
      DocumentReference<Map<String, dynamic>> response = await collection.add(location.toJson());

      if (response.id != '') {
        state = state.copyWith(isLoadingAddOrEdit: false);

        return DriverModel.fromJson({
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

  /// Şoför Düzenleme
  Future<void> updateDriver(String driverID, Map<String, dynamic> location) async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoadingAddOrEdit: true);

    await Future.delayed(Duration(milliseconds: 500));

    try {
      await collection.doc(driverID).update(location);

      state = state.copyWith(isLoadingAddOrEdit: false);
    } catch (e) {
      state = state.copyWith(isLoadingAddOrEdit: false);
      throw Exception(e.toString());
    }
  }

  /// Şoför Silme
  Future<void> deleteLocation(String driverID, String userID) async {
    var firebase = FirebaseFirestore.instance;
    var collection = firebase.collection(_collectionName);

    state = state.copyWith(isLoadingAddOrEdit: true);

    await Future.delayed(Duration(milliseconds: 500));

    try {
      await collection.doc(driverID).update({
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

  /// Şoförleri Sıralar
  void sortLocationsByName(String orderType, String orderField) {
    List<DriverModel> sortedDrivers = List.from(state.drivers);

    if (orderType == 'ASC') {
      switch (orderField) {
        case 'name':
          sortedDrivers.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
          break;
        case 'surname':
          sortedDrivers.sort((a, b) => a.surname!.toLowerCase().compareTo(b.surname!.toLowerCase()));
          break;
        case 'phoneNo':
          sortedDrivers.sort((a, b) => a.phoneNo!.toLowerCase().compareTo(b.phoneNo!.toLowerCase()));
          break;
        case 'password':
          sortedDrivers.sort((a, b) => a.password!.toLowerCase().compareTo(b.password!.toLowerCase()));
          break;
        case 'company':
          sortedDrivers.sort((a, b) => a.company!.toLowerCase().compareTo(b.company!.toLowerCase()));
          break;
        case 'plate':
          sortedDrivers.sort((a, b) => a.driverDefaultTruck!.plate.toLowerCase().compareTo(b.driverDefaultTruck!.plate.toLowerCase()));
          break;
      }
    } else {
      switch (orderField) {
        case 'name':
          sortedDrivers.sort((a, b) => b.name!.toLowerCase().compareTo(a.name!.toLowerCase()));
          break;
        case 'surname':
          sortedDrivers.sort((a, b) => b.surname!.toLowerCase().compareTo(a.surname!.toLowerCase()));
          break;
        case 'phoneNo':
          sortedDrivers.sort((a, b) => b.phoneNo!.toLowerCase().compareTo(a.phoneNo!.toLowerCase()));
          break;
        case 'password':
          sortedDrivers.sort((a, b) => b.password!.toLowerCase().compareTo(a.password!.toLowerCase()));
          break;
        case 'company':
          sortedDrivers.sort((a, b) => b.company!.toLowerCase().compareTo(a.company!.toLowerCase()));
          break;
        case 'plate':
          sortedDrivers.sort((a, b) => b.driverDefaultTruck!.plate.toLowerCase().compareTo(a.driverDefaultTruck!.plate.toLowerCase()));
          break;
      }
    }
  }

  void searchItem(String searchText) {
    if (searchText.isEmpty) {
      state = state.copyWith(drivers: _fullDriverList);
    } else {
      List<DriverModel> filteredDriver = _fullDriverList!.where((location) {
        // Herhangi bir alanda arama metni geçiyorsa true döner
        return location.name!.toLowerCase().contains(searchText.toLowerCase());
      }).toList();

      state = state.copyWith(drivers: filteredDriver);
    }
  }
}

final driverDataCP = StateNotifierProvider.autoDispose<DriverDataController, DriverDataState>(
  (ref) {
    return DriverDataController(
      DriverDataState(
        drivers: [],
      ),
    );
  },
);
