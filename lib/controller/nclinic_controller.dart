import 'package:get/get.dart';
import 'package:projectalpha/models/nclinics_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class ClinicController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<NClinic> clinics = <NClinic>[].obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchClinics();
  }

  Future<void> fetchClinics() async {
    try {
      isLoading.value = true;
      final response = await DioHelper.getData(url: 'clinics');

      if (response.data['status'] == true) {
        final List clinicData = response.data['data']['data'];

        clinics.value = clinicData.map((json) => NClinic.fromJson(json)).toList();
      } else {
        errorMessage.value = 'Error fetching clinics';
      }
    } catch (e) {
      print("Error: $e");
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
    update();
  }


}
