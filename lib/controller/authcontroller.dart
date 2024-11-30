import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projectalpha/models/doctor_model.dart';
import '../models/user_model.dart';
import '../services/dio_helper.dart';

class AuthController extends GetxController {
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Patient?> currentPatient = Rx<Patient?>(null);
  final Rx<Doctor?> doctorPatient = Rx<Doctor?>(null);
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
      if (!Hive.isBoxOpen('auth')) {
        authBox = await Hive.openBox('auth');
        print('Hive box "auth" opened.');
      } else {
        authBox = Hive.box('auth');
        print('Hive box "auth" already open.');
      }
      await checkLoginStatus();
      isInitialized.value = true;
    } catch (e) {
      print('Error initializing Hive: $e');
      rethrow;
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
        print('Login successful. Saving user data...');
        if(response.data['data']['doctor'] != null){
          Get.offAllNamed('/mainhomedoctor');
          saveUserDataLogin(response.data);
        }else if (response.data['data']['patient'] != null){
          Get.offAllNamed('/mainhomepatient');
          saveUserDataLogin(response.data);
        }else{

        }

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
        token: getToken(),
      );
    } catch (e) {
      print("Logout failed: $e");
    } finally {
      await clearUserData();
      currentUser.value = null;
      currentPatient.value = null;
      doctorPatient.value = null;
      Get.offAllNamed('/login');
    }
  }


  Future<void> createPatient(Map<String, dynamic> userData) async {
    try {
      final response = await DioHelper.postData(
        url: 'patients',
        data: userData,
      );

      if (response.statusCode == 201) {

        print('trest');
        await saveUserDataReq(response.data,true,false);
        print('tresat');

        Get.offAllNamed('/mainhomepatient');
        Get.snackbar('نجاح', 'تم تسجيل حساب المريض بنجاح');

        } else {
        Get.snackbar('خطأ', 'حدث خطأ أثناء إنشاء حساب المريض');
      }
    } catch (e) {
      Get.snackbar('خطأ', '$e');
    }
  }

  Future<void> getUserData() async {
    try {
      final response = await DioHelper.getData(url: 'profile');
      if (response.data['status']) {
        currentUser.value = User.fromJson(response.data['data']);
        if (response.data['data']['patient'] != null) {
          currentPatient.value = Patient.fromJson(response.data['data']['patient']);
        }else if(response.data['data']['doctor'] != null){
          doctorPatient.value = Doctor.fromJson(response.data['data']['doctor']);
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> saveUserDataReq(Map<String, dynamic> data,bool patient,bool doctor ) async {

    final userData = data['data'];
    if(patient) {
      await authBox.putAll({
      'user_data':userData['user']['id'],
      'patient_id': userData['id'],
      'token': data['access_token']
    });
    } else if (doctor) {
      await authBox.putAll({
      'user_data': userData['user']['id'],
      'doctor_id': userData['id'],
      'token': data['access_token']
    });
    }
    DioHelper.setToken(data['access_token']);
  }

  Future<void> saveUserDataLogin(Map<String, dynamic> data) async {

    final userData = data['data'];
    if(userData['patient'] != null) {
      await authBox.putAll({
        'user_data':userData['id'],
        'patient_id': userData['patient']['id'],
        'token': data['access_token']
      });
    } else if (userData['doctor'] != null) {await authBox.putAll({
      'user_data': userData['id'],
      'doctor_id': userData['doctor']['id'],
      'token': data['access_token']
    });
    }
    DioHelper.setToken(data['access_token']);
  }

  Future<void> clearUserData() async {
    await authBox.clear();
    DioHelper.token = null;
  }

  String? getToken() {
    return authBox.get('token');
  }

  String? getUserid() {
    return authBox.get('user_data');
  }

  int getPatientId() {
    return authBox.get('patient_id');
  }
}