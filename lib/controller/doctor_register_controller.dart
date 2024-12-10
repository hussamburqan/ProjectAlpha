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
  final selectedClinicWorkHours = RxMap<String, String>({}).obs;

  Box get authBox => authController.authBox;

  @override
  void onInit() {
    super.onInit();
    fetchMajorsAndClinics();
  }

  Future<void> fetchMajorsAndClinics() async {
    try {
      isLoading.value = true;

      final majorsResponse = await DioHelper.getData(url: 'majors');
      majors.value = List<Map<String, dynamic>>.from(
        majorsResponse.data.map((major) => {
          'id': major['id'],
          'name': major['name'],
        }),
      );

      final clinicsResponse = await DioHelper.getData(url: 'clinics');
      clinics.value = List<Map<String, dynamic>>.from(
        clinicsResponse.data['data'].map((clinic) => {
          'id': clinic['id'],
          'name': clinic['user']['name'],
          'opening_time': clinic['opening_time'],
          'closing_time': clinic['closing_time'],
        }),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load majors or clinics.');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSelectedClinicWorkHours(int clinicId) {
    final selectedClinic = clinics.firstWhere(
          (clinic) => clinic['id'] == clinicId,
      orElse: () => <String, dynamic>{},
    );

    if (selectedClinic != null) {
      selectedClinicWorkHours.update((val) {
        val?['opening_time'] = selectedClinic['opening_time'] ?? '';
        val?['closing_time'] = selectedClinic['closing_time'] ?? '';
      });
    }
  }

  Future<void> registerDoctor({
    required Map<String, dynamic> formDataMap,
    required String photoPath,
  }) async {
    try {
      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        ...formDataMap,
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

      authController.saveUserDataReq(doctorResponse.data,false,true);
      Get.offAllNamed('/mainhomedoctor');
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
