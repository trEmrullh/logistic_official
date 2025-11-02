import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/constants/custom_scroll.dart';
import 'package:logistic_official/controller/location_controller/location_data_controller.dart';
import 'package:logistic_official/controller/location_controller/location_view_controller.dart';
import 'package:logistic_official/models/location_model.dart';
import 'package:logistic_official/utils/screen_utils.dart';
import 'package:logistic_official/widget/aou_location.dart';
import 'package:logistic_official/widget/app_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationsPage extends ConsumerStatefulWidget {
  const LocationsPage({super.key});

  @override
  ConsumerState<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends ConsumerState<LocationsPage> {
  final ScrollController _scrollController = ScrollController();
  String _editOrDeleteID = '';

  late LocationDataController _locationDataController;

  @override
  void initState() {
    _locationDataController = ref.read(locationDataCP.notifier);

    Future.microtask(() {
      _locationDataController.locationsStream();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    final locationDS = ref.watch(locationDataCP);
    final locationVS = ref.watch(locationViewCP);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkOrange,
                foregroundColor: AppColors.white,
                minimumSize: Size(30, 35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                ref.read(locationViewCP.notifier).startTextEdits();

                if (largeScreen) {
                  showDialog(
                    context: context,

                    builder: (dialogContext) {
                      return Consumer(
                        builder: (dialogContext, ref, child) {
                          final locationDSConsumer = ref.watch(locationDataCP);
                          final locationVSConsumer = ref.watch(locationViewCP);

                          return AppDialog(
                            title: 'Yeni Yer Ekle',
                            content: SizedBox(
                              width: 600,
                              height: 300,
                              child: AoULocation(isUpdate: false),
                            ),
                            okFun:
                                locationDSConsumer.isLoadingAddOrEdit == true ||
                                    locationVSConsumer.type == '' ||
                                    locationVSConsumer.textEditsLocation[0].text.isEmpty ||
                                    locationVSConsumer.selectedCity.cityName == ''
                                ? null
                                : () async {
                                    var newLocation = LocationModel(
                                      type: locationVSConsumer.type,
                                      name: locationVSConsumer.textEditsLocation[0].text,
                                      city: locationVSConsumer.selectedCity,
                                      maps: locationVSConsumer.textEditsLocation[1].text,
                                      isDeleted: false,
                                      createDate: '${DateTime.now()}',
                                      updateDate: '${DateTime.now()}',
                                      createID: 'denemeUser',
                                      updateID: 'denemeUser',
                                    );

                                    try {
                                      await ref.read(locationDataCP.notifier).addLocation(newLocation);
                                    } catch (e) {
                                      throw Exception(e);
                                    }
                                  },
                          );
                        },
                      );
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => AoULocation(isUpdate: false),
                    ),
                  );
                }
              },
              child: Text(
                'Yeni Yer Ekle',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 5),
            largeScreen
                ? SizedBox(
                    width: 200,
                    child: searchTextField(),
                  )
                : Expanded(
                    child: searchTextField(),
                  ),
            const SizedBox(width: 10),
            Text('${locationDS.locations.length} Yer'),
          ],
        ),

        if (locationDS.isLoading == true || locationDS.isLoading == null)
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          Expanded(
            child: SingleChildScrollView(
              child: ScrollConfiguration(
                behavior: MyCustomScrollBehavior(),
                child: Scrollbar(
                  controller: _scrollController,
                  trackVisibility: true,
                  thickness: 8.0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      showCheckboxColumn: true,
                      columnSpacing: 25,
                      dataRowMinHeight: 32,
                      dataRowMaxHeight: 32,
                      //headingRowHeight: 65,
                      headingTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      columns: List.generate(
                        5,
                        (index) {
                          return DataColumn(
                            label: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: index < 3
                                          ? () {
                                              ref.read(locationViewCP.notifier).setOrderIndex(index);

                                              late String type;
                                              if (index != locationVS.orderIndex) {
                                                type = 'ASC';
                                                ref.read(locationViewCP.notifier).setOrderType('ASC');
                                              } else {
                                                type = ref.read(locationViewCP).orderType == 'ASC' ? 'DESC' : 'ASC';
                                                ref.read(locationViewCP.notifier).setOrderType(type);
                                              }

                                              late String orderField;
                                              switch (index) {
                                                case 0:
                                                  orderField = 'name';
                                                  break;
                                                case 1:
                                                  orderField = 'city';
                                                  break;
                                                case 2:
                                                  orderField = 'type';
                                                  break;
                                                case 3:
                                                  orderField = 'maps';
                                                  break;
                                              }

                                              ref.read(locationDataCP.notifier).sortLocationsByName(type, orderField);
                                            }
                                          : null,

                                      hoverColor: Colors.transparent,
                                      child: Text(
                                        index == 0
                                            ? 'Yer'
                                            : index == 1
                                            ? 'Şehir'
                                            : index == 2
                                            ? 'Yer Tipi'
                                            : index == 3
                                            ? 'Konum'
                                            : '',
                                      ),
                                    ),
                                    if (index < 3 && locationVS.orderIndex == index)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: FaIcon(
                                          locationVS.orderType == 'ASC' ? FontAwesomeIcons.arrowDownAZ : FontAwesomeIcons.arrowUpZA,
                                          size: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      rows: locationDS.locations.map(
                        (LocationModel location) {
                          return DataRow(
                            // selected: false,
                            // onSelectChanged: (bool? value) {
                            //   // ref.read(locationControllerProvider.notifier).updateSelectedLocations(location);
                            // },
                            cells: locationDS.locations.isEmpty
                                ? [
                                    DataCell(
                                      Center(
                                        child: Container(
                                          margin: const EdgeInsets.only(top: 20),
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.black05,
                                              width: 1.0,
                                            ),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'Henüz Eklenmiş Bir Yer Yoktur.',
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                    DataCell(Text('')),
                                  ]
                                : [
                                    DataCell(SelectableText(location.name ?? "")),
                                    DataCell(SelectableText(location.city.cityName)),
                                    DataCell(SelectableText(location.type ?? "")),
                                    DataCell(
                                      Center(
                                        child: location.maps! != ''
                                            ? IconButton(
                                                onPressed: () async {
                                                  final googleMapsUrl = Uri.parse(location.maps!);

                                                  if (largeScreen) {
                                                    if (await canLaunchUrl(googleMapsUrl)) {
                                                      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                                                    }
                                                  } else {
                                                    if (await canLaunchUrl(googleMapsUrl)) {
                                                      await launchUrl(googleMapsUrl);
                                                    } else if (await canLaunchUrl(googleMapsUrl)) {
                                                      await launchUrl(googleMapsUrl);
                                                    } else {
                                                      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
                                                    }
                                                  }
                                                },
                                                icon: FaIcon(
                                                  FontAwesomeIcons.locationArrow,
                                                  size: 20,
                                                ),
                                                tooltip: 'Konuma Git',
                                              )
                                            : Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.red),
                                                  color: Colors.red.withValues(alpha: 0.2),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: SelectableText(
                                                  "Yok",
                                                  style: const TextStyle(color: Colors.black),
                                                ),
                                              ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          //if (locationPageAuth?.update == true)
                                          OutlinedButton(
                                            onPressed: _editOrDeleteID.isNotEmpty
                                                ? () {}
                                                : () async {
                                                    setState(() {
                                                      _editOrDeleteID = location.id!;
                                                    });

                                                    ref.read(locationViewCP.notifier).selectType(location.type!);
                                                    ref.read(locationViewCP.notifier).selectCity(location.city);

                                                    locationVS.textEditsLocation[0].text = location.name ?? "";
                                                    locationVS.textEditsLocation[1].text = location.maps ?? "";

                                                    await Future.delayed(Duration(seconds: 1));

                                                    setState(() {
                                                      _editOrDeleteID = '';
                                                    });

                                                    if (largeScreen) {
                                                      if (context.mounted) {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Consumer(
                                                              builder: (context, ref, child) {
                                                                final locationVSConsumer = ref.watch(locationViewCP);
                                                                final locationDSConsumer = ref.watch(locationDataCP);

                                                                return AppDialog(
                                                                  title: 'Düzenleme İşlemi',
                                                                  content: SizedBox(
                                                                    height: 300,
                                                                    width: 600,
                                                                    child: locationDSConsumer.isLoadingAddOrEdit == true
                                                                        ? Center(
                                                                            child: CircularProgressIndicator(),
                                                                          )
                                                                        : AoULocation(
                                                                            isUpdate: true,
                                                                          ),
                                                                  ),
                                                                  okFun:
                                                                      locationDSConsumer.isLoadingAddOrEdit == true ||
                                                                          locationVSConsumer.type.isEmpty ||
                                                                          locationVSConsumer.textEditsLocation[0].text.isEmpty ||
                                                                          locationVSConsumer.selectedCity.cityName.isEmpty
                                                                      ? null
                                                                      : () async {
                                                                          Map<String, dynamic> editLocation = {};

                                                                          if (location.type != locationVSConsumer.type) {
                                                                            editLocation['type'] = locationVSConsumer.type;
                                                                          }

                                                                          if (location.name != locationVSConsumer.textEditsLocation[0].text) {
                                                                            editLocation['name'] = locationVSConsumer.textEditsLocation[0].text;
                                                                          }

                                                                          if (location.city != locationVSConsumer.selectedCity) {
                                                                            editLocation['city'] = locationVSConsumer.selectedCity.toJson();
                                                                          }

                                                                          if (location.maps != locationVSConsumer.textEditsLocation[1].text) {
                                                                            editLocation['maps'] = locationVSConsumer.textEditsLocation[1].text;
                                                                          }

                                                                          if (editLocation.isNotEmpty) {
                                                                            editLocation['updateDate'] = '${DateTime.now()}';

                                                                            await ref
                                                                                .read(locationDataCP.notifier)
                                                                                .updateLocation(location.id!, editLocation);
                                                                          }
                                                                        },
                                                                );
                                                              },
                                                            );
                                                          },
                                                        );
                                                      }
                                                    } else {
                                                      if (context.mounted) {
                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (context) => AoULocation(isUpdate: true, location: location),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                  },
                                            style: OutlinedButton.styleFrom(
                                              minimumSize: Size(80, 25),
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: _editOrDeleteID == location.id
                                                ? SizedBox(
                                                    height: 15,
                                                    width: 15,
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                    ),
                                                  )
                                                : const Text("Düzenle"),
                                          ),
                                          //if (locationPageAuth?.delete == true) ...[
                                          SizedBox(width: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Consumer(
                                                    builder: (context, ref, child) {
                                                      final locationDS = ref.watch(locationDataCP);

                                                      return AppDialog(
                                                        title: 'Silme İşlemi',
                                                        content: SizedBox(
                                                          height: 50,
                                                          child: Center(
                                                            child: locationDS.isLoadingAddOrEdit == true
                                                                ? CircularProgressIndicator()
                                                                : Text(
                                                                    'Silme İşlemini Onaylıyor Musunuz ?',
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                          ),
                                                        ),
                                                        okButtonColor: AppColors.red,
                                                        okButtonText: 'Sil',
                                                        okFun: () async {
                                                          try {
                                                            await ref.read(locationDataCP.notifier).deleteLocation(location.id!, 'deleteUserID');
                                                          } catch (e) {
                                                            throw Exception(e);
                                                          }
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              minimumSize: Size(50, 25),
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              backgroundColor: AppColors.red,
                                              foregroundColor: AppColors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5),
                                              ),
                                            ),
                                            child: const Text("Sil"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  TextField searchTextField() {
    return TextField(
      //controller: locationVS.searchControllers[index],
      onChanged: (value) {
        var item = value.toLowerCase();
        ref.read(locationDataCP.notifier).searchItem(item);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
        isDense: true,
        hintText: 'Ara...',
        hintStyle: const TextStyle(fontSize: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(width: 0.3),
        ),
      ),
    );
  }
}
