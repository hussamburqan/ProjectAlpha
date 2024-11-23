import 'package:projectalpha/models/nclinics_model.dart';
import 'dio_helper.dart';

class NClinicController {
  static Future<List<NClinic>> fetchClinics() async {
    try {
      final response = await DioHelper.getData(url: 'clinics');
      final List<dynamic> data = response.data['data'];

      return data.map((clinic) => NClinic.fromJson(clinic)).toList();
    } catch (error) {
      throw Exception('Failed to load clinics: $error');
    }
  }
}
