import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/View/Doctor/doctorhome.dart';
import 'package:projectalpha/View/login/login.dart';
import 'package:projectalpha/view/MainHomePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward();

    Future.delayed(Duration(seconds: 3), () {
      print('Is user logged in? ${authController.isLogged}');

      final patientId = authController.getPatientId();
      final doctorId = authController.getDoctorId();

      print('Patient ID: $patientId');
      print('Doctor ID: $doctorId');

      if (authController.isLogged) {
        if (patientId != null) {
          Get.offAll(() => MainHomepage());
        } else if (doctorId != null) {
          Get.offAll(() => MainHomeDoctor());
        } else {
          Get.offAll(() => LoginPage());
        }
      } else {
        Get.offAll(() => LoginPage());
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(-15702880),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/circle2.svg',
            color: Color(-15904640),
            height: screenSize.height * 0.238,
          ),
          SvgPicture.asset(
            'assets/circle1.svg',
            color: Color(-15971464),
            height: screenSize.height * 0.2,
          ),

          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/logo.svg',
                    height: screenSize.height * 0.15,
                  ),
                  SizedBox(height: screenSize.height * 0.04),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}