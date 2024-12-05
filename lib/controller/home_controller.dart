import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/models/medical_news_model.dart';
import 'package:projectalpha/models/reservation_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class HomeController extends GetxController {
  RxBool isLoadingN = true.obs;
  RxBool isLoadingR = true.obs;
  var newsList = <MedicalNews>[].obs;
  final AuthController authController = Get.find<AuthController>();
  final reservations = <Reservation>[].obs;

  List<String> options = ['1', '2', '3'];

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> cancelReservation(int reservationId) async {
    try {
      final response = await DioHelper.deleteData(
        url: 'reservations/$reservationId',
      );

      if (response.data['status'] == true) {
        reservations.removeWhere((reservation) => reservation.id == reservationId);
        Get.snackbar(
          'نجاح',
          'تم إلغاء الحجز بنجاح',
        );
      } else {
        throw Exception('Failed to cancel reservation');
      }
    } catch (e) {
      print('Error cancelling reservation: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إلغاء الحجز',
      );
    }
  }

  Future<void> getReservations(String status) async {
    try {
      isLoadingR.value = true;
      final patientId = authController.getPatientId();
      late final query;
      if(status != ''){

        query = {
          'patient_id': patientId,
          'status': status,
        };
      } else {
        query = {
          'patient_id': patientId,
        };

      }

      final response = await DioHelper.getData(
        url: 'reservations/search',
        query: query,
      );

      print('Response Data: ${response.data}');

      if (response.data['status'] == true && response.data['data'] != null) {
        final List<dynamic> reservationsData = response.data['data'];

        reservations.value = reservationsData
            .map((json) => Reservation.fromJson(json))
            .toList();
        print('test');
      } else {
        throw Exception('Failed to load reservations');
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء جلب الحجوزات',

      );
    } finally {
      isLoadingR.value = false;
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
