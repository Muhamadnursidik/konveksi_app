import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/pemotong_controller.dart';
import '../widgets/job_card.dart';
import '../widgets/upload_sheet.dart';

class JobTab extends StatelessWidget {
  const JobTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PemotongController>();

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
                  style:
                      TextStyle(color: Color(0xFF94A3B8), fontSize: 15)),
            ],
          ),
        );
      }
      return RefreshIndicator(
        onRefresh: c.fetchJobs,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: c.jobs.length,
          itemBuilder: (_, i) => JobCard(
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
                builder: (_) => UploadSheet(jobId: c.jobs[i].id),
              );
            },
          ),
        ),
      );
    });
  }
}