import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'core/services/token_service.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TokenService.init();
  Get.put(AuthController(), permanent: true);
  runApp(const MyApp());
}