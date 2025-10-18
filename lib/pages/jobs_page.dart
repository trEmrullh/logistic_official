import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logistic_official/constants/app_color.dart';
import 'package:logistic_official/utils/screen_utils.dart';
import 'package:logistic_official/widget/aod_job.dart';

class JobsPage extends StatefulWidget {
  const JobsPage({super.key});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    final bool largeScreen = isLargeScreen(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                      return aodJob(context);
                    },
                  );
                },
                child: Text(
                  'Yeni İş Ata',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 15),
            ],
            SizedBox(
              width: 130,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                isDense: true,
                icon: const Icon(
                  FontAwesomeIcons.caretDown,
                  size: 15,
                  color: AppColors.black,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(),
                  disabledBorder: null,
                  enabledBorder: null,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                ),
                initialValue: 'Tüm İşler',
                items:
                    [
                          'Tüm İşler',
                          'İthalat',
                          'İhracat',
                          'Ara Nakliye',
                        ]
                        .map(
                          (option) => DropdownMenuItem(
                            value: option,
                            child: Text(
                              option,
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                onChanged: (value) {},
              ),
            ),
            const SizedBox(width: 15),
            Text(
              '0 İş',
              style: TextStyle(
                color: AppColors.black05,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
