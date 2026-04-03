import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/pemotong_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../core/services/token_service.dart';
import 'widgets/job_card.dart';
import 'widgets/upload_sheet.dart';

class PemotongHome extends StatelessWidget {
  const PemotongHome({super.key});

  @override
  Widget build(BuildContext context) {
    final c    = Get.find<PemotongController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        title: const Text('Dashboard Pemotong'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat',
            onPressed: () => Get.toNamed('/pemotong/riwayat'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.dialog(AlertDialog(
              title: const Text('Logout'),
              content: const Text('Yakin ingin keluar?'),
              actions: [
                TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
                TextButton(onPressed: auth.logout, child: const Text('Logout')),
              ],
            )),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo, ${TokenService.getUserName() ?? '-'} 👋',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Berikut job yang perlu dikerjakan',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                // Stats
                Obx(() => Row(
                  children: [
                    _statChip('${c.jobs.length}', 'Job Tersedia'),
                    const SizedBox(width: 12),
                    _statChip('${c.riwayat.length}', 'Riwayat'),
                  ],
                )),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Label
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Job Tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // List
          Expanded(
            child: Obx(() {
              if (c.isLoadingJobs.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.jobs.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('Tidak ada job saat ini',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: c.fetchJobs,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: c.jobs.length,
                  itemBuilder: (_, i) => JobCard(
                    job: c.jobs[i],
                    onKerjakan: () {
                      c.resetFoto();
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => UploadSheet(jobId: c.jobs[i].id),
                      );
                    },
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String value, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.2),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Text(value,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    ),
  );
}