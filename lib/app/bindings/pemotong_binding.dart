// app/bindings/pemotong_binding.dart
import 'package:get/get.dart';
import '../../controllers/pemotong_controller.dart';

class PemotongBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PemotongController>(() => PemotongController());
  }
}