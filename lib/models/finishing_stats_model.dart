class FinishingStatsModel {
  final int jobMenunggu;
  final int selesaiHariIni;
  final int packingHariIni;
  final int jobAktif;

  FinishingStatsModel({
    required this.jobMenunggu,
    required this.selesaiHariIni,
    required this.packingHariIni,
    required this.jobAktif,
  });

  factory FinishingStatsModel.fromJson(Map<String, dynamic> j) =>
      FinishingStatsModel(
        jobMenunggu:     j['job_menunggu'],
        selesaiHariIni:  j['selesai_hari_ini'],
        packingHariIni:  j['packing_hari_ini'],
        jobAktif:        j['job_aktif'],
      );
}