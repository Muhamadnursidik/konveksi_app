class StatsModel {
  final int jobAktif;
  final int selesaiHariIni;
  final int totalTarget;

  StatsModel({
    required this.jobAktif,
    required this.selesaiHariIni,
    required this.totalTarget,
  });

  factory StatsModel.fromJson(Map<String, dynamic> j) => StatsModel(
    jobAktif:        j['job_aktif'],
    selesaiHariIni:  j['selesai_hari_ini'],
    totalTarget:     j['total_target'],
  );
}