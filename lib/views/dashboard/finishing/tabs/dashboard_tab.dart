import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/finishing_controller.dart';
import '../../../../core/services/token_service.dart';

class FinishingDashboardTab extends StatelessWidget {
  const FinishingDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FinishingController>();

    return RefreshIndicator(
      onRefresh: c.fetchAll,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Dashboard',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A))),
                const Text(' | ',
                    style: TextStyle(color: Color(0xFFCBD5E1))),
                Text('Dashboard ${TokenService.getUserRole() ?? '-'}',
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF64748B))),
              ],
            ),
            const SizedBox(height: 16),

            // 4 Stats cards — sesuai web
            Obx(() {
              final s = c.stats.value;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _statCard(
                        value: '${s?.jobMenunggu ?? 0}',
                        sub: 'Menunggu finishing',
                        label: 'Job Siap Finishing',
                        icon: Icons.dry_cleaning_outlined,
                        iconBg: const Color(0xFFFFF7ED),
                        iconColor: const Color(0xFFF97316),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _statCard(
                        value: '${s?.selesaiHariIni ?? 0}',
                        sub: 'Selesai hari ini',
                        label: 'Selesai Hari Ini',
                        icon: Icons.check_circle_outline_rounded,
                        iconBg: const Color(0xFFF0FDF4),
                        iconColor: const Color(0xFF22C55E),
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _statCard(
                        value: '${s?.packingHariIni ?? 0}',
                        sub: 'Packing hari ini',
                        label: 'Total Packing',
                        icon: Icons.inventory_2_outlined,
                        iconBg: const Color(0xFFF5F3FF),
                        iconColor: const Color(0xFF8B5CF6),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _statCard(
                        value: '${s?.jobAktif ?? 0}',
                        sub: 'Job aktif',
                        label: 'Job Aktif',
                        icon: Icons.layers_outlined,
                        iconBg: const Color(0xFFEFF6FF),
                        iconColor: const Color(0xFF3B82F6),
                      )),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            // Job table
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Text('Job Menunggu Finishing',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F172A))),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    color: const Color(0xFFF8FAFC),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: const Row(
                      children: [
                        Expanded(flex: 3,
                            child: Text('MODEL',
                                style: TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5))),
                        Expanded(flex: 2,
                            child: Text('KATEGORI',
                                style: TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5))),
                        Expanded(
                            child: Text('JUMLAH',
                                style: TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5))),
                        Expanded(
                            child: Text('STATUS',
                                style: TextStyle(fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF64748B),
                                    letterSpacing: 0.5))),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (c.isLoadingJobs.value) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (c.jobs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                            child: Text('Tidak ada job finishing',
                                style: TextStyle(
                                    color: Color(0xFF94A3B8)))),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: c.jobs.length,
                      separatorBuilder: (_, __) => const Divider(
                          height: 1, color: Color(0xFFF1F5F9)),
                      itemBuilder: (_, i) {
                        final job = c.jobs[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Expanded(flex: 3,
                                  child: Text(job.modelPakaian,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF0F172A)))),
                              Expanded(flex: 2,
                                  child: Text(job.kategori,
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF64748B)))),
                              Expanded(
                                  child: Text('${job.jumlahTarget}',
                                      style: const TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF0F172A)))),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7ED),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: const Text('Menunggu',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFFF97316),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => c.navIndex.value = 1,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4F46E5),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('KERJAKAN FINISHING',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard({
    required String value,
    required String sub,
    required String label,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
  }) =>
      Container(
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F172A))),
                Container(
                    width: 40,
                    height: 40,
                    decoration:
                        BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: Icon(icon, color: iconColor, size: 18)),
              ],
            ),
            const SizedBox(height: 4),
            Text(sub,
                style: const TextStyle(
                    fontSize: 11, color: Color(0xFF64748B))),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151))),
          ],
        ),
      );
}