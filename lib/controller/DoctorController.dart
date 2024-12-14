import 'package:get/get.dart';
import 'package:projectalpha/services/dio_helper.dart';


class DoctorController extends GetxController {
  var isLoading = false.obs;
  var doctorData = Rx<Doctor?>(null);
  var availableSlots = <String>[].obs;


  Future<void> fetchDoctorData(int doctorId) async {
    isLoading(true);
    try {
      final response = await DioHelper.getData(url: '/doctors/id/$doctorId');
      if (response.statusCode == 200) {
        doctorData.value = Doctor.fromJson(response.data['data']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب بيانات الطبيب');
    } finally {
      isLoading(false);
    }
  }

  Future<bool> updateDoctorData(int doctorId, Map<String, dynamic> data) async {
    isLoading(true);
    try {
      final response = await DioHelper.putData(url: '/doctors/$doctorId', data: data);

      if (response.data != null && response.data['status']) {
        doctorData.value = Doctor.fromJson(response.data['data']);
        Get.back();
        Get.snackbar('نجاح', 'تم تحديث بيانات الطبيب بنجاح');
        return true;

      } else {
        Get.snackbar('خطأ', 'فشل في تحديث بيانات الطبيب. لا توجد بيانات صحيحة.');
        return false;

      }
    } catch (e) {
      print('Error updating doctor data: $e');
      Get.snackbar('خطأ', 'فشل في تحديث بيانات الطبيب: ${e.toString()}');
      return false;

    } finally {

      isLoading(false);

    }
  }


  Future<void> getAvailableSlots(int doctorId, String date) async {
    isLoading(true);
    try {
      final response = await DioHelper.getData(url: '/doctors/$doctorId/available-slots', query: {'date': date});
      if (response.statusCode == 200) {
        availableSlots.assignAll(List<String>.from(response.data['data']));
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في جلب المواعيد المتاحة');
    } finally {
      isLoading(false);
    }
  }
}

class Doctor {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String specialization;
  final int experienceYears;
  final String education;
  final String startWorkTime;
  final String endWorkTime;
  final int defaultTimeReservations;
  final String bio;
  final String photo;
  final int majorId;
  final int clinicId;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.specialization,
    required this.experienceYears,
    required this.education,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.defaultTimeReservations,
    required this.bio,
    required this.photo,
    required this.majorId,
    required this.clinicId,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      name: json['user']?['name'] ?? 'غير موجود',
      email: json['user']?['email'] ?? 'غير موجود',
      phone: json['user']?['phone'] ?? 'غير موجود',
      address: json['user']?['address'] ?? 'غير موجود',
      specialization: json['specialization'] ?? 'غير محدد',
      experienceYears: json['experience_years'] ?? 0,
      education: json['education'] ?? 'غير محدد',
      startWorkTime: json['start_work_time'] ?? 'غير محدد',
      endWorkTime: json['end_work_time'] ?? 'غير محدد',
      defaultTimeReservations: json['default_time_reservations'] ?? 0,
      bio: json['bio'] ?? 'لا توجد نبذة',
      photo: json['photo'] ?? '',
      majorId: json['major']?['id'] ?? 0,
      clinicId: json['clinic']?['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
      },
      'specialization': specialization,
      'experience_years': experienceYears,
      'education': education,
      'start_work_time': startWorkTime,
      'end_work_time': endWorkTime,
      'default_time_reservations': defaultTimeReservations,
      'bio': bio,
      'photo': photo,
      'major_id': majorId,
      'clinic_id': clinicId,
    };
  }
}
