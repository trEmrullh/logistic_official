import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/models/city_model.dart';

class LocationViewState {
  LocationViewState({
    required this.textEditsLocation,
    required this.type,
    required this.selectedCity,
  });

  final List<TextEditingController> textEditsLocation;
  String type;
  City selectedCity;

  LocationViewState copyWith({
    List<TextEditingController>? textEditsLocation,
    String? type,
    City? selectedCity,
  }) {
    return LocationViewState(
      textEditsLocation: textEditsLocation ?? this.textEditsLocation,
      type: type ?? this.type,
      selectedCity: selectedCity ?? this.selectedCity,
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

  @override
  void dispose() {
    print('LOCATİON VİEW AUTO DİSPOSE');

    for (final controller in state.textEditsLocation) {
      controller.dispose();
    }

    state.textEditsLocation.clear();

    state.selectedCity = City.empty();
    state.type = '';

    super.dispose();
  }
}

final locationViewCP = StateNotifierProvider<LocationViewController, LocationViewState>(
  (ref) {
    return LocationViewController(
      LocationViewState(
        textEditsLocation: List.generate(2, (_) => TextEditingController()),
        type: '',
        selectedCity: City.empty(),
      ),
    );
  },
);
