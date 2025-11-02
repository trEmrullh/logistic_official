import 'package:flutter/cupertino.dart' show CupertinoPageRoute;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/constants/custom_scroll.dart';
import 'package:logistic_official/controller/driver_controller/driver_data_controller.dart';
import 'package:logistic_official/controller/driver_controller/driver_view_controller.dart';
import 'package:logistic_official/controller/location_controller/location_data_controller.dart';
import 'package:logistic_official/controller/location_controller/location_view_controller.dart';
import 'package:logistic_official/models/city_model.dart';
import 'package:logistic_official/models/location_model.dart';
import 'package:logistic_official/utils/screen_utils.dart';
import 'package:logistic_official/widget/aou_driver.dart';
import 'package:logistic_official/widget/aou_location.dart';
import 'package:logistic_official/widget/app_dialog.dart';

class DriversPage extends ConsumerStatefulWidget {
  const DriversPage({super.key});

  @override
  ConsumerState<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends ConsumerState<DriversPage> {
  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    final driverDS = ref.watch(driverDataCP);
    final driverVS = ref.watch(driverViewCP);

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
                ref.read(driverViewCP.notifier).startTextEdits();

                if (largeScreen) {
                  showDialog(
                    context: context,

                    builder: (dialogContext) {
                      return Consumer(
                        builder: (dialogContext, ref, child) {
                          final locationDSConsumer = ref.watch(driverDataCP);
                          final locationVSConsumer = ref.watch(driverViewCP);

                          return AppDialog(
                            title: 'Yeni Şoför Ekle',
                            content: SizedBox(
                              width: 600,
                              height: 440,
                              child: AoUDriver(isUpdate: false),
                            ),
                            okFun:
                                locationDSConsumer.isLoadingAddOrEdit == true ||
                                    locationVSConsumer.type == '' ||
                                    locationVSConsumer.textEditsDriver[0].text.isEmpty ||
                                    locationVSConsumer.textEditsDriver[1].text.isEmpty ||
                                    locationVSConsumer.textEditsDriver[2].text.isEmpty ||
                                    locationVSConsumer.textEditsDriver[3].text.isEmpty ||
                                    locationVSConsumer.selectedCompany.isEmpty
                                ? null
                                : () async {
                                    var newLocation = LocationModel(
                                      type: locationVSConsumer.type,
                                      name: locationVSConsumer.textEditsDriver[0].text,
                                      city: City.empty(),
                                      maps: locationVSConsumer.textEditsDriver[1].text,
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
                'Yeni Şoför Ekle',
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
            Text('5 Şoför'),
          ],
        ),

        if (driverDS.isLoading == true)
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
                child: Text('AA'),
              ),
            ),
          ),
      ],
    );
  }

  TextField searchTextField() {
    return TextField(
      onChanged: (value) {
        var item = value.toLowerCase();
        //ref.read(locationDataCP.notifier).searchItem(item);
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
