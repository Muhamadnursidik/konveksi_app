import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../controllers/pemotong_controller.dart';

class UploadSheet extends StatelessWidget {
  final int jobId;
  const UploadSheet({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PemotongController>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Upload Bukti Pemotongan',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          const Text(
            'Foto harus jelas memperlihatkan hasil potongan',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 20),

          // Preview foto
          Obx(() {
            final punya = kIsWeb
                ? c.fotoBytesWeb.value != null
                : c.fotoTerpilih.value != null;

            return GestureDetector(
              onTap: () => _showPilihFoto(context, c),
              child: punya
                ? Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                          ? Image.memory(
                              c.fotoBytesWeb.value!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              c.fotoTerpilih.value!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: GestureDetector(
                          onTap: c.resetFoto,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.close, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.shade200, width: 2),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 48, color: Colors.indigo),
                        SizedBox(height: 8),
                        Text('Tap untuk pilih foto', style: TextStyle(color: Colors.indigo)),
                      ],
                    ),
                  ),
            );
          }),
          const SizedBox(height: 12),

          // Tombol kamera & galeri
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Kamera'),
                  onPressed: () => c.pilihFoto(dariKamera: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Galeri'),
                  onPressed: () => c.pilihFoto(dariKamera: false),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tombol kirim
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: c.isUploading.value
                  ? null
                  : () => c.selesaikanJob(jobId),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: c.isUploading.value
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Kirim ke Admin',
                      style: TextStyle(fontSize: 16)),
            ),
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showPilihFoto(BuildContext context, PemotongController c) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () {
                Get.back();
                c.pilihFoto(dariKamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Get.back();
                c.pilihFoto(dariKamera: false);
              },
            ),
          ],
        ),
      ),
    );
  }
}