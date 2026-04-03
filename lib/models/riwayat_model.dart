import 'package:flutter/material.dart';

class RiwayatModel {
  final int     id;
  final String  modelPakaian;
  final String  bahan;
  final int     jumlahTarget;
  final String  status;   // pending | dipotong
  final String? fotoBukti;
  final String  tanggal;

  RiwayatModel({
    required this.id,
    required this.modelPakaian,
    required this.bahan,
    required this.jumlahTarget,
    required this.status,
    this.fotoBukti,
    required this.tanggal,
  });

  factory RiwayatModel.fromJson(Map<String, dynamic> j) => RiwayatModel(
    id:           j['id'],
    modelPakaian: j['model_pakaian'],
    bahan:        j['bahan'],
    jumlahTarget: j['jumlah_target'],
    status:       j['status'],
    fotoBukti:    j['foto_bukti'],
    tanggal:      j['tanggal'],
  );

  // ✅ Sesuai flow: pending = menunggu ACC, dipotong = sudah di-ACC
  String get statusLabel {
    switch (status) {
      case 'pending':  return 'Menunggu ACC Admin';
      case 'dipotong': return 'Disetujui ✅';
      default:         return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':  return const Color(0xFFF59E0B); // kuning
      case 'dipotong': return const Color(0xFF10B981); // hijau
      default:         return const Color(0xFF6B7280);
    }
  }
}