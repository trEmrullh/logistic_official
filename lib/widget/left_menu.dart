import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistic_official/constants/app_color.dart';

class AppLeftMenu extends ConsumerStatefulWidget {
  const AppLeftMenu({
    super.key,
    required this.onIndexChanged,
  });

  final void Function(int) onIndexChanged;

  @override
  ConsumerState<AppLeftMenu> createState() => _AppLeftMenuState();
}

class _AppLeftMenuState extends ConsumerState<AppLeftMenu> {
  int selectedIndex = 0;
  int? _hoverIndex;

  final List<Map<String, dynamic>> leftMenuItems = [
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
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: AppColors.darkOrange,
          child: Text(
            'EO',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'HOŞGELDİNİZ',
          style: TextStyle(
            fontSize: 13,
            color: Colors.black,
          ),
        ),
        Text(
          'Emrullah Orhan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 5),
            itemCount: leftMenuItems.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (event) {
                  setState(() {
                    _hoverIndex = index;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _hoverIndex = null;
                  });
                },
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });

                    widget.onIndexChanged(selectedIndex);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: selectedIndex == index
                          ? AppColors.darkOrange
                          : _hoverIndex == index
                          ? AppColors.orangeHover
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 30,
                          child: FaIcon(
                            leftMenuItems[index]['icon'],
                            color: selectedIndex == index ? AppColors.white : AppColors.black,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            leftMenuItems[index]['name'],
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedIndex == index ? AppColors.white : AppColors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Çıkış Yap',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
