import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/firebase_options.dart';
import 'package:logistic_official/main_app_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '4E LOJİSTİK YÖNETİM PANELİ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
        ),
        useMaterial3: true,
        fontFamily: 'Oxanium',
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.orange,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColors.white,
          ),
          titleTextStyle: TextStyle(
            fontFamily: 'Oxanium',
            fontSize: 28,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: AppColors.black,
          selectedIconTheme: IconThemeData(
            size: 30,
            color: AppColors.black,
          ),
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          unselectedIconTheme: IconThemeData(
            size: 25,
            color: AppColors.white,
          ),
        ),
      ),
      home: MainAppBody(),
    );
  }
}
