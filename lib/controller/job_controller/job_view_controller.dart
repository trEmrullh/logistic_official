import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/enums/shipping_type_enums.dart';

class JobViewState {
  JobViewState({
    required this.shippingType,
  });

  ShippingType shippingType;

  JobViewState copyWith({ShippingType? shippingType}) {
    return JobViewState(
      shippingType: shippingType ?? this.shippingType,
    );
  }
}

class JobViewController extends StateNotifier<JobViewState> {
  JobViewController(super.state);

  void selectShippingType(ShippingType shippingType) {
    state = state.copyWith(shippingType: shippingType);
  }
}

final jobViewCP = StateNotifierProvider<JobViewController, JobViewState>(
  (ref) {
    return JobViewController(
      JobViewState(
        shippingType: ShippingType.none,
      ),
    );
  },
);
