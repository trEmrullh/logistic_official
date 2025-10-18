import 'package:flutter/material.dart';

class TrucksPage extends StatefulWidget {
  const TrucksPage({super.key});

  @override
  State<TrucksPage> createState() => _TrucksPageState();
}

class _TrucksPageState extends State<TrucksPage> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('TIRLAR'),
      ],
    );
  }
}
