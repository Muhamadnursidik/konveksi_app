import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../controllers/penjahit_controller.dart';

class PenjahitJobTab extends StatelessWidget {
  const PenjahitJobTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PenjahitController>();

    return Obx(() {
      if (c.isLoadingJobs.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.jobs.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle_outline,
                  size: 64, color: Color(0xFFCBD5E1)),
              SizedBox(height: 12),
              Text('Tidak ada job saat ini',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 15)),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: c.fetchJobs,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: c.jobs.length,
          itemBuilder: (_, i) => _JobCard(
            job: c.jobs[i],
            onKerjakan: () {
              c.resetFoto();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (_) => _UploadSheet(jobId: c.jobs[i].id),
              );
            },
          ),
        ),
      );
    });
  }
}

class _JobCard extends StatelessWidget {
  final dynamic job;
  final VoidCallback onKerjakan;
  const _JobCard({required this.job, required this.onKerjakan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.checkroom_rounded,
                    color: Color(0xFF4F46E5), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(job.modelPakaian,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A))),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text('Menunggu',
                    style: TextStyle(
                        color: Color(0xFFF97316),
                        fontSize: 11,
                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          const Divider(height: 20, color: Color(0xFFF1F5F9)),
          _row(Icons.layers_outlined, 'Bahan', job.bahan),
          const SizedBox(height: 6),
          _row(Icons.format_list_numbered, 'Target', '${job.jumlahTarget} pcs'),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.upload_rounded, size: 18),
              label: const Text('Kerjakan & Upload Bukti'),
              onPressed: onKerjakan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
          const SizedBox(width: 6),
          Text('$label: ',
              style:
                  const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0F172A))),
        ],
      );
}

class _UploadSheet extends StatelessWidget {
  final int jobId;
  const _UploadSheet({required this.jobId});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PenjahitController>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Upload Bukti Jahitan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Foto harus jelas memperlihatkan hasil jahitan',
              style: TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 20),
          Obx(() {
            final punya = kIsWeb
                ? c.fotoBytesWeb.value != null
                : c.fotoTerpilih.value != null;
            return GestureDetector(
              onTap: () => _showPilih(context, c),
              child: punya
                  ? Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb
                            ? Image.memory(c.fotoBytesWeb.value!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover)
                            : Image.file(c.fotoTerpilih.value!,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 8, right: 8,
                        child: GestureDetector(
                          onTap: c.resetFoto,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                                color: Colors.red, shape: BoxShape.circle),
                            child: const Icon(Icons.close,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ])
                  : Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFF4F46E5).withOpacity(0.3),
                            width: 2),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 48, color: Color(0xFF4F46E5)),
                          SizedBox(height: 8),
                          Text('Tap untuk pilih foto',
                              style: TextStyle(color: Color(0xFF4F46E5))),
                        ],
                      ),
                    ),
            );
          }),
          const SizedBox(height: 12),
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
          Obx(() => SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: c.isUploading.value
                  ? null
                  : () => c.selesaikanJob(jobId),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: c.isUploading.value
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                  : const Text('Kirim ke Admin',
                      style: TextStyle(fontSize: 16)),
            ),
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showPilih(BuildContext context, PenjahitController c) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil dari Kamera'),
              onTap: () { Get.back(); c.pilihFoto(dariKamera: true); },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () { Get.back(); c.pilihFoto(dariKamera: false); },
            ),
          ],
        ),
      ),
    );
  }
}