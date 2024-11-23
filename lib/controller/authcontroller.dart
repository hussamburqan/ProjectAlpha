import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../services/dio_helper.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Patient?> currentPatient = Rx<Patient?>(null);
  final RxBool isInitialized = false.obs;
  late Box authBox;

  bool get isLogged => getToken() != null;

  @override
  void onInit() async {
    super.onInit();
    await initHive();
  }

  Future<void> initHive() async {
    try {
      await Hive.initFlutter();
      authBox = await Hive.openBox('auth');
      await checkLoginStatus();
      isInitialized.value = true;
    } catch (e) {
      print('Error initializing Hive: $e');
    }
  }

  Future<void> checkLoginStatus() async {
    final token = getToken();
    if (token != null) {
      await getUserData();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await DioHelper.postData(
        url: 'login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.data['status']) {
        await saveUserData(response.data);
        currentUser.value = User.fromJson(response.data['data']);

        if (response.data['data']['patient'] != null) {
          final patientData = response.data['data']['patient'];
          await authBox.put('patient_data', patientData['id']);
          currentPatient.value = Patient.fromJson(patientData);
        }

        Get.offAllNamed('/mainhome');
      } else {
        Get.snackbar('خطأ', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'يوجد خطأ في الإيميل أو كلمة المرور');
    }
  }

  Future<void> logout() async {
    try {
      await DioHelper.postData(
          url: 'logout',
          customToken: getToken()
      );
    } catch (e) {
      print("Logout failed: $e");
    } finally {
      await clearUserData();
      currentUser.value = null;
      currentPatient.value = null;
      Get.offAllNamed('/login');
    }
  }

  Future<void> registerUserAndPatient(Map<String, dynamic> userData) async {
    try {
      final response = await DioHelper.postData(
        url: 'register',
        data: userData,
      );

      if (response.data['status']) {
        await saveUserData(response.data);
        currentUser.value = User.fromJson(response.data['data']);

        await createPatient(response.data['data']['id'],response.data['data']['name'],response.data['data']['phone']);

        Get.offAllNamed('/mainhome');
        Get.snackbar('نجاح', 'تم تسجيل الحساب وإنشاء المريض بنجاح');
      } else {
        Get.snackbar('خطأ', response.data['message']);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء التسجيل: $e');
    }
  }

  Future<void> createPatient(int userId,String name,String phone) async {
    try {
      final response = await DioHelper.postData(
        url: 'patients',
        data: {
          'user_id': userId,
          "emergency_contact": name,
          "emergency_phone": phone,
          "medical_history": "No major issues",
          "allergies": "None",
          "current_medications": "None",
          "medical_recommendations": "Regular checkups",
        },
      );

      if (response.statusCode == 201) {
        currentPatient.value = Patient.fromJson(response.data['data']);
        await authBox.put('patient_data', response.data['data']['id']);
      } else {
        Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء حساب المريض');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء المريض: $e');
    }
  }

  Future<void> getUserData() async {
    try {
      final response = await DioHelper.getData(url: 'profile');
      if (response.data['status']) {
        currentUser.value = User.fromJson(response.data['data']);
        if (response.data['data']['patient'] != null) {
          currentPatient.value = Patient.fromJson(response.data['data']['patient']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUserData(Map<String, dynamic> data) async {
    await authBox.put('user_data', data['data']);
    await authBox.put('patient_data', data['data']['patient']);
    await authBox.put('token', data['access_token']);
    DioHelper.token = data['access_token'];
  }

  Future<void> clearUserData() async {
    await authBox.clear();
    DioHelper.token = null;
  }

  String? getToken() {
    return authBox.get('token');
  }

  int? getPatient() {
    return authBox.get('patient_data');
  }

  Map<String, dynamic>? getUserFromStorage() {
    return authBox.get('user_data');
  }

  Map<String, dynamic>? getPatientFromStorage() {
    return authBox.get('patient_data');
  }
}