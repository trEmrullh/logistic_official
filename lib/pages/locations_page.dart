import 'package:flutter/material.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/utils/screen_utils.dart';
import 'package:logistic_official/widget/aod_location.dart';

class LocationsPage extends StatefulWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  static const List<Map<String, dynamic>> _kOptions = [
    {"cityNo": 1, "cityName": "Adana"},
    {"cityNo": 2, "cityName": "Adıyaman"},
    {"cityNo": 3, "cityName": "Afyonkarahisar"},
    {"cityNo": 4, "cityName": "Ağrı"},
    {"cityNo": 5, "cityName": "Amasya"},
    {"cityNo": 6, "cityName": "Ankara"},
    {"cityNo": 7, "cityName": "Antalya"},
    {"cityNo": 8, "cityName": "Artvin"},
    {"cityNo": 9, "cityName": "Aydın"},
    {"cityNo": 10, "cityName": "Balıkesir"},
    {"cityNo": 11, "cityName": "Bilecik"},
    {"cityNo": 12, "cityName": "Bingöl"},
    {"cityNo": 13, "cityName": "Bitlis"},
    {"cityNo": 14, "cityName": "Bolu"},
    {"cityNo": 15, "cityName": "Burdur"},
    {"cityNo": 16, "cityName": "Bursa"},
    {"cityNo": 17, "cityName": "Çanakkale"},
    {"cityNo": 18, "cityName": "Çankırı"},
    {"cityNo": 19, "cityName": "Çorum"},
    {"cityNo": 20, "cityName": "Denizli"},
    {"cityNo": 21, "cityName": "Diyarbakır"},
    {"cityNo": 22, "cityName": "Edirne"},
    {"cityNo": 23, "cityName": "Elazığ"},
    {"cityNo": 24, "cityName": "Erzincan"},
    {"cityNo": 25, "cityName": "Erzurum"},
    {"cityNo": 26, "cityName": "Eskişehir"},
    {"cityNo": 27, "cityName": "Gaziantep"},
    {"cityNo": 28, "cityName": "Giresun"},
    {"cityNo": 29, "cityName": "Gümüşhane"},
    {"cityNo": 30, "cityName": "Hakkâri"},
    {"cityNo": 31, "cityName": "Hatay"},
    {"cityNo": 32, "cityName": "Isparta"},
    {"cityNo": 33, "cityName": "Mersin"},
    {"cityNo": 34, "cityName": "İstanbul"},
    {"cityNo": 35, "cityName": "İzmir"},
    {"cityNo": 36, "cityName": "Kars"},
    {"cityNo": 37, "cityName": "Kastamonu"},
    {"cityNo": 38, "cityName": "Kayseri"},
    {"cityNo": 39, "cityName": "Kırklareli"},
    {"cityNo": 40, "cityName": "Kırşehir"},
    {"cityNo": 41, "cityName": "Kocaeli"},
    {"cityNo": 42, "cityName": "Konya"},
    {"cityNo": 43, "cityName": "Kütahya"},
    {"cityNo": 44, "cityName": "Malatya"},
    {"cityNo": 45, "cityName": "Manisa"},
    {"cityNo": 46, "cityName": "Kahramanmaraş"},
    {"cityNo": 47, "cityName": "Mardin"},
    {"cityNo": 48, "cityName": "Muğla"},
    {"cityNo": 49, "cityName": "Muş"},
    {"cityNo": 50, "cityName": "Nevşehir"},
    {"cityNo": 51, "cityName": "Niğde"},
    {"cityNo": 52, "cityName": "Ordu"},
    {"cityNo": 53, "cityName": "Rize"},
    {"cityNo": 54, "cityName": "Sakarya"},
    {"cityNo": 55, "cityName": "Samsun"},
    {"cityNo": 56, "cityName": "Siirt"},
    {"cityNo": 57, "cityName": "Sinop"},
    {"cityNo": 58, "cityName": "Sivas"},
    {"cityNo": 59, "cityName": "Tekirdağ"},
    {"cityNo": 60, "cityName": "Tokat"},
    {"cityNo": 61, "cityName": "Trabzon"},
    {"cityNo": 62, "cityName": "Tunceli"},
    {"cityNo": 63, "cityName": "Şanlıurfa"},
    {"cityNo": 64, "cityName": "Uşak"},
    {"cityNo": 65, "cityName": "Van"},
    {"cityNo": 66, "cityName": "Yozgat"},
    {"cityNo": 67, "cityName": "Zonguldak"},
    {"cityNo": 68, "cityName": "Aksaray"},
    {"cityNo": 69, "cityName": "Bayburt"},
    {"cityNo": 70, "cityName": "Karaman"},
    {"cityNo": 71, "cityName": "Kırıkkale"},
    {"cityNo": 72, "cityName": "Batman"},
    {"cityNo": 73, "cityName": "Şırnak"},
    {"cityNo": 74, "cityName": "Bartın"},
    {"cityNo": 75, "cityName": "Ardahan"},
    {"cityNo": 76, "cityName": "Iğdır"},
    {"cityNo": 77, "cityName": "Yalova"},
    {"cityNo": 78, "cityName": "Karabük"},
    {"cityNo": 79, "cityName": "Kilis"},
    {"cityNo": 80, "cityName": "Osmaniye"},
    {"cityNo": 81, "cityName": "Düzce"},
  ];

  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    return Column(
      children: [
        if (largeScreen) ...[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkOrange,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: () {
              showGeneralDialog(
                context: context,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return aodLocation();
                },
              );
            },
            child: Text(
              'Yeni Yer Ekle',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 15),
        ],
        Autocomplete<Map<String, dynamic>>(
          displayStringForOption: (Map<String, dynamic> option) => option['cityName'],
          onSelected: (Map<String, dynamic> selectedCity) {
            print('Seçilen şehir: ${selectedCity['cityName']}');
            print('Plaka kodu: ${selectedCity['cityNo']}');
          },
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable.empty();
            }
            return _kOptions.where(
              (city) => city['cityName'].toLowerCase().contains(textEditingValue.text.toLowerCase()),
            );
          },
          fieldViewBuilder:
              (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Şehir Ara...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
        ),
      ],
    );
  }
}
