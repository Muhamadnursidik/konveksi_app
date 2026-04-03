import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/pemotong_controller.dart';
import '../../../models/riwayat_model.dart';

class PemotongRiwayat extends StatelessWidget {
  const PemotongRiwayat({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PemotongController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Pekerjaan'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (c.isLoadingRiwayat.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (c.riwayat.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text('Belum ada riwayat',
                    style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: c.fetchRiwayat,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: c.riwayat.length,
            itemBuilder: (_, i) => _RiwayatCard(item: c.riwayat[i]),
          ),
        );
      }),
    );
  }
}

class _RiwayatCard extends StatelessWidget {
  final RiwayatModel item;
  const _RiwayatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Foto bukti
          if (item.fotoBukti != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.fotoBukti!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        height: 180,
                        color: Colors.grey.shade200,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.modelPakaian,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.statusLabel,
                        style:
                            TextStyle(color: item.statusColor, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _infoRow(Icons.layers_outlined,       'Bahan',   item.bahan),
                _infoRow(Icons.format_list_numbered,  'Target',  '${item.jumlahTarget} pcs'),
                _infoRow(Icons.calendar_today_outlined,'Tanggal', item.tanggal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 6),
        Text('$label: ', style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontSize: 13)),
      ],
    ),
  );
}