import 'package:flutter/material.dart';

class NewXristisView extends StatefulWidget {
  const NewXristisView({super.key});

  @override
  State<NewXristisView> createState() => _NewXristisViewState();
}

class _NewXristisViewState extends State<NewXristisView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neos Xristis'),
      ),
      body: const Text('Wra na psifiseis'),
    );
  }
}
