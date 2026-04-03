import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../services/token_service.dart';
import '../../app/routes/app_routes.dart';

class ApiClient {
  static Map<String, String> _headers({bool withAuth = true}) {
    final h = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',       // wajib untuk Laravel
    };
    if (withAuth) {
      final token = TokenService.getToken();
      if (token != null) h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  static Future<http.Response> get(String url) async {
    final res = await http.get(Uri.parse(url), headers: _headers());
    return _handle(res);
  }

  static Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    bool withAuth = true,
  }) async {
    final res = await http.post(
      Uri.parse(url),
      headers: _headers(withAuth: withAuth),
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  static Future<http.Response> put(String url, {Map<String, dynamic>? body}) async {
    final res = await http.put(
      Uri.parse(url),
      headers: _headers(),
      body: jsonEncode(body),
    );
    return _handle(res);
  }

  static Future<http.Response> delete(String url) async {
    final res = await http.delete(Uri.parse(url), headers: _headers());
    return _handle(res);
  }

  static Future<http.Response> _handle(http.Response res) async {
    if (res.statusCode == 401) {
      // Sanctum: token expired/invalid → paksa logout
      await TokenService.clearSession();
      Get.offAllNamed(AppRoutes.login);
      throw Exception('Session expired');
    }
    return res;
  }
}