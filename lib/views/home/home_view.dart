import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../core/services/token_service.dart';
import '../../app/routes/app_routes.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.dialog(
              AlertDialog(
                title: const Text('Logout'),
                content: const Text('Yakin ingin keluar?'),
                actions: [
                  TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
                  TextButton(onPressed: auth.logout, child: const Text('Logout')),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info user
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      child: Icon(Icons.person, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TokenService.getUserName() ?? '-',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          TokenService.getUserEmail() ?? '-',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        Chip(
                          label: Text(TokenService.getUserRole() ?? '-'),
                          backgroundColor: Colors.blue.shade100,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('Lihat Items'),
              onPressed: () => Get.toNamed(AppRoutes.itemList),
            ),
          ],
        ),
      ),
    );
  }
}