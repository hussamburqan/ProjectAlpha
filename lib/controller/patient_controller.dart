import 'package:get/get.dart';
import 'package:projectalpha/services/dio_helper.dart';

class PatientController extends GetxController {
  var patientData = {}.obs;
  var isLoading = false.obs;

  Future<bool> createPatient(int userId) async {
    try {
      final response = await DioHelper.postData(
        url: '/patients',
        data: {
          'user_id': userId,
          'emergency_contact': '',
          'emergency_phone': '',
          'medical_history': 'No major issues',
          'allergies': 'None',
          'current_medications': 'None',
          'medical_recommendations': 'Regular checkups'
        },
      );
      return response.data['status'] ?? false;
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<void> fetchPatientData(int patientId) async {
    isLoading.value = true;
    try {
      final response = await DioHelper.getData(url: 'patients/$patientId');
      if (response.statusCode == 200 && response.data['status']) {
        patientData.value = response.data['data'];
      } else {
        Get.snackbar('Error', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch patient data.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updatePatientData(int patientId, Map<String, dynamic> updatedData) async {
    isLoading.value = true;
    try {
      final response = await DioHelper.putData(data: updatedData, url: 'patients/$patientId');
      if (response.statusCode == 200 && response.data['status']) {
        patientData.value = response.data['data'];
        Get.snackbar('نجاح', response.data['message']);
      } else {
        Get.snackbar('خطا', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('خطا', 'لم ينجح تعديل المعلومات.');
    } finally {
      isLoading.value = false;
    }
  }

}