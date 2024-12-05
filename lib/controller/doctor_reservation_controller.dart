import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/models/doctor_reservation_model.dart';
import 'package:projectalpha/models/patient_archive_model.dart';
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
    getReservations();
  }

  Future<void> getReservations() async {
    try {
      isLoading.value = true;
      final doctorId = authController.getDoctorId();

      final response = await DioHelper.getData(
        url: 'reservations',
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

class PatientArchiveController extends GetxController {
  final isLoading = false.obs;
  final archives = <PatientArchive>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchArchives();
  }

  Future<void> fetchArchives() async {
    try {
      isLoading.value = true;
    } catch (e) {
      print('Error fetching archives: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب السجلات');
    } finally {
      isLoading.value = false;
    }
  }

  void searchPatients(String query) {
    searchQuery.value = query;
  }
}