import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/models/driver_model.dart';

class DriverViewState {
  DriverViewState({
    required this.textEditsDriver,
    required this.type,
    required this.selectedCompany,
    required this.orderIndex,
    required this.orderType,
    required this.defaultTruck,
    required this.mobileAuth,
  });

  final List<TextEditingController> textEditsDriver;
  String type;
  String selectedCompany;
  DriverDefaultTruck defaultTruck;
  int orderIndex;
  String orderType;
  bool mobileAuth;

  DriverViewState copyWith({
    List<TextEditingController>? textEditsDriver,
    String? type,
    String? selectedCompany,
    DriverDefaultTruck? defaultTruck,
    int? orderIndex,
    String? orderType,
    bool? mobileAuth,
  }) {
    return DriverViewState(
      textEditsDriver: textEditsDriver ?? this.textEditsDriver,
      type: type ?? this.type,
      selectedCompany: selectedCompany ?? this.selectedCompany,
      orderIndex: orderIndex ?? this.orderIndex,
      orderType: orderType ?? this.orderType,
      defaultTruck: defaultTruck ?? this.defaultTruck,
      mobileAuth: mobileAuth ?? this.mobileAuth,
    );
  }
}

class DriverViewController extends StateNotifier<DriverViewState> {
  DriverViewController(super.state);

  void startTextEdits() {
    for (final controller in state.textEditsDriver) {
      controller.addListener(() {
        state = state.copyWith(
          textEditsDriver: [
            ...state.textEditsDriver,
          ],
        );
      });
    }
  }

  /// Firma Seçmek İçin
  void selectCompany(String company) {
    state = state.copyWith(selectedCompany: company);
  }

  /// Şoförün Mobil Yetkisini Açıp Kaptmak İçin
  void setMobileAuth(bool value) {
    state = state.copyWith(mobileAuth: value);
  }

  void setOrderIndex(int index) {
    state = state.copyWith(orderIndex: index);
  }

  String setOrderType(String type) {
    state = state.copyWith(orderType: type);
    return type;
  }

  void reset() {
    for (var i in state.textEditsDriver) {
      i.clear();
    }
    state.selectedCompany = '';
    state.type = '';
    state.orderIndex = 0;
    state.orderType = 'ASC';
    state.defaultTruck = DriverDefaultTruck.empty();
    state.mobileAuth = true;
  }
}

final driverViewCP = StateNotifierProvider.autoDispose<DriverViewController, DriverViewState>(
  (ref) {
    return DriverViewController(
      DriverViewState(
        textEditsDriver: List.generate(4, (_) => TextEditingController()),
        type: '',
        selectedCompany: '',
        orderIndex: 0,
        orderType: 'ASC',
        defaultTruck: DriverDefaultTruck.empty(),
        mobileAuth: true,
      ),
    );
  },
);
