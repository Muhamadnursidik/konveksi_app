// app/bindings/finishing_binding.dart
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/finishing_controller.dart';

class FinishingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinishingController>(() => FinishingController());
  }
}