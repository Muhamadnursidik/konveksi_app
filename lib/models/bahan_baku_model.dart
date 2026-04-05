class BahanBakuModel {
  final int     id;
  final String  nama;
  final String? warna;
  final double  stok;
  final String  satuan;
  final String? foto;

  BahanBakuModel({
    required this.id,
    required this.nama,
    this.warna,
    required this.stok,
    required this.satuan,
    this.foto,
  });

  factory BahanBakuModel.fromJson(Map<String, dynamic> j) => BahanBakuModel(
    id:     j['id'],
    nama:   j['nama'],
    warna:  j['warna'],
    stok:   double.tryParse(j['stok'].toString()) ?? 0,
    satuan: j['satuan'],
    foto:   j['foto'],
  );

  bool get stokMenipis => stok < 5;
}