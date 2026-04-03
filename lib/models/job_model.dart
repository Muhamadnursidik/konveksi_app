class JobModel {
  final int    id;
  final String modelPakaian;
  final String bahan;
  final int    jumlahTarget;
  final double kebutuhanBahan;
  final String status;

  JobModel({
    required this.id,
    required this.modelPakaian,
    required this.bahan,
    required this.jumlahTarget,
    required this.kebutuhanBahan,
    required this.status,
  });

  factory JobModel.fromJson(Map<String, dynamic> j) => JobModel(
    id:             j['id'],
    modelPakaian:   j['model_pakaian'],
    bahan:          j['bahan'],
    jumlahTarget:   j['jumlah_target'],
    kebutuhanBahan: double.tryParse(j['kebutuhan_bahan_total'].toString()) ?? 0,
    status:         j['status'],
  );
}