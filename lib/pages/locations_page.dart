import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/constants/custom_scroll.dart';
import 'package:logistic_official/controller/location_controller/location_data_controller.dart';
import 'package:logistic_official/controller/location_controller/location_view_controller.dart';
import 'package:logistic_official/models/location_model.dart';
import 'package:logistic_official/utils/screen_utils.dart';
import 'package:logistic_official/widget/aod_location.dart';
import 'package:logistic_official/widget/app_dialog.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
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
              ref.read(locationViewCP.notifier).startTextEdits();

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
                          child: AodLocation(),
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

        if (locationDS.isLoading == true || locationDS.isLoading == null)
          Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else if (locationDS.locations.isEmpty)
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
                      columnSpacing: 30,
                      dataRowMinHeight: 32,
                      dataRowMaxHeight: 32,
                      headingTextStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      columns: const [
                        DataColumn(label: Text('Yer')),
                        DataColumn(label: Text('Şehir')),
                        DataColumn(label: Text('Yer Tipi')),
                        DataColumn(label: Text('Konum')),
                        DataColumn(label: Text('')),
                      ],
                      rows: locationDS.locations.map(
                        (LocationModel location) {
                          return DataRow(
                            // selected: locationState.selectedLocations.contains(location),
                            // onSelectChanged: (bool? value) {
                            //   ref.read(locationControllerProvider.notifier).updateSelectedLocations(location);
                            // },
                            cells: [
                              DataCell(SelectableText(location.name ?? "")),
                              DataCell(SelectableText(location.city.cityName)),
                              DataCell(SelectableText(location.type ?? "")),
                              DataCell(
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: location.maps! != '' ? Colors.green : Colors.red),
                                      color: location.maps! != ''
                                          ? Colors.green.withValues(alpha: 0.2)
                                          : Colors.red.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: SelectableText(
                                      location.maps! != '' ? "Var" : "Yok",
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
                                      onPressed: _editOrDeleteID.isNotEmpty ? () {} : () async {},
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: Size(80, 25),
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        //fixedSize: Size(20, 20),
                                      ),
                                      child: _editOrDeleteID == location.id
                                          ? SizedBox(
                                              width: 50.4,
                                              height: 32,
                                              child: Center(
                                                child: SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child: CircularProgressIndicator(
                                                    strokeWidth: 2.0,
                                                  ),
                                                ),
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
                                                // final locationStateConsumer = ref.watch(locationControllerProvider);

                                                return AppDialog(
                                                  title: 'Silme İşlemi',
                                                  content: SizedBox(
                                                    height: 50,
                                                    child: Center(
                                                      child: Text(
                                                        'Silme İşlemini Onaylıyor Musunuz ?',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  okButtonColor: AppColors.red,
                                                  okButtonText: 'Sil',
                                                  okFun: () async {},
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
}
