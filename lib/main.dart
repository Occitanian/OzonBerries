import 'package:flutter/material.dart';
import 'di/di.dart';
import 'my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator(); // регистрируем зависимости

  FlutterError.onError = (details) {
    talker.handle(details.exception, details.stack);
  };

  runApp(const MyApp());
}