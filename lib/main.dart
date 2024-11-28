import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/Controller/home_controller.dart';
import 'package:projectalpha/View/Doctor/registerdoctor.dart';
import 'package:projectalpha/View/NClinicPage.dart';
import 'package:projectalpha/View/NotificationPage.dart';
import 'package:projectalpha/View/login/login.dart';
import 'package:projectalpha/View/login/logopage.dart';
import 'package:projectalpha/View/login/register.dart';
import 'package:projectalpha/View/login/typereg.dart';
import 'package:projectalpha/controller/filter_controller.dart';
import 'package:projectalpha/controller/navbar_controller.dart';
import 'package:projectalpha/services/dio_helper.dart';
import 'package:projectalpha/view/HomePage.dart';
import 'package:projectalpha/view/MainHomePage.dart';
import 'package:projectalpha/theme/themes.dart';
import 'package:projectalpha/view/SettingPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  DioHelper.init();

  final authController = Get.put(AuthController());
  await authController.initHive();

  Get.put(HomeController());
  Get.put(Navbarcontroller());
  Get.put(Filtercontroller());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,

      home: SplashScreen(),
      getPages: [
        GetPage(name: "/login", page: () => LoginPage()),
        GetPage(name: "/splach", page: () => SplashScreen()),
        GetPage(name: "/regp", page: () => RegFormP()),
        GetPage(name: "/regd", page: () => DoctorRegisterPage()),
        GetPage(name: "/mainhome", page: () => MainHomepage()),
        GetPage(name: "/home", page: () => Homepage()),
        GetPage(name: "/setting", page: () => Settingpage()),
        GetPage(name: "/nclinic", page: () => ClinicListPage()),
        GetPage(name: "/typereg", page: () => TypeReg()),
        GetPage(name: "/notification", page: () => NotificationsPage()),
      ],
    );
  }
}