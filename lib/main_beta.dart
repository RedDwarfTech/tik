import 'package:flutter/material.dart';

import './includes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initEnv('beta');
  runApp(AppNavigator());
}
