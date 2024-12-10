import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/models/doctor_reservation_model.dart';
import 'package:projectalpha/models/reservation_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class DoctorReservationController extends GetxController {
  final isLoading = false.obs;
  final upcomingReservations = <Reservation>[].obs;
  final pastReservations = <Reservation>[].obs;
  final reservations = <DoctorReservation>[].obs;
  final AuthController authController = Get.find<AuthController>();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getReservations() async {
    try {
      isLoading.value = true;
      final doctorId = authController.getDoctorId();

      final response = await DioHelper.getData(
        url: 'reservations/search',
        query: {
          'doctor_id': doctorId,
          'status': 'confirmed',
        },
      );

      if (response.data['status'] == true && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        reservations.value = data.map((json) => DoctorReservation.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ في جلب المواعيد',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
