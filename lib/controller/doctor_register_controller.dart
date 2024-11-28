import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/services/dio_helper.dart';
import 'package:projectalpha/models/doctor_model.dart';
import 'package:http_parser/http_parser.dart';

class DoctorRegisterController extends GetxController {
  final isLoading = false.obs;
  final majors = <Map<String, dynamic>>[].obs;
  final clinics = <Map<String, dynamic>>[].obs;
  final currentDoctor = Rx<Doctor?>(null);
  final AuthController authController = Get.find<AuthController>();

  Box get authBox => authController.authBox;

  @override
  void onInit() {
    super.onInit();
    fetchMajorsAndClinics();
  }

  /// Fetch Majors and Clinics
  Future<void> fetchMajorsAndClinics() async {
    try {
      isLoading.value = true;

      // Fetch majors
      final majorsResponse = await DioHelper.getData(url: 'majors');
      majors.value = List<Map<String, dynamic>>.from(
        majorsResponse.data.map((major) => {
          'id': major['id'],
          'name': major['name'],
        }),
      );

      // Fetch clinics
      final clinicsResponse = await DioHelper.getData(url: 'clinics');
      clinics.value = List<Map<String, dynamic>>.from(
        clinicsResponse.data['data'].map((clinic) => {
          'id': clinic['id'],
          'name': clinic['user']['name'],
        }),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load majors or clinics.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerDoctor({
    required String name,
    required String email,
    required String password,
    required String address,
    required String phone,
    required int age,
    required String gender,
    required int experienceYears,
    required String specialization,
    required String education,
    required String bio,
    required int majorId,
    required int clinicId,
    required String startWorkTime,
    required String endWorkTime,
    required int defaultTimeReservations,
    required String photoPath,
  }) async {
    try {
      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        'name': name,
        'address': address,
        'age': age,
        'gender': gender,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone,
        'experience_years': experienceYears,
        'specialization': specialization,
        'start_work_time': startWorkTime,
        'end_work_time': endWorkTime,
        'default_time_reservations': defaultTimeReservations,
        'education': education,
        'bio': bio,
        'major_id': majorId,
        'nclinic_id': clinicId,
        'photo': await dio.MultipartFile.fromFile(
          photoPath,
          filename: 'photo.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
      });

      final doctorResponse = await DioHelper.postData(
        url: 'doctors',
        data: formData,
      );

      if (doctorResponse.data['status'] != true) {
        throw doctorResponse.data['message'] ?? 'Doctor registration failed.';
      }
      authController.saveUserDataDoctor(doctorResponse.data);

      Get.offAllNamed('/mainhome');
      Get.snackbar('Success', 'Doctor account created successfully.');
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
