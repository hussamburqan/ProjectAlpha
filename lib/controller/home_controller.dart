import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/models/medical_news_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class HomeController extends GetxController {
  RxBool isLoadingN = true.obs;
  RxBool isLoadingA = true.obs;
  var newsList = <MedicalNews>[].obs;
  final AuthController authController = Get.find<AuthController>();

  List<String> options = ['1', '2', '3'];

  @override
  void onInit() {
    super.onInit();
  }

  // Future<void> getAppointments() async {
  //   try {
  //     isLoadingA.value = true;
  //
  //     final patientId = int.parse("${authController.getPatientId()}");
  //     if (patientId == null) {
  //       Get.snackbar('خطأ', 'لم يتم العثور على معرّف المريض.');
  //       return;
  //     }
  //
  //     final response = await DioHelper.getData(
  //       url: 'patients/$patientId',
  //     );
  //
  //     print('Response Data: ${response.data}');
  //
  //     if (response.data['status'] && response.data['data'] != null) {
  //       final appointmentsData = response.data['data']['appointments'];
  //
  //       if (appointmentsData != null) {
  //         appointments.value = (appointmentsData as List)
  //             .map((json) => Appointment.fromJson(json))
  //             .toList();
  //       } else {
  //         Get.snackbar('تنبيه', 'لا توجد مواعيد حالياً.');
  //       }
  //     } else {
  //       throw Exception('فشل في جلب البيانات');
  //     }
  //   } catch (e) {
  //     print(e);
  //     Get.snackbar('خطأ', 'حدث خطأ: $e');
  //   } finally {
  //     isLoadingA.value = false;
  //   }
  // }

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
