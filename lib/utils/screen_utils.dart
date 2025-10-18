import 'package:flutter/widgets.dart'; // BuildContext ve MediaQuery için
import 'package:flutter/foundation.dart'; // kIsWeb için

/// Web de ve geniş ekran ise
// bool isLargeWebScreen(BuildContext context) {
//   final double deviceWidth = MediaQuery.of(context).size.width;
//
//   return deviceWidth > 800 && kIsWeb;
// }
//
// /// Sadece web ise
// bool get isRunningOnWeb => kIsWeb;
//
// bool get isRunningOnMobile =>
//     !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

bool isLargeScreen(BuildContext context) {
  final double deviceWidth = MediaQuery.of(context).size.width;

  return deviceWidth > 800;
}
