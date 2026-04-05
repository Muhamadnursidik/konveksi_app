import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/penjahit_controller.dart';
import '../../../../core/services/token_service.dart';

class PenjahitDashboardTab extends StatelessWidget {
  const PenjahitDashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PenjahitController>();

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

            // Stats
            Obx(() {
              final s = c.stats.value;
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _statCard(
                        value: '${s?.jobMenunggu ?? 0}',
                        sub: 'Menunggu dijahit',
                        label: 'Job Menunggu',
                        icon: Icons.pending_actions_rounded,
                        iconBg: const Color(0xFFFFF7ED),
                        iconColor: const Color(0xFFF97316),
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _statCard(
                        value: '${s?.targetHariIni ?? 0}',
                        sub: 'Target hari ini',
                        label: 'Target Jahit',
                        icon: Icons.track_changes_rounded,
                        iconBg: const Color(0xFFF5F3FF),
                        iconColor: const Color(0xFF8B5CF6),
                      )),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _statCard(
                    value: '${s?.selesaiHariIni ?? 0}',
                    sub: 'Selesai hari ini',
                    label: 'Selesai',
                    icon: Icons.check_circle_outline_rounded,
                    iconBg: const Color(0xFFF0FDF4),
                    iconColor: const Color(0xFF22C55E),
                    wide: true,
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
                    child: Text('Job Siap Dijahit',
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
                        Expanded(
                            child: Text('TARGET',
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
                            child: Text('Tidak ada job',
                                style: TextStyle(color: Color(0xFF94A3B8)))),
                      );
                    }
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: c.jobs.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1, color: Color(0xFFF1F5F9)),
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
                                    borderRadius: BorderRadius.circular(20),
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('KERJAKAN',
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
    bool wide = false,
  }) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: wide
            ? Row(children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(value,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0F172A))),
                  Text(sub,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF64748B))),
                  const SizedBox(height: 4),
                  Text(label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151))),
                ]),
                const Spacer(),
                Container(
                    width: 48,
                    height: 48,
                    decoration:
                        BoxDecoration(color: iconBg, shape: BoxShape.circle),
                    child: Icon(icon, color: iconColor, size: 22)),
              ])
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                          decoration: BoxDecoration(
                              color: iconBg, shape: BoxShape.circle),
                          child: Icon(icon, color: iconColor, size: 18)),
                    ]),
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
              ]),
      );
}