import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/View/DoctorBookingPage.dart';
import 'package:projectalpha/component/MyImage.dart';
import 'package:projectalpha/models/nclinics_model.dart';
import 'package:projectalpha/services/constants.dart';

class ClinicDetailsPage extends StatelessWidget {
  final Clinic clinic;

  const ClinicDetailsPage({Key? key, required this.clinic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(-131587),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Cover Image
                Container(
                  height: screenSize.height * 0.2,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/Cover.png',
                    fit: BoxFit.cover,
                  ),
                ),
                // Main Content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    child: Column(                          crossAxisAlignment: CrossAxisAlignment.end,

                      children: [
                        // Fixed Header Content
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              clinic.user.name,
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              clinic.location,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            Text(
                              clinic.description,
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'أطباء المركز',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 16),
                          ],
                        ),
                        // Scrollable Doctors List
                        Expanded(
                          child: ListView.builder(
                            itemCount: clinic.doctors.length,
                            itemBuilder: (context, index) {
                              final doctor = clinic.doctors[index];
                              return _buildDoctorCard(doctor, screenSize);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Top Cards
            Positioned(
              top: screenSize.height * 0.205,
              right: screenSize.width * 0.25,
              child: _buildInfoCards(clinic, screenSize),
            ),
            // Back Button
            Positioned(
              top: screenSize.height * 0.08,
              left: screenSize.width * 0.05,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: InkWell(
                  child: Icon(Icons.arrow_back_outlined, color: Colors.black),
                  onTap: () {
              print("Can Pop: ${Get.routing.current}");
              print("Navigation History: ${Get.routing.route}");

              Get.back();
              },
                ),
              ),
            ),
            // Clinic Photo
            if (clinic.photo != null)
              Positioned(
                top: screenSize.height * 0.15,
                right: screenSize.width * 0.05,
                child: Container(
                  height: screenSize.height * 0.09,
                  width: screenSize.height * 0.09,
                  child: MyImageNet(
                    path: '${AppConstants.baseURLPhoto}storage/${clinic.photo}',
                    sizeh: screenSize.height,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorCard(dynamic doctor, Size screenSize) {
    return InkWell(
      onTap: () => Get.to(
          () => DoctorBookingPage(doctor: doctor, clinic: clinic),
      ),

      child: Card(
        color: Color(-4600864),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(-131587),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(screenSize.width * 0.02),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            doctor.name,
                            style: TextStyle(
                              fontSize: screenSize.height * 0.02,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.005),
                          _buildSpecializationCard(doctor, screenSize),
                          _buildEducationAndExperienceCards(doctor, screenSize),
                        ],
                      ),
                    ),
                  ),
                  _buildDoctorPhoto(doctor, screenSize),
                ],
              ),
            ),
            _buildBookingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecializationCard(dynamic doctor, Size screenSize) {
    return Card(
      color: Color(-13280354),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.015,
          vertical: screenSize.height * 0.005,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${doctor.specialization}',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.height * 0.012,
              ),
            ),
            SizedBox(width: screenSize.width * 0.005),
            SvgPicture.asset(
              'assets/type.svg',
              height: screenSize.height * 0.014,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationAndExperienceCards(dynamic doctor, Size screenSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
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
                  ' سنوات خبرة ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.height * 0.012,
                  ),
                ),
                Text(
                  '${doctor.experienceYears}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.height * 0.012,
                  ),
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
                  doctor.education,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenSize.height * 0.012,
                  ),
                ),
                SizedBox(width: 5),
                SvgPicture.asset(
                  'assets/education.svg',
                  height: screenSize.height * 0.014,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorPhoto(dynamic doctor, Size screenSize) {
    return doctor.photo != null
        ? Padding(
      padding: const EdgeInsets.all(8.0),
      child: MyImageNet(
        path: '${AppConstants.baseURLPhoto}storage/${doctor.photo}',
        sizeh: screenSize.height,
      ),
    )
        : Image.asset('assets/doctor_placeholder.jpg');
  }

  Widget _buildBookingButton() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 4,
        bottom: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.keyboard_arrow_left_sharp),
          Text('إحجز الأن'),
        ],
      ),
    );
  }

  Widget _buildInfoCards(Clinic clinic, Size screenSize) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTimeCard(clinic, screenSize),
        _buildMajorCard(clinic, screenSize),
        _buildLocationCard(clinic, screenSize),
      ],
    );
  }

  Widget _buildTimeCard(Clinic clinic, Size screenSize) {
    return Card(
      color: Color(-13280354),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.015,
          vertical: screenSize.height * 0.005,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${clinic.openingTime.substring(0, 5)} - ${clinic.closingTime.substring(0, 5)}',
              style: TextStyle(
                color: Colors.white,
                fontSize: screenSize.height * 0.012,
              ),
            ),
            SizedBox(width: screenSize.width * 0.005),
            Icon(
              Icons.access_time_filled,
              color: Colors.white,
              size: screenSize.height * 0.015,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMajorCard(Clinic clinic, Size screenSize) {
    return Card(
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
                fontSize: screenSize.height * 0.012,
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
    );
  }

  Widget _buildLocationCard(Clinic clinic, Size screenSize) {
    return Card(
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
    );
  }
}