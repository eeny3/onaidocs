import 'package:flutter/material.dart';
import 'package:onaidocs/app/app.dart';
import 'package:onaidocs/app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setupDependencies();
  runApp(const MyApp());
}
