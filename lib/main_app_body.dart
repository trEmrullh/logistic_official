import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/utils/screen_utils.dart';
import 'package:logistic_official/widget/aod_location.dart';
import 'package:logistic_official/widget/left_menu.dart';

import 'pages/dashboard_page.dart';
import 'pages/drivers_page.dart';
import 'pages/jobs_page.dart';
import 'pages/locations_page.dart';
import 'pages/routes_page.dart';
import 'pages/trucks_page.dart';
import 'widget/aod_job.dart';

class MainAppBody extends StatefulWidget {
  const MainAppBody({super.key});

  @override
  State<MainAppBody> createState() => _MainAppBodyState();
}

class _MainAppBodyState extends State<MainAppBody> {
  int _currentIndex = 0;

  final List<Widget> pages = const [
    DashboardPage(),
    JobsPage(),
    LocationsPage(),
    RoutesPage(),
    DriversPage(),
    TrucksPage(),
  ];

  final List<Map<String, dynamic>> pageNameAndIcon = [
    {"name": 'Dashboard', "icon": FontAwesomeIcons.house},
    {"name": 'İşler', "icon": FontAwesomeIcons.compass},
    {"name": 'Yerler', "icon": FontAwesomeIcons.locationDot},
    {"name": 'Güzergahlar', "icon": FontAwesomeIcons.route},
    {"name": 'Şoförler', "icon": FontAwesomeIcons.users},
    {"name": 'Tırlar', "icon": FontAwesomeIcons.truck},
    // {"name": 'Harcırahlar', "icon": FontAwesomeIcons.moneyCheckDollar},
    // {"name": 'Kullanıcılar', "icon": FontAwesomeIcons.peopleRoof},
    // {"name": 'Medya ve Veriler', "icon": FontAwesomeIcons.database},
    // {"name": 'Loglar', "icon": FontAwesomeIcons.chartSimple},
  ];

  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    return Scaffold(
      appBar: !largeScreen
          ? AppBar(
              title: const Text('4E LOJİSTİK'),
              actions: _currentIndex != 0
                  ? [
                      IconButton(
                        onPressed: () {
                          switch (_currentIndex) {
                            case 1:
                              showGeneralDialog(
                                context: context,
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return aodJob(context);
                                },
                              );

                              break;

                            case 2:
                              showGeneralDialog(
                                context: context,
                                pageBuilder: (context, animation, secondaryAnimation) {
                                  return aodLocation();
                                },
                              );
                              break;
                          }
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.plus,
                          size: 20,
                        ),
                      ),
                    ]
                  : null,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: largeScreen
            ? Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: AppLeftMenu(
                      onIndexChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                  ),
                  const VerticalDivider(),
                  Expanded(
                    flex: 9,
                    child: pages[_currentIndex],
                  ),
                ],
              )
            : pages[_currentIndex],
      ),
      bottomNavigationBar: largeScreen
          ? null
          : BottomNavigationBar(
              currentIndex: _currentIndex,
              items: List.generate(
                pageNameAndIcon.length,
                (index) {
                  return BottomNavigationBarItem(
                    backgroundColor: AppColors.orange,
                    icon: Icon(pageNameAndIcon[index]['icon']),
                    label: pageNameAndIcon[index]['name'],
                  );
                },
              ),
              onTap: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
            ),
    );
  }
}
