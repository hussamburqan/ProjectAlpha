import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/models/patient_archive_model.dart';
import 'package:projectalpha/services/dio_helper.dart';

class PatientArchiveController extends GetxController {
  final isLoading = false.obs;
  final archives = <PatientArchive>[].obs;
  final formKey = GlobalKey<FormState>();
  final searchQuery = ''.obs;
  final status = 'completed'.obs;

  @override
  void onInit() {
    super.onInit();
  }

  void searchPatients(String name) async {
    isLoading.value = true;
    try {
      print("Starting search with patient_name: $name");

      final authController = Get.find<AuthController>();
      final doctorId = authController.getDoctorId();

      final response = await DioHelper.getData(
        url: '/patientarchive',
        query: {
          'patient_name': name,
          'doctor_id': doctorId,
        },
      );

      print("Response received: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response data: ${response.data}");

        if (response.data['data'] != null) {
          archives.value = (response.data['data'] as List)
              .map((e) => PatientArchive.fromJson(e))
              .toList();
          print('ggggggggggggggggggggggggggggggggg');
        } else {
          print("Data is null or empty");
          archives.clear();
          Get.snackbar('خطأ', response.data['message']);
        }
      } else {
        print("Non-200 status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error during search: $e");
      archives.clear();
      Get.snackbar('خطأ', 'فشل البحث عن المرضى');
    } finally {
      isLoading.value = false;
      print("Search completed");
    }
  }


  Future<PatientArchive?> getArchiveByReservationId(int reservationId) async {
    try {
      final response = await DioHelper.getData(
          url: '/patientarchive',
          query: {
            'reservation_id': reservationId
          }
      );
      if (response.statusCode == 200 && response.data['data'] != null) {
        return response.data['data'][0];
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching archive: $error");
      return null;
    }
  }

  Future<void> submitArchive({
    required int reservationId,
    bool isEdit = false,
    int? archiveId,
    required String diagnosis,
    required String treatment,
  }) async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }

      isLoading.value = true;

      final authController = Get.find<AuthController>();
      final doctorId = authController.getDoctorId();

      final data = {
        'reservation_id': reservationId,
        'doctor_id': doctorId,
        'date': DateTime.now().toIso8601String(),
        'description': diagnosis,
        'instructions': treatment,
        'status': status.value,
      };

      final response = isEdit
          ? await DioHelper.putData(url: 'patientarchive/$archiveId', data: data)
          : await DioHelper.postData(url: 'patientarchive', data: data);

      if (response.data['status']) {
        Get.back();
        Get.snackbar(
          'نجاح',
          isEdit ? 'تم تحديث السجل' : 'تم إنشاء السجل',
        );
      }
    } catch (e) {
      print('Error submitting archive: $e');
      Get.snackbar('خطأ', 'حدث خطأ في حفظ السجل');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteArchive(int archiveId) async {
    try {
      isLoading.value = true;
      final response = await DioHelper.deleteData(url: 'patientarchive/$archiveId');

      if (response.data['status']) {
        Get.snackbar('نجاح', 'تم حذف الأرشيف بنجاح');
      }
    } catch (e) {
      print('Error deleting archive: $e');
      Get.snackbar('خطأ', 'حدث خطأ في حذف الأرشيف');
    } finally {
      isLoading.value = false;
    }
  }
}
