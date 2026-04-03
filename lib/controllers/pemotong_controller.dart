import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../core/constants/api_constants.dart';
import '../core/services/token_service.dart';
import '../models/job_model.dart';
import '../models/riwayat_model.dart';

class PemotongController extends GetxController {
  final isLoadingJobs    = false.obs;
  final isLoadingRiwayat = false.obs;
  final isUploading      = false.obs;
  final jobs             = <JobModel>[].obs;
  final riwayat          = <RiwayatModel>[].obs;
  final Rx<File?>      fotoTerpilih = Rx(null);
  final Rx<Uint8List?> fotoBytesWeb = Rx(null);

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${TokenService.getToken()}',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
    fetchRiwayat();
  }

  // ✅ Fetch jobs — hanya yang belum ada pemotongan (whereDoesntHave di Laravel)
  Future<void> fetchJobs() async {
    try {
      isLoadingJobs.value = true;
      final res = await http.get(
        Uri.parse(ApiConstants.pemotongJobs),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'];
        jobs.value = data.map((e) => JobModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Gagal memuat jobs');
      }
    } catch (_) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server');
    } finally {
      isLoadingJobs.value = false;
    }
  }

  // ✅ Fetch riwayat pemotongan milik user yang login
  Future<void> fetchRiwayat() async {
    try {
      isLoadingRiwayat.value = true;
      final res = await http.get(
        Uri.parse(ApiConstants.pemotongRiwayat),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'];
        riwayat.value = data.map((e) => RiwayatModel.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Gagal memuat riwayat');
      }
    } catch (_) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server');
    } finally {
      isLoadingRiwayat.value = false;
    }
  }

  // ✅ Pilih foto — support web & mobile
  Future<void> pilihFoto({bool dariKamera = false}) async {
    final picked = await ImagePicker().pickImage(
      source: dariKamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );
    if (picked != null) {
      if (kIsWeb) {
        fotoBytesWeb.value = await picked.readAsBytes();
        fotoTerpilih.value = null;
      } else {
        fotoTerpilih.value = File(picked.path);
        fotoBytesWeb.value = null;
      }
    }
  }

  // ✅ Upload bukti — job tetap 'menunggu', pemotongan status 'pending'
  // Job baru hilang dari list setelah admin ACC
  Future<void> selesaikanJob(int jobId) async {
    final adaFoto = kIsWeb
        ? fotoBytesWeb.value != null
        : fotoTerpilih.value != null;

    if (!adaFoto) {
      Get.snackbar('Peringatan', 'Pilih foto bukti dulu');
      return;
    }

    try {
      isUploading.value = true;

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.pemotongSelesai(jobId)),
      )..headers.addAll(_headers);

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'foto_bukti',
          fotoBytesWeb.value!,
          filename: 'bukti_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
          'foto_bukti',
          fotoTerpilih.value!.path,
        ));
      }

      final res  = await http.Response.fromStream(await request.send());
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Get.back(); // tutup bottom sheet
        Get.snackbar(
          'Berhasil',
          'Bukti dikirim, menunggu ACC admin',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        resetFoto();
        // Job hilang dari list (whereDoesntHave di Laravel)
        // Muncul di riwayat dengan status 'pending'
        await fetchJobs();
        await fetchRiwayat();
      } else {
        Get.snackbar(
          'Gagal',
          data['message'] ?? 'Terjadi kesalahan',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (_) {
      Get.snackbar(
        'Error',
        'Tidak dapat terhubung ke server',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isUploading.value = false;
    }
  }

  void resetFoto() {
    fotoTerpilih.value = null;
    fotoBytesWeb.value = null;
  }
}