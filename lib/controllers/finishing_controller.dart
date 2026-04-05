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
import '../models/finishing_job_model.dart';
import '../models/finishing_stats_model.dart';
import '../models/finishing_riwayat_model.dart';

class FinishingController extends GetxController {
  final isLoadingJobs    = false.obs;
  final isLoadingRiwayat = false.obs;
  final isLoadingStats   = false.obs;
  final isUploading      = false.obs;

  final jobs    = <FinishingJobModel>[].obs;
  final riwayat = <FinishingRiwayatModel>[].obs;
  final Rx<FinishingStatsModel?> stats = Rx(null);
  final navIndex = 0.obs;

  final Rx<File?>      fotoTerpilih = Rx(null);
  final Rx<Uint8List?> fotoBytesWeb = Rx(null);

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${TokenService.getToken()}',
    'Accept': 'application/json',
  };

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    await Future.wait([fetchStats(), fetchJobs(), fetchRiwayat()]);
  }

  Future<void> fetchStats() async {
    try {
      isLoadingStats.value = true;
      final res = await http.get(
          Uri.parse(ApiConstants.finishingStats), headers: _headers);
      if (res.statusCode == 200) {
        stats.value = FinishingStatsModel.fromJson(jsonDecode(res.body));
      }
    } catch (_) {} finally {
      isLoadingStats.value = false;
    }
  }

  Future<void> fetchJobs() async {
    try {
      isLoadingJobs.value = true;
      final res = await http.get(
          Uri.parse(ApiConstants.finishingJobs), headers: _headers);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'];
        jobs.value = data.map((e) => FinishingJobModel.fromJson(e)).toList();
      }
    } catch (_) {
      Get.snackbar('Error', 'Gagal memuat jobs');
    } finally {
      isLoadingJobs.value = false;
    }
  }

  Future<void> fetchRiwayat() async {
    try {
      isLoadingRiwayat.value = true;
      final res = await http.get(
          Uri.parse(ApiConstants.finishingRiwayat), headers: _headers);
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body)['data'];
        riwayat.value =
            data.map((e) => FinishingRiwayatModel.fromJson(e)).toList();
      }
    } catch (_) {
      Get.snackbar('Error', 'Gagal memuat riwayat');
    } finally {
      isLoadingRiwayat.value = false;
    }
  }

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

  Future<void> selesaikanJob(int jobId) async {
    final adaFoto =
        kIsWeb ? fotoBytesWeb.value != null : fotoTerpilih.value != null;

    if (!adaFoto) {
      Get.snackbar('Peringatan', 'Pilih foto bukti dulu');
      return;
    }

    try {
      isUploading.value = true;
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.finishingSelesai(jobId)),
      )..headers.addAll(_headers);

      if (kIsWeb) {
        request.files.add(http.MultipartFile.fromBytes(
          'foto_bukti',
          fotoBytesWeb.value!,
          filename:
              'bukti_finishing_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      } else {
        request.files.add(await http.MultipartFile.fromPath(
            'foto_bukti', fotoTerpilih.value!.path));
      }

      final res  = await http.Response.fromStream(await request.send());
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        Get.back();
        Get.snackbar(
          'Berhasil', 'Bukti dikirim, menunggu ACC admin',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        resetFoto();
        await fetchAll();
      } else {
        Get.snackbar('Gagal', data['message'] ?? 'Terjadi kesalahan',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (_) {
      Get.snackbar('Error', 'Tidak dapat terhubung ke server',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isUploading.value = false;
    }
  }

  void resetFoto() {
    fotoTerpilih.value = null;
    fotoBytesWeb.value = null;
  }
}