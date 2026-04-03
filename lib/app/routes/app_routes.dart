import 'package:get/get.dart';

// Auth
import '../../views/auth/login_view.dart';
import '../../views/home/home_view.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';

// ✅ Tambah ini — Pemotong
import '../../views/dashboard/pemotong/pemotong_home.dart';
import '../../views/dashboard/pemotong/pemotong_riwayat.dart';
import '../bindings/pemotong_binding.dart';

class AppRoutes {
  static const login    = '/login';
  static const home     = '/home';
  static const itemList = '/items';
  static const itemCreate = '/items/create';
  static const itemEdit   = '/items/edit';
  static const itemDetail = '/items/detail';

  // Pemotong
  static const pemotong        = '/pemotong';
  static const pemotongRiwayat = '/pemotong/riwayat';

  static final pages = [
    GetPage(name: login, page: () => const LoginView(), binding: AuthBinding()),
    GetPage(name: home,  page: () => const HomeView(),  binding: HomeBinding()),

    // Pemotong
    GetPage(name: pemotong,        page: () => const PemotongHome(),    binding: PemotongBinding()),
    GetPage(name: pemotongRiwayat, page: () => const PemotongRiwayat(), binding: PemotongBinding()),
  ];
}