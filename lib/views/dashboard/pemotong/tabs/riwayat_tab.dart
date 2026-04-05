import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/pemotong_controller.dart';
import '../../../../models/riwayat_model.dart';

class RiwayatTab extends StatelessWidget {
  const RiwayatTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PemotongController>();

    return Obx(() {
      if (c.isLoadingRiwayat.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (c.riwayat.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 64, color: Color(0xFFCBD5E1)),
              SizedBox(height: 12),
              Text('Belum ada riwayat',
                  style:
                      TextStyle(color: Color(0xFF94A3B8), fontSize: 15)),
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
    });
  }
}

class _RiwayatCard extends StatelessWidget {
  final RiwayatModel item;
  const _RiwayatCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.fotoBukti != null)
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.fotoBukti!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        height: 180,
                        color: const Color(0xFFF1F5F9),
                        child: const Center(
                            child: CircularProgressIndicator()),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  height: 100,
                  color: const Color(0xFFF1F5F9),
                  child: const Icon(Icons.broken_image,
                      color: Color(0xFFCBD5E1), size: 40),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(item.modelPakaian,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A))),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(item.statusLabel,
                          style: TextStyle(
                              color: item.statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _row(Icons.layers_outlined, 'Bahan', item.bahan),
                _row(Icons.format_list_numbered, 'Target',
                    '${item.jumlahTarget} pcs'),
                _row(Icons.calendar_today_outlined, 'Tanggal',
                    item.tanggal),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF94A3B8)),
            const SizedBox(width: 6),
            Text('$label: ',
                style: const TextStyle(
                    color: Color(0xFF64748B), fontSize: 13)),
            Text(value,
                style: const TextStyle(
                    fontSize: 13, color: Color(0xFF0F172A))),
          ],
        ),
      );
}