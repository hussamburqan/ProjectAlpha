import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/models/medical_news_model.dart';
import 'package:projectalpha/models/reservation_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class HomeController extends GetxController {
  RxBool isLoadingN = true.obs;
  RxBool isLoadingA = true.obs;
  var newsList = <MedicalNews>[].obs;
  final AuthController authController = Get.find<AuthController>();
  final reservations = <Reservation>[].obs;

  List<String> options = ['1', '2', '3'];

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> getReservations() async {
    try {
      isLoadingA.value = true;

      final patientId = int.parse("${authController.getPatientId()}");
      if (patientId == null) {
        Get.snackbar(
          'خطأ',
          'لم يتم العثور على معرّف المريض',
        );
        return;
      }

      final response = await DioHelper.getData(
        url: 'reservations',
        query: {
          'patient_id': patientId.toString(),
        },
      );
      print('Response Data: ${response.data}');

      if (response.data['status'] && response.data['data'] != null) {
        final reservationsData = response.data['data'];

        if (reservationsData != null && reservationsData['data'] != null) {
          reservations.value = (reservationsData['data'] as List)
              .map((json) => Reservation.fromJson(json))
              .toList();
        } else {
          Get.snackbar(
            'تنبيه',
            'لا توجد حجوزات حالياً',
          );
        }
      } else {
        throw Exception('فشل في جلب البيانات');
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء جلب الحجوزات',
      );
    } finally {
      isLoadingA.value = false;
    }
  }

  Future<void> getNews() async {
    try {
      isLoadingN.value = true;
      var response = await DioHelper.getData(url: 'medical-news');
      print('News Data: ${response.data}');

      var newsData = response.data['data']['data'] as List;
      newsList.value = newsData.map((item) => MedicalNews.fromJson(item)).toList();
    } catch (e) {
      print(e);
    } finally {
      isLoadingN.value = false;
    }
  }
}
