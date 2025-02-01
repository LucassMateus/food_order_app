import 'package:flutter/material.dart';

class ColorsApp {
  static ColorsApp? _instance;

  ColorsApp._();

  static ColorsApp get instance => _instance ??= ColorsApp._();

  Color get primary => const Color.fromARGB(255, 194, 28, 28);
  Color get secondary => const Color.fromRGBO(240, 239, 244, 1);
}

extension ColorsAppExtension on BuildContext {
  ColorsApp get colors => ColorsApp.instance;
}
