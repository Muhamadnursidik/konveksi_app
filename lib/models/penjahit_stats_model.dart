class PenjahitStatsModel {
  final int jobMenunggu;
  final int targetHariIni;
  final int selesaiHariIni;

  PenjahitStatsModel({
    required this.jobMenunggu,
    required this.targetHariIni,
    required this.selesaiHariIni,
  });

  factory PenjahitStatsModel.fromJson(Map<String, dynamic> j) =>
      PenjahitStatsModel(
        jobMenunggu:     j['job_menunggu'],
        targetHariIni:   j['target_hari_ini'],
        selesaiHariIni:  j['selesai_hari_ini'],
      );
}