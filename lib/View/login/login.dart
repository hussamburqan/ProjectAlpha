import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final DraggableScrollableController _controller = DraggableScrollableController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final authController = Get.put(AuthController());

  bool isLoading = false;
  Future<void> login() async {

    if (emailController.text.isEmpty ) {
      Get.snackbar('خطأ', 'يرجى إدخال الايميل');
      return;
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(emailController.text)) {
      Get.snackbar('خطأ', 'صيغة البريد الإلكتروني غير صحيحة');
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال كلمة المرور');
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      await authController.login(emailController.text, passwordController.text);
    } catch (error) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تسجيل الدخول');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(-15441249),
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/circle2.svg',
            color: const Color(-15904640),
            height: screenSize.height * 0.238,
          ),
          SvgPicture.asset(
            'assets/circle1.svg',
            color: const Color(-15971464),
            height: screenSize.height * 0.2,
          ),
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.01, top: screenSize.height * 0.025),
            child: Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(
                'assets/logo.svg',
                height: screenSize.height * 0.1,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.39 ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'سجل الدخول الى حسابك',
                    style: TextStyle(fontSize: screenSize.width * 0.07, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
            controller: _controller,expand: true,
            initialChildSize: 0.55,
            minChildSize: 0.55,
            maxChildSize: 0.55,

            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenSize.height * 0.01),
                    const Center(
                    child: SizedBox(
                      width: 50,
                      child: Divider(
                        thickness: 5,
                      ),
                    ),
                  ),
                    SizedBox(height: screenSize.height * 0.01),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.all(screenSize.width * 0.05),
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'البريد الالكتروني',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.045,
                                color: Colors.black,
                                fontFamily: 'Hacen',
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.01),

                          Container(
                            height: screenSize.height * 0.05,
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenSize.height * 0.02),

                          Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              'كلمة المرور',
                              style: TextStyle(fontSize: screenSize.width * 0.045),
                            ),
                          ),

                          SizedBox(height: screenSize.height * 0.01),

                          Container(
                            height: screenSize.height * 0.05,
                            child: TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenSize.height * 0.02),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : login,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text('تسجيل الدخول', style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),

                          GestureDetector(
                            onTap: () {

                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.015),

                          const Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                              Text(
                                ' او سجل حساب ',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Expanded(
                                child: Divider(
                                  thickness: 2,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenSize.height * 0.02),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed('/typereg');
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(15),
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'أنشاء حساب',
                                style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}