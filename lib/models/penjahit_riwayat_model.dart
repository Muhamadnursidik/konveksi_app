import 'package:flutter/material.dart';

class PenjahitRiwayatModel {
  final int     id;
  final String  modelPakaian;
  final String  bahan;
  final int     jumlahTarget;
  final String  status;
  final String? fotoBukti;
  final String  tanggal;

  PenjahitRiwayatModel({
    required this.id,
    required this.modelPakaian,
    required this.bahan,
    required this.jumlahTarget,
    required this.status,
    this.fotoBukti,
    required this.tanggal,
  });

  factory PenjahitRiwayatModel.fromJson(Map<String, dynamic> j) =>
      PenjahitRiwayatModel(
        id:           j['id'],
        modelPakaian: j['model_pakaian'],
        bahan:        j['bahan'],
        jumlahTarget: j['jumlah_target'],
        status:       j['status'],
        fotoBukti:    j['foto_bukti'],
        tanggal:      j['tanggal'],
      );

  String get statusLabel {
    switch (status) {
      case 'pending': return 'Menunggu ACC Admin';
      case 'dijahit': return 'Disetujui ✅';
      default:        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending': return const Color(0xFFF59E0B);
      case 'dijahit': return const Color(0xFF10B981);
      default:        return const Color(0xFF6B7280);
    }
  }
}