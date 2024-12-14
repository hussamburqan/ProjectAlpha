import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/controller/navbar_controller.dart';

class MyNavBarDoctor extends StatefulWidget {
  const MyNavBarDoctor({super.key});

  @override
  State<MyNavBarDoctor> createState() => _MyNavBarDoctorState();
}

class _MyNavBarDoctorState extends State<MyNavBarDoctor> {

  int i = 0;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30)
          ),
          color: Color(-131587),
        ),
        height: screenSize.height * 0.1,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NavItem(0, "assets/home.png", context),
              SizedBox(width: screenSize.width * 0.05),
              NavItem(1, "assets/something.png", context),
              SizedBox(width: screenSize.width * 0.05),
              NavItem(2, "assets/setting.png", context),
              SizedBox(width: screenSize.width * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<Navbarcontroller> NavItem(int index, String assetPath, BuildContext context) {
    return GetBuilder<Navbarcontroller>(
      builder: (controller) {
        return GestureDetector(
          onTap: () {
            controller.ChangeNumber(index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.height * 0.06,
            decoration: BoxDecoration(
              color: controller.pagenumber == index
                  ? const Color(-15703137)
                  : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Image.asset(
                assetPath,
                scale: 4,
                color: controller.pagenumber == index
                    ? Colors.white
                    : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}