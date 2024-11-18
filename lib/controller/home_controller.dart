import 'package:get/get.dart';
import 'package:projectalpha/models/appointment_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class HomeController extends GetxController {
  RxList<Appointment> appointments = <Appointment>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    getAppointments();
  }

  Future<void> getAppointments() async {
    try {
      isLoading.value = true;
      final response = await DioHelper.getData(url: 'appointments/all');

      if (response.data['status']) {
        appointments.value = (response.data['data'] as List)
            .map((json) => Appointment.fromJson(json))
            .toList();
      }
    } catch (e) {
      print(e);
      Get.snackbar('خطأ', 'حدث خطأ في جلب المواعيد');
    } finally {
      isLoading.value = false;
    }
  }
}