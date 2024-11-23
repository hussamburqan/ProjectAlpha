import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:projectalpha/View/NClinicPage.dart';
import 'package:projectalpha/View/NotificationPage.dart';
import 'package:projectalpha/component/MyNavBar.dart';
import 'package:projectalpha/controller/navbar_controller.dart';
import 'package:projectalpha/view/HomePage.dart';
import 'package:projectalpha/view/SettingPage.dart';
import 'package:get/get.dart';

class MainHomepage extends StatefulWidget {
  const MainHomepage({super.key});

  @override
  State<MainHomepage> createState() => _MainHomepageState();
}

class _MainHomepageState extends State<MainHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(-15703137),
        title: GetBuilder<Navbarcontroller>(
          builder: (controller)=> 
          Text(
            controller.pagenumber == 0 
            ? "الصفحة الرئيسية"
            : controller.pagenumber == 1
            ? 'الاشعارات'
            : controller.pagenumber == 2
            ? 'العيادات'
            : controller.pagenumber == 3
            ? 'الاعدادات'
            : '',
          style: const TextStyle(color: Colors.white),
        ),),
        
        centerTitle: true,
      ),
      backgroundColor: const Color(-657931),
      body: Stack(
        children: [
          GetBuilder<Navbarcontroller>(
            builder: (controller) => 
            controller.pagenumber == 0
            ? Homepage()
            : controller.pagenumber == 1
            ? NotificationsPage()
            : controller.pagenumber == 2
            ? ClinicListPage()
            : controller.pagenumber == 3
            ? Settingpage()
            : const Placeholder()
          ),

          const MyNavBar()
        ],
      ),
    );
  }
}

