class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String login = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';

  // Pemotong
  static const String pemotongJobs = '$baseUrl/pemotong/jobs';
  static const String pemotongRiwayat = '$baseUrl/pemotong/riwayat';
  static const String pemotongBahanBaku = '$baseUrl/pemotong/bahan-baku';
  static const String pemotongStats = '$baseUrl/pemotong/stats';
  static String pemotongSelesai(int id) => '$baseUrl/pemotong/jobs/$id/selesai';

  // Penjahit
  static const String penjahitStats = '$baseUrl/penjahit/stats';
  static const String penjahitJobs = '$baseUrl/penjahit/jobs';
  static const String penjahitRiwayat = '$baseUrl/penjahit/riwayat';
  static const String penjahitModelPakaian = '$baseUrl/penjahit/model-pakaian';
  static String penjahitSelesai(int id) => '$baseUrl/penjahit/jobs/$id/selesai';

  // Finishing
  static const String finishingStats = '$baseUrl/finishing/stats';
  static const String finishingJobs = '$baseUrl/finishing/jobs';
  static const String finishingRiwayat = '$baseUrl/finishing/riwayat';
  static String finishingSelesai(int id) =>'$baseUrl/finishing/jobs/$id/selesai';
}
