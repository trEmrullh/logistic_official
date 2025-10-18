import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistic_official/controller/job_controller/job_view_controller.dart';
import 'package:logistic_official/utils/screen_utils.dart';

const List<String> _shippingTypes = [
  'İthalat',
  'İhracat',
  'Ara Nakliye',
];

Widget aodJob(BuildContext context) {
  final bool largeScreen = isLargeScreen(context);

  return Scaffold(
    appBar: AppBar(
      toolbarHeight: 45,
      title: Text('Yeni İş Ata'),
    ),
    body: Consumer(
      builder: (context, ref, child) {
        final jobViewState = ref.watch(jobViewCP);

        return SafeArea(
          child: Padding(
            padding: EdgeInsetsGeometry.all(10),
            child: Flex(
              direction: largeScreen ? Axis.horizontal : Axis.vertical,
              children: item(context, largeScreen),
            ),
          ),
        );
      },
    ),
  );
}

List<Widget> item(BuildContext context, bool largeScreen) {
  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Araç',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          height: !largeScreen ? 200 : double.infinity,
          width: largeScreen ? 200 : double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: SizedBox(
                  width: largeScreen ? 200 : double.infinity,
                  child: TextField(
                    // controller: trucksStateConsumer.textEditSearchTruck,
                    decoration: InputDecoration(
                      hintText: 'Plaka Ara..',
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      prefixIcon: Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 15,
                      ),
                    ),
                    onChanged: (value) {
                      //  ref.read(trucksControllerProvider.notifier).searchTrucks(value);
                    },
                  ),
                ),
              ),
              // if (trucksStateConsumer.filteredTrucks.isEmpty)
              //   Padding(
              //     padding: const EdgeInsets.all(10.0),
              //     child: Text(
              //       'Araç Bulunamadı',
              //       style: TextStyle(color: Colors.red),
              //     ),
              //   ),
              ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemCount: 25, //trucksStateConsumer.filteredTrucks.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  //  var truck = trucksStateConsumer.filteredTrucks[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () {},
                      child: Text('{truck.plate}'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    ),
    SizedBox(
      width: largeScreen ? 10 : 0,
      height: !largeScreen ? 10 : 0,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Seçilen Araçlar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.black12,
              width: 1.0,
            ),
          ),
          child: Text('A'),
          //  jobsStateConsumer.selectedTrucks.isEmpty
          //      ? Padding(
          //          padding: EdgeInsets.only(top: 25),
          //          child: Text('AA'),
          //        )
          //      :
          //
          // ListView.builder(
          //   itemCount: 5, // jobsStateConsumer.selectedTrucks.length,
          //   shrinkWrap: true,
          //   itemBuilder: (context, index) {
          //     // var truck = jobsStateConsumer.selectedTrucks[index];
          //
          //     return Row(
          //       children: [
          //         Text('{truck.plate}'),
          //         const Spacer(),
          //         InkWell(
          //           customBorder: const CircleBorder(),
          //           onTap: () {
          //             // var selectedTruck = JobTruckModel(
          //             //   id: truck.id,
          //             //   plate: truck.plate,
          //             // );
          //
          //             //  ref
          //             //      .read(jobControllerProvider.notifier)
          //             //      .selectMultiTrucks(selectedTruck, isUpdate: isUpdate);
          //           },
          //           child: Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: FaIcon(
          //               FontAwesomeIcons.circleXmark,
          //               size: 15,
          //             ),
          //           ),
          //         ),
          //       ],
          //     );
          //   },
          // ),
        ),
      ],
    ),
    SizedBox(
      width: largeScreen ? 10 : 0,
      height: !largeScreen ? 10 : 0,
    ),
    SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nakliye Türü',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(5),
            ),
            child: SizedBox(
              height: 25,
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: _shippingTypes.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    borderRadius: BorderRadius.circular(5),
                    onTap: () {
                      switch (index) {
                        case 0:
                          // ref.read(jobControllerProvider.notifier).selectShippingType(ShippingType.ithalat);

                          break;
                        case 1:
                          //  ref.read(jobControllerProvider.notifier).selectShippingType(ShippingType.ihracat);

                          break;
                        case 2:
                          // ref.read(jobControllerProvider.notifier).selectShippingType(
                          // ShippingType.araNakliye);

                          break;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(
                            // index == 0 && jobsStateConsumer.shippingType == ShippingType.ithalat
                            //     ? FontAwesomeIcons.circleDot
                            //     : index == 1 && jobsStateConsumer.shippingType == ShippingType.ihracat
                            //     ? FontAwesomeIcons.circleDot
                            //     : index == 2 && jobsStateConsumer.shippingType == ShippingType.araNakliye
                            //     ? FontAwesomeIcons.circleDot
                            //     :
                            FontAwesomeIcons.circle,

                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _shippingTypes[index],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          // if (jobsStateConsumer.shippingType == ShippingType.ithalat) loadDetailWidget(
          //     jobsStateConsumer, ShippingType.ithalat, locationState, constantsState),
          // if (jobsStateConsumer.shippingType == ShippingType.ihracat) loadDetailWidget(
          //     jobsStateConsumer, ShippingType.ihracat, locationState, constantsState),
          // if (jobsStateConsumer.shippingType == ShippingType.araNakliye) loadDetailWidget(
          //     jobsStateConsumer, ShippingType.araNakliye, locationState, constantsState),
        ],
      ),
    ),
  ];
}
