import 'package:dietapp_v002/login/controllers/welcome_controller.dart';
import 'package:get/get.dart';


class WelcomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WelcomeController>(WelcomeController());
  }
}