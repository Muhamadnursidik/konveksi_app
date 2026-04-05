import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/penjahit_controller.dart';

class PenjahitBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PenjahitController>(() => PenjahitController());
  }
}