import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/component/MyImage.dart';

class TypeReg extends StatelessWidget {
  const TypeReg({super.key});

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
                  alignment: Alignment.center,
                  child: Text(
                    'إختر نوع حسابك',
                    style: TextStyle(fontSize: screenSize.height * 0.03, color: Colors.white),
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05 ),

                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(onTap: () {

                    },
                      child: Card(
                        child: Container(
                            height: screenSize.height*0.1,
                            width: screenSize.height*0.1,
                            child: Column(
                              children: [
                                SizedBox(height: screenSize.height * 0.005 ),
                                Container(
                                  height: screenSize.height * 0.05,
                                    child: MyImage(path: 'assets/clinic.png')
                                ),
                                SizedBox(height: screenSize.height * 0.01 ),
                                Text('عيادة')

                              ],
                            )
                        ),
                      ),
                    ),

                    InkWell(onTap: () {
                      Get.toNamed('/regp');

                    },
                      child: Card(
                        child: Container(
                            height: screenSize.height*0.1,
                            width: screenSize.height*0.1,
                            child: Column(
                              children: [
                                SizedBox(height: screenSize.height * 0.005 ),
                                Container(
                                    height: screenSize.height * 0.05,
                                    child: MyImage(path: 'assets/petinet.png')
                                ),
                                SizedBox(height: screenSize.height * 0.01 ),
                                Text('مريض')

                              ],
                            )
                        ),
                      ),
                    ),
                    InkWell(onTap: () {
                      Get.toNamed('/regd');
                    },
                      child: Card(
                        child: Container(
                            height: screenSize.height*0.1,
                            width: screenSize.height*0.1,
                            child: Column(
                              children: [
                                SizedBox(height: screenSize.height * 0.005 ),
                                Container(
                                    height: screenSize.height * 0.05,
                                    child: MyImage(path: 'assets/doctor_placeholder.png')
                                ),
                                SizedBox(height: screenSize.height * 0.01 ),
                                Text('دكتور')

                              ],
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
