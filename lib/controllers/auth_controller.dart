import 'dart:convert';
import 'package:get/get.dart';
// import 'package:flutter/material.dart';
import '../core/network/http_client.dart';
import '../core/constants/api_constants.dart';
import '../core/services/token_service.dart';
import '../models/user_model.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final Rx<UserModel?> user = Rx(null);

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Peringatan', 'Email dan password wajib diisi');
      return;
    }

    try {
      isLoading.value = true;

      final res = await ApiClient.post(
        ApiConstants.login,
        body: {'email': email, 'password': password},
        withAuth: false,
      );

      final data = jsonDecode(res.body);

      // controllers/auth_controller.dart
      // Ganti bagian setelah saveSession:

      if (res.statusCode == 200) {
        await TokenService.saveSession(
          token: data['token'],
          userId: data['user']['id'].toString(),
          name: data['user']['name'],
          email: data['user']['email'],
          role: data['user']['role'],
        );

        // ✅ Redirect berdasarkan role
        final role = data['user']['role'] as String;
        switch (role) {
          case 'pemotong':
            Get.offAllNamed('/pemotong');
            break;
          case 'penjahit':
            Get.offAllNamed('/penjahit');
            break;
          case 'finishing':
            Get.offAllNamed('/finishing');
            break;
          default:
            Get.snackbar('Error', 'Role tidak dikenali: $role');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await ApiClient.post(ApiConstants.logout);
    } catch (_) {
      // Tetap lanjut logout meski request gagal
    } finally {
      await TokenService.clearSession();
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
