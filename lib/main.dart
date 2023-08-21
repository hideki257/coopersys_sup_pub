import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config.dart';
import 'my_app.dart';

void main() async {
  await initConfig();

  runApp(const ProviderScope(child: MyApp()));
}
