import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/services/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenService.init();
  runApp(const MyApp());
}