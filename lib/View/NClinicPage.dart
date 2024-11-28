import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/nclinic_controller.dart';
import 'package:projectalpha/View/ClinicDetailsPage.dart';
import 'package:projectalpha/component/MyImage.dart';

class ClinicListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GetBuilder<ClinicController>(
      init: ClinicController(),
      builder: (controller) {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.errorMessage.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }
        return ListView.builder(
          itemCount: controller.clinics.length,
          itemBuilder: (context, index) {
            final clinic = controller.clinics[index];
            return InkWell(
              onTap: () {
                Get.to(() => ClinicDetailsPage(clinic: clinic));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  color: Color(-789517),
                  elevation: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(screenSize.width * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                clinic.user.name,
                                style: TextStyle(
                                  fontSize: screenSize.height * 0.02,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.005),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Card(
                                    color: Color(-6197065),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.017,
                                        vertical: screenSize.height * 0.005,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            clinic.location,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenSize.height * 0.012,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          SvgPicture.asset(
                                            'assets/city.svg',
                                            height: screenSize.height * 0.015,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Card(
                                    color: Color(-9070680),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.width * 0.017,
                                        vertical: screenSize.height * 0.005,
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            clinic.major.name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                              screenSize.height * 0.012,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          SvgPicture.asset(
                                            'assets/type.svg',
                                            height: screenSize.height * 0.014,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Card(
                                color: Color(-13280354),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.015,
                                    vertical: screenSize.height * 0.005,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${clinic.openingTime} - ${clinic.closingTime}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenSize.height * 0.012,
                                        ),
                                      ),
                                      SizedBox(
                                        width: screenSize.width * 0.005,
                                      ),
                                      Icon(
                                        color: Colors.white,
                                        Icons.access_time_filled,
                                        size: screenSize.height * 0.015,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (clinic.photo != null)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyImageNet(
                            path: clinic.photo!,
                            sizeh: screenSize.height,
                          ),
                        )
                      else
                        Image.asset(
                          'assets/doctor_placeholder.jpg',
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
