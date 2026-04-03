import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/app_routes.dart';
import '../core/services/token_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Tentukan halaman awal berdasarkan role
  String get _initialRoute {
    if (!TokenService.isLoggedIn()) return '/login';

    switch (TokenService.getUserRole()) {
      case 'pemotong':  return '/pemotong';
      case 'penjahit':  return '/penjahit';
      case 'finishing': return '/finishing';
      default:          return '/login';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: _initialRoute, 
      getPages: AppRoutes.pages,
    );
  }
}