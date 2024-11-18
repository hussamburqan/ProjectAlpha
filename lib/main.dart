import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:projectalpha/Controller/home_controller.dart';
import 'package:projectalpha/controller/filter_controller.dart';
import 'package:projectalpha/controller/navbar_controller.dart';
import 'package:projectalpha/login/register.dart';
import 'package:projectalpha/services/data.dart';
import 'package:projectalpha/services/dio_helper.dart';
import 'package:projectalpha/view/HomePage/HomePage.dart';
import 'package:projectalpha/view/HomePage/MainHomePage.dart';
import 'package:projectalpha/login/login.dart';
import 'package:projectalpha/theme/themes.dart';
import 'package:projectalpha/view/setting/settingpage.dart';

void main() async {
  Get.put(Navbarcontroller());
  Get.put(Filtercontroller());
  Get.put(HomeController());
  DioHelper.init();
  await HiveHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/login',
      getPages: [
        GetPage(name: "/login", page: () => LoginPage()),  
        GetPage(name: "/reg", page: () => RegForm()),  
        GetPage(name: "/mainhome", page: () => MainHomepage()),  
        GetPage(name: "/home", page: () => Homepage()),       
        GetPage(name: "/setting", page: () => Settingpage()),
        ],
    );
  }
}

