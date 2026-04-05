class FinishingJobModel {
  final int    id;
  final String modelPakaian;
  final String kategori;
  final String bahan;
  final int    jumlahTarget;
  final String status;

  FinishingJobModel({
    required this.id,
    required this.modelPakaian,
    required this.kategori,
    required this.bahan,
    required this.jumlahTarget,
    required this.status,
  });

  factory FinishingJobModel.fromJson(Map<String, dynamic> j) =>
      FinishingJobModel(
        id:           j['id'],
        modelPakaian: j['model_pakaian'],
        kategori:     j['kategori'] ?? '-',
        bahan:        j['bahan'],
        jumlahTarget: j['jumlah_target'],
        status:       j['status'],
      );
}