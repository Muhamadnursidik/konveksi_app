class ApiConstants {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static const String login  = '$baseUrl/login';
  static const String logout = '$baseUrl/logout';

  // Pemotong
  static const String pemotongJobs    = '$baseUrl/pemotong/jobs';
  static const String pemotongRiwayat = '$baseUrl/pemotong/riwayat';
  static String pemotongSelesai(int id) => '$baseUrl/pemotong/jobs/$id/selesai';

}