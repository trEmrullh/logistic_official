import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/controller/location_controller/location_data_controller.dart';
import 'package:logistic_official/controller/location_controller/location_view_controller.dart';
import 'package:logistic_official/models/city_model.dart';
import 'package:logistic_official/models/location_model.dart';
import 'package:logistic_official/utils/screen_utils.dart';

class AoULocation extends ConsumerStatefulWidget {
  const AoULocation({
    super.key,
    required this.isUpdate,
    this.location,
  });

  final bool isUpdate;
  final LocationModel? location;

  @override
  ConsumerState<AoULocation> createState() => _AodLocationState();
}

class _AodLocationState extends ConsumerState<AoULocation> {
  late LocationViewController _locationViewController;

  @override
  void initState() {
    _locationViewController = ref.read(locationViewCP.notifier);

    Future.microtask(() {
      _locationViewController.startTextEdits();
    });
    super.initState();
  }

  @override
  void dispose() {
    Future.microtask(() {
      _locationViewController.reset();
    });

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    final locationVS = ref.watch(locationViewCP);
    final locationDS = ref.watch(locationDataCP);

    return GestureDetector(
      onTap: !largeScreen
          ? () {
              FocusScope.of(context).unfocus();
            }
          : null,
      child: Scaffold(
        appBar: !largeScreen
            ? AppBar(
                title: Text('Yeni Yer Ekle'),
                centerTitle: true,
              )
            : null,
        body: locationDS.isLoadingAddOrEdit == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: !largeScreen ? EdgeInsets.symmetric(horizontal: 10, vertical: 10) : null,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yer Tipi',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      isDense: true,
                      icon: const FaIcon(
                        FontAwesomeIcons.caretDown,
                        size: 15,
                        color: AppColors.black,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      initialValue: locationVS.type == '' ? null : locationVS.type,
                      items: ['Firma', 'Depo', 'Liman']
                          .map(
                            (option) => DropdownMenuItem(value: option, child: Text(option)),
                          )
                          .toList(),
                      onChanged: (value) {
                        ref.read(locationViewCP.notifier).selectType(value!);
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Yer Adı',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: locationVS.textEditsLocation[0],
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Bulunduğu Şehir',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Autocomplete<City>(
                      displayStringForOption: (City option) => option.cityName,
                      onSelected: (City selectedCity) {
                        FocusScope.of(context).unfocus();
                        print('Seçilen şehir: ${selectedCity.cityName}');
                        print('Plaka kodu: ${selectedCity.plateNo}');

                        ref.read(locationViewCP.notifier).selectCity(selectedCity);
                      },
                      initialValue: TextEditingValue(text: locationVS.selectedCity.cityName),
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable.empty();
                        }
                        return cities.where(
                          (city) => city.cityName.toLowerCase().contains(textEditingValue.text.toLowerCase()),
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
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                //prefixIcon: const Icon(Icons.search),
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
                    const SizedBox(height: 10),
                    const Text(
                      'Konum',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    TextField(
                      controller: locationVS.textEditsLocation[1],
                      enableInteractiveSelection: true, // seçim menüsü aktif
                      decoration: InputDecoration(
                        isDense: true,
                        hintText: 'https://maps.app.goo.gl/------- Formatında Giriniz',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      // inputFormatters: [
                      //   // Klavyeden yazmayı engelle
                      //   FilteringTextInputFormatter.deny(RegExp(r'.')),
                      // ],
                    ),
                    Text("Konum bilgisini Google Haritalar'dan kopla-yapıştır yaparak ekleyiniz."),
                    if (!largeScreen) ...[
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkOrange,
                            foregroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed:
                              locationDS.isLoadingAddOrEdit == true ||
                                  locationVS.type.isEmpty ||
                                  locationVS.textEditsLocation[0].text.isEmpty ||
                                  locationVS.selectedCity.cityName.isEmpty
                              ? null
                              : () async {
                                  if (widget.isUpdate) {
                                    if (widget.location != null) {
                                      Map<String, dynamic> editLocation = {};

                                      if (widget.location!.type != locationVS.type) {
                                        editLocation['type'] = locationVS.type;
                                      }

                                      if (widget.location!.name != locationVS.textEditsLocation[0].text) {
                                        editLocation['name'] = locationVS.textEditsLocation[0].text;
                                      }

                                      if (widget.location!.city.cityName != locationVS.selectedCity.cityName) {
                                        editLocation['city'] = locationVS.selectedCity.toJson();
                                      }

                                      if (widget.location!.maps != locationVS.textEditsLocation[1].text) {
                                        editLocation['maps'] = locationVS.textEditsLocation[1].text;
                                      }

                                      if (editLocation.isNotEmpty) {
                                        editLocation['updateDate'] = '${DateTime.now()}';
                                        editLocation['updateID'] = 'düzenlemeDeneme';
                                      }

                                      await ref.read(locationDataCP.notifier).updateLocation(widget.location!.id!, editLocation);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  } else {
                                    var newLocation = LocationModel(
                                      type: locationVS.type,
                                      name: locationVS.textEditsLocation[0].text,
                                      city: locationVS.selectedCity,
                                      maps: locationVS.textEditsLocation[1].text,
                                      isDeleted: false,
                                      createDate: '${DateTime.now()}',
                                      updateDate: '${DateTime.now()}',
                                      createID: 'denemeUser',
                                      updateID: 'denemeUser',
                                    );

                                    try {
                                      await ref.read(locationDataCP.notifier).addLocation(newLocation);
                                      if (context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      throw Exception(e);
                                    }
                                  }
                                },
                          child: Text(
                            'Kaydet',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}
