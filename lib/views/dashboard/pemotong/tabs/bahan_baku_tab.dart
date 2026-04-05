import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controllers/pemotong_controller.dart';
import '../../../../models/bahan_baku_model.dart';

class BahanBakuTab extends StatelessWidget {
  const BahanBakuTab({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<PemotongController>();

    return Obx(() {
      if (c.isLoadingBahan.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return RefreshIndicator(
        onRefresh: c.fetchBahanBaku,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Data Bahan Baku',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A))),
              const SizedBox(height: 4),
              const Text('Informasi stok bahan baku tersedia',
                  style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 16),

              if (c.bahanBaku.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text('Tidak ada data bahan baku',
                        style: TextStyle(color: Color(0xFF94A3B8))),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: c.bahanBaku.length,
                  itemBuilder: (_, i) => _BahanCard(bahan: c.bahanBaku[i]),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _BahanCard extends StatelessWidget {
  final BahanBakuModel bahan;
  const _BahanCard({required this.bahan});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Foto
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(12)),
            child: bahan.foto != null
                ? Image.network(
                    bahan.foto!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fotoPlaceholder(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _fotoLoading(),
                  )
                : _fotoPlaceholder(),
          ),

          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bahan.nama,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0F172A)),
                  ),
                  if (bahan.warna != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.palette_outlined,
                            size: 13, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 4),
                        Text(bahan.warna!,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B))),
                      ],
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '${bahan.stok} ${bahan.satuan}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: bahan.stokMenipis
                              ? const Color(0xFFEF4444)
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: bahan.stokMenipis
                              ? const Color(0xFFFEF2F2)
                              : const Color(0xFFF0FDF4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          bahan.stokMenipis ? 'Menipis' : 'Tersedia',
                          style: TextStyle(
                            fontSize: 11,
                            color: bahan.stokMenipis
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF22C55E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fotoPlaceholder() => Container(
    width: 90,
    height: 90,
    color: const Color(0xFFF1F5F9),
    child: const Icon(Icons.layers_outlined,
        color: Color(0xFFCBD5E1), size: 28),
  );

  Widget _fotoLoading() => Container(
    width: 90,
    height: 90,
    color: const Color(0xFFF1F5F9),
    child: const Center(
        child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2))),
  );
}