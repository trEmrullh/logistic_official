import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logistic_official/constants/app_color.dart';

class AppDialog extends StatefulWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.content,
    this.okFun,
    this.okButtonText = 'Kaydet',
    this.okButtonColor = AppColors.orange,
    this.cancelButtonText = 'Vazgeç',
    this.cancelButtonColor,
    this.showOkButton = true,
    this.noDefaultPop = false,
  });

  final String title;
  final Widget content;
  final FutureOr<void> Function()? okFun;

  final String okButtonText;
  final Color okButtonColor;
  final String cancelButtonText;
  final Color? cancelButtonColor;

  final bool showOkButton;
  final bool noDefaultPop;

  @override
  State<AppDialog> createState() => _AppDialogState();
}

class _AppDialogState extends State<AppDialog> {
  bool? isLoading;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title),
          const Divider(height: 10.0),
        ],
      ),
      titlePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: widget.content,
      actions: [
        if (widget.showOkButton) ...[
          InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () async {
              if (widget.okFun != null) {
                try {
                  await widget.okFun!();
                  if (widget.noDefaultPop == false) {
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                } catch (e) {
                  throw Exception(e);
                }
              }
            },
            child: Container(
              height: 30,
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
              decoration: BoxDecoration(
                color: widget.okButtonColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  widget.okButtonText,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
        ],
        InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: () {
            Navigator.of(context).pop(false);
          },
          child: Container(
            height: 30,
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: widget.cancelButtonColor,
              border: Border.all(
                width: 0.5,
                color: Colors.black,
              ),
            ),
            child: Center(
              child: Text(
                widget.cancelButtonText,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
