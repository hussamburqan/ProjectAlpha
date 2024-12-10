import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/ClinicSearchController.dart';
import 'package:projectalpha/Controller/home_controller.dart';
import 'package:projectalpha/View/ClinicDetailsPage.dart';
import 'package:projectalpha/View/news_details_page.dart';
import 'package:projectalpha/component/MyImage.dart';
import 'package:projectalpha/controller/filter_controller.dart';
import 'package:projectalpha/models/reservation_model.dart';
import 'package:projectalpha/services/constants.dart';

class Homepage extends GetView<HomeController> {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    controller.getNews();
    controller.getReservations('confirmed');
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchAndFilterRow(screenSize),
            SizedBox(height: screenSize.height * 0.03),
            _buildCarousel(screenSize),
            SizedBox(height: screenSize.height * 0.03),
            const Text('المواعيد القادمة',style: TextStyle(fontSize: 20)),
            _buildAppointmentList(controller,screenSize),
            SizedBox(height: screenSize.height * 0.1),

          ],
        ),
        _buildFilterCard(screenSize),
      ],
    );
  }

  Widget _buildSearchAndFilterRow(Size screenSize) {
    final ClinicSearchController searchController = Get.put(ClinicSearchController());

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              _buildFilterButton(screenSize),
              SizedBox(width: screenSize.width * 0.05),
              Expanded(
                child: TextField(
                  controller: searchController.searchController,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintTextDirection: TextDirection.rtl,
                    hintText: 'ابحث عن عيادة',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(-2631721)),
                    ),
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Obx(() {
            if (searchController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: searchController.searchController.text.isNotEmpty ?
              searchController.filteredClinics.length * (screenSize.height *0.125) : 0,
              child: Card(
                  color: Color(-789517),
                  elevation: 5,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.filteredClinics.length,
                    itemBuilder: (context, index) {
                      final clinic = searchController.filteredClinics[index];
                      return InkWell(
                        onTap: (){
                          Get.to(() => ClinicDetailsPage(clinic: clinic));
                        },
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
                                              '${clinic.openingTime.substring(0, 5)} - ${clinic.closingTime.substring(0, 5)}',
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
                                  path: '${AppConstants.baseURLPhoto}storage/${clinic.photo}',
                                  sizeh: screenSize.height,
                                ),
                              )
                            else
                              Image.asset(
                                'assets/doctor_placeholder.jpg',
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterButton(Size screenSize) {
    return AnimatedContainer(
      width: screenSize.height * 0.06,
      height: screenSize.height * 0.06,
      duration: const Duration(),
      child: GetBuilder<Filtercontroller>(
        builder: (controller) => ElevatedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            backgroundColor: WidgetStateProperty.all(
              controller.isenable ? Colors.white : const Color(-15441250),
            ),
            padding: WidgetStateProperty.all(EdgeInsets.zero),
          ),
          child: Image.asset(
            color: controller.isenable ? const Color(-15441250) : Colors.white,
            "assets/filter.png",
            height: screenSize.height * 0.025,
            width: screenSize.height * 0.025,
            fit: BoxFit.fill,
          ),
          onPressed: () {
            controller.changeEnable();
          },
        ),
      ),
    );
  }

  Widget _buildCarousel(Size screenSize) {
    return Obx(() => controller.isLoadingN.value
        ? Center(child: CircularProgressIndicator())
        : CarouselSlider(
      items: controller.newsList.map((news) => InkWell(onTap: () {
          Get.to(() => NewsDetailsPage(news: news));
        },
          child: Stack(
            fit: StackFit.expand,
            children: [
              news.image != null
                  ? MyImageNet(
                path: "${AppConstants.baseURLPhoto}storage/${news.image}",sizeh: screenSize.height,
              )
                  : Image.asset('assets/test1.png'),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                    ),
                  ),
                  child: Text(
                    news.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
        ),
      ).toList(),
      options: CarouselOptions(
        height: screenSize.height * 0.2,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 1,
        enableInfiniteScroll: false,
        reverse: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        enlargeFactor: 0.3,
        scrollDirection: Axis.horizontal,
      ),
    )
    );
  }

  Widget _buildAppointmentList(HomeController controller, Size screenSize) {
    return Obx(() {
      if (controller.isLoadingR.value) {
        return Center(child: CircularProgressIndicator());
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final filteredAppointments = controller.reservations
          .where((appointment) {
        final appointmentDateTime = DateTime.parse('${appointment.date} ${appointment.time}');
        final appointmentDate = DateTime(
            appointmentDateTime.year,
            appointmentDateTime.month,
            appointmentDateTime.day
        );

        return appointment.status == 'accepted' &&
            appointmentDate.compareTo(today) >= 0;
      })
          .toList()
        ..sort((a, b) {
          final dateTimeA = DateTime.parse('${a.date} ${a.time}');
          final dateTimeB = DateTime.parse('${b.date} ${b.time}');
          return dateTimeA.compareTo(dateTimeB);
        });

      if (filteredAppointments.isEmpty) {
        return Center(child: Text('لا توجد مواعيد قادمة.'));
      }

      return Expanded(
        child: ListView.builder(
          itemCount: filteredAppointments.length,
          itemBuilder: (context, index) {
            return _buildAppointmentCard(filteredAppointments[index], screenSize);
          },
        ),
      );
    });
  }

  Widget _buildAppointmentCard(Reservation Reservation, Size screenSize) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.02,
        vertical: screenSize.height * 0.005,
      ),
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
                      Reservation.doctorName,
                      style: TextStyle(
                        fontSize: screenSize.height * 0.02,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    Text(
                      Reservation.clinicName,
                      style: TextStyle(
                        color: const Color(-7763575),
                        fontSize: screenSize.height * 0.02,
                      ),
                    ),
                    SizedBox(height: screenSize.height * 0.005),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${Reservation.date} - ${Reservation.time}',
                          style: TextStyle(
                            color: const Color(-13280354),
                            fontSize: screenSize.height * 0.017,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.005),
                        Icon(
                          Icons.access_time_filled,
                          color: Color(-13280354),
                          size: screenSize.height * 0.025,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (Reservation.doctorPhoto != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyImageNet(
                  path: '${AppConstants.baseURLPhoto}storage/${Reservation.doctorPhoto}',
                  sizeh: screenSize.height
                ),
              )
            else
              Image.asset('assets/doctor_placeholder.jpg'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterCard(Size screenSize) {
    final ClinicSearchController searchController = Get.find<ClinicSearchController>();

    return GetBuilder<Filtercontroller>(
      builder: (filterController) => AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        right: screenSize.width * 0.04,
        top: filterController.isenable ? screenSize.height * 0.09 : 0.09,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubicEmphasized,
          child: filterController.isenable
              ? SizedBox(
            width: screenSize.width * 0.75,
            height: screenSize.height * 0.06,
            child: Card(
              color: const Color(-789517),
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(() => DropdownButton<String>(
                    hint: Text("التخصص"),
                    value: searchController.selectedSpecialization.value.isEmpty ?
                    null : searchController.selectedSpecialization.value,
                    items: searchController.specializations.map((String specialization) {
                      return DropdownMenuItem<String>(
                        value: specialization,
                        child: Text(specialization),
                      );
                    }).toList(),
                    onChanged: searchController.setSpecialization,
                  )),
                  Obx(() => DropdownButton<String>(
                    hint: Text("المحافظة"),
                    value: searchController.selectedLocation.value.isEmpty ?
                    null : searchController.selectedLocation.value,
                    items: searchController.locations.map((String location) {
                      return DropdownMenuItem<String>(
                        value: location,
                        child: Text(location),
                      );
                    }).toList(),
                    onChanged: searchController.setLocation,
                  )),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: searchController.resetFilters,
                  )
                ],
              ),
            ),
          )
              : const SizedBox(),
        ),
      ),
    );
  }
}