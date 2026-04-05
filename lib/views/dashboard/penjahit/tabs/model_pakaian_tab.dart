import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/token_service.dart';

class ModelPakaianTab extends StatefulWidget {
  const ModelPakaianTab({super.key});

  @override
  State<ModelPakaianTab> createState() => _ModelPakaianTabState();
}

class _ModelPakaianTabState extends State<ModelPakaianTab> {
  List models = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() => loading = true);
    try {
      final res = await http.get(
        Uri.parse(ApiConstants.penjahitModelPakaian),
        headers: {
          'Authorization': 'Bearer ${TokenService.getToken()}',
          'Accept': 'application/json',
        },
      );
      if (res.statusCode == 200) {
        setState(() => models = jsonDecode(res.body)['data']);
      }
    } catch (_) {} finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return RefreshIndicator(
      onRefresh: _fetch,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Data Model Pakaian',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F172A))),
            const SizedBox(height: 4),
            const Text('Referensi model pakaian yang diproduksi',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 16),

            if (models.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Tidak ada data model pakaian',
                      style: TextStyle(color: Color(0xFF94A3B8))),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: models.length,
                itemBuilder: (_, i) => _ModelCard(model: models[i]),
              ),
          ],
        ),
      ),
    );
  }
}

class _ModelCard extends StatelessWidget {
  final Map model;
  const _ModelCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final foto = model['foto'] as String?;

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
          // Foto besar di atas
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
            child: foto != null
                ? Image.network(
                    foto,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fotoPlaceholder(),
                    loadingBuilder: (_, child, progress) =>
                        progress == null ? child : _fotoLoading(),
                  )
                : _fotoPlaceholder(),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model['nama'] ?? '-',
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    if (model['kategori'] != null)
                      _chip(Icons.category_outlined,
                          model['kategori']),
                    if (model['ukuran'] != null)
                      _chip(Icons.straighten_outlined,
                          model['ukuran']),
                    _chip(
                      Icons.layers_outlined,
                      '${model['kebutuhan_bahan']} m',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: const Color(0xFF64748B)),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                fontSize: 12, color: Color(0xFF475569))),
      ],
    ),
  );

  Widget _fotoPlaceholder() => Container(
    height: 160,
    width: double.infinity,
    color: const Color(0xFFF1F5F9),
    child: const Icon(Icons.checkroom_outlined,
        color: Color(0xFFCBD5E1), size: 48),
  );

  Widget _fotoLoading() => Container(
    height: 160,
    width: double.infinity,
    color: const Color(0xFFF1F5F9),
    child: const Center(child: CircularProgressIndicator()),
  );
}