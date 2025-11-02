import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/models/city_model.dart';

class LocationViewState {
  LocationViewState({
    required this.textEditsLocation,
    required this.type,
    required this.selectedCity,
    required this.orderIndex,
    required this.orderType,
  });

  final List<TextEditingController> textEditsLocation;
  String type;
  City selectedCity;
  int orderIndex;
  String orderType;

  LocationViewState copyWith({
    List<TextEditingController>? textEditsLocation,
    String? type,
    City? selectedCity,
    int? orderIndex,
    String? orderType,
  }) {
    return LocationViewState(
      textEditsLocation: textEditsLocation ?? this.textEditsLocation,
      type: type ?? this.type,
      selectedCity: selectedCity ?? this.selectedCity,
      orderIndex: orderIndex ?? this.orderIndex,
      orderType: orderType ?? this.orderType,
    );
  }
}

class LocationViewController extends StateNotifier<LocationViewState> {
  LocationViewController(super.state);

  void startTextEdits() {
    for (final controller in state.textEditsLocation) {
      controller.addListener(() {
        state = state.copyWith(
          textEditsLocation: [
            ...state.textEditsLocation,
          ],
        );
      });
    }
  }

  /// Lokasyon Tipi Seçmek İçin
  void selectType(String type) {
    state = state.copyWith(type: type);
  }

  /// Şehir Seçmek İçin
  void selectCity(City city) {
    state = state.copyWith(selectedCity: city);
  }

  void setOrderIndex(int index) {
    state = state.copyWith(orderIndex: index);
  }

  String setOrderType(String type) {
    //String type = state.orderType == 'ASC' ? 'DESC' : 'ASC';
    state = state.copyWith(orderType: type);
    return type;
  }

  void reset() {
    for (var i in state.textEditsLocation) {
      i.clear();
    }
    state.selectedCity = City.empty();
    state.type = '';
    state.orderIndex = 0;
    state.orderType = 'ASC';
  }
}

final locationViewCP = StateNotifierProvider.autoDispose<LocationViewController, LocationViewState>(
  (ref) {
    return LocationViewController(
      LocationViewState(
        textEditsLocation: List.generate(2, (_) => TextEditingController()),
        type: '',
        selectedCity: City.empty(),
        orderIndex: 0,
        orderType: 'ASC',
      ),
    );
  },
);
