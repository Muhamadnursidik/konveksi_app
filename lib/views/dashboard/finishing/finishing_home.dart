import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/finishing_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../core/services/token_service.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/job_tab.dart';
import 'tabs/riwayat_tab.dart';

class FinishingHome extends StatelessWidget {
  const FinishingHome({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<FinishingController>();
    final auth = Get.find<AuthController>();

    final tabs = [
      const FinishingDashboardTab(),
      const FinishingJobTab(),
      const FinishingRiwayatTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.content_cut_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'SewMaster',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Center(
              child: Text(
                TokenService.getUserName() ?? '-',
                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
            ),
          ),
          PopupMenuButton(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFE2E8F0),
              backgroundImage: TokenService.getUserPhoto() != null
                  ? NetworkImage(TokenService.getUserPhoto()!)
                  : null,
              child: TokenService.getUserPhoto() == null
                  ? Text(
                      (TokenService.getUserName() ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    )
                  : null,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                onTap: auth.logout,
                child: const Row(
                  children: [
                    Icon(Icons.logout, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Logout', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE2E8F0)),
        ),
      ),
      body: Obx(() => tabs[c.navIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          selectedIndex: c.navIndex.value,
          onDestinationSelected: (i) => c.navIndex.value = i,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          indicatorColor: const Color(0xFFEEF2FF),
          height: 65,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.dashboard_outlined),
              selectedIcon: Icon(Icons.dashboard, color: Color(0xFF4F46E5)),
              label: 'Dashboard',
            ),
            NavigationDestination(
              icon: Icon(Icons.dry_cleaning_outlined),
              selectedIcon: Icon(Icons.dry_cleaning, color: Color(0xFF4F46E5)),
              label: 'Job Finishing',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_outlined),
              selectedIcon: Icon(Icons.history, color: Color(0xFF4F46E5)),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}
