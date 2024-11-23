import 'package:get/get.dart';
import 'package:projectalpha/services/dio_helper.dart';

class PatientController extends GetxController {

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

}