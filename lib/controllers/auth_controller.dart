import 'dart:convert';
import 'package:get/get.dart';
import '../core/network/http_client.dart';
import '../core/constants/api_constants.dart';
import '../core/services/token_service.dart';
import '../models/user_model.dart';
import '../app/routes/app_routes.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Peringatan', 'Email dan password wajib diisi');
      return;
    }

    try {
      isLoading.value = true;

      final res = await ApiClient.post(
        ApiConstants.login,
        body: {
          'email': email,
          'password': password,
        },
        withAuth: false,
      );

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        final userData = data['user'];

        final loggedUser = UserModel.fromJson(userData);

        // simpan ke state
        user.value = loggedUser;

        await TokenService.saveSession(
          token: data['token'],
          userId: loggedUser.id.toString(),
          name: loggedUser.name,
          email: loggedUser.email,
          role: loggedUser.role,
          photo: loggedUser.photo, 
        );

        switch (loggedUser.role) {
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
            Get.snackbar('Error', 'Role tidak dikenali: ${loggedUser.role}');
        }
      } else {
        Get.snackbar(
          'Login Gagal',
          data['message'] ?? 'Terjadi kesalahan',
        );
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
      // tetap lanjut walaupun API gagal
    } finally {
      await TokenService.clearSession();
      user.value = null;
      Get.offAllNamed(AppRoutes.login);
    }
  }
}