import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/home_controller.dart';
import 'package:projectalpha/View/news_details_page.dart';
import 'package:projectalpha/component/MyImage.dart';
import 'package:projectalpha/controller/filter_controller.dart';
import 'package:projectalpha/services/constants.dart';

class Homepage extends GetView<HomeController> {
  Homepage({super.key});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    controller.getNews();
   // controller.getAppointments();
    return Stack(
      children: [
        Column(
          children: [
            _buildSearchAndFilterRow(screenSize),
            SizedBox(height: screenSize.height * 0.03),
            _buildCarousel(screenSize),
            SizedBox(height: screenSize.height * 0.03),
            const Text('المواعيد القادمة',style: TextStyle(fontSize: 20)),
            // _buildAppointmentList(controller,screenSize),
            SizedBox(height: screenSize.height * 0.1),

          ],
        ),
        _buildFilterCard(screenSize),
      ],
    );
  }

  Widget _buildSearchAndFilterRow(Size screenSize) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          _buildFilterButton(screenSize),
          SizedBox(width: screenSize.width * 0.05),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintTextDirection: TextDirection.rtl,
                hintText: 'إبحث',
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

  // Widget _buildAppointmentList(HomeController controller, Size screenSize) {
  //   return Obx(() {
  //     if (controller.isLoadingA.value) {
  //       return Center(child: CircularProgressIndicator());
  //     }
  //
  //     final filteredAppointments = controller.appointments
  //         .where((appointment) =>
  //     appointment.status != 'canceled' && appointment.status != 'completed')
  //         .toList()
  //       ..sort((a, b) {
  //         final dateTimeA = DateTime.parse('${a.date} ${a.time}');
  //         final dateTimeB = DateTime.parse('${b.date} ${b.time}');
  //         return dateTimeA.compareTo(dateTimeB);
  //       });
  //
  //     if (filteredAppointments.isEmpty) {
  //       return Center(child: Text('لا توجد مواعيد قادمة.'));
  //     }
  //
  //     return Expanded(
  //       child: ListView.builder(
  //         itemCount: filteredAppointments.length,
  //         itemBuilder: (context, index) {
  //           return _buildAppointmentCard(filteredAppointments[index], screenSize);
  //         },
  //       ),
  //     );
  //   });
  // }
  //
  // Widget _buildAppointmentCard(Appointment appointment, Size screenSize) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //       horizontal: screenSize.width * 0.02,
  //       vertical: screenSize.height * 0.005,
  //     ),
  //     child: Card(
  //       color: Color(-789517),
  //       elevation: 6,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.end,
  //         children: [
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(screenSize.width * 0.02),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: [
  //                   // اسم الطبيب
  //                   Text(
  //                     appointment.doctorName,
  //                     style: TextStyle(
  //                       fontSize: screenSize.height * 0.02,
  //                     ),
  //                   ),
  //                   SizedBox(height: screenSize.height * 0.005),
  //                   // اسم العيادة
  //                   Text(
  //                     appointment.clinicName,
  //                     style: TextStyle(
  //                       color: const Color(-7763575),
  //                       fontSize: screenSize.height * 0.02,
  //                     ),
  //                   ),
  //                   SizedBox(height: screenSize.height * 0.005),
  //                   // التاريخ والوقت
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       Text(
  //                         '${appointment.date} - ${appointment.time}',
  //                         style: TextStyle(
  //                           color: const Color(-13280354),
  //                           fontSize: screenSize.height * 0.017,
  //                         ),
  //                       ),
  //                       SizedBox(width: screenSize.width * 0.005),
  //                       Icon(
  //                         Icons.access_time_filled,
  //                         color: Color(-13280354),
  //                         size: screenSize.height * 0.025,
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //           if (appointment.image != null)
  //             Padding(
  //               padding: const EdgeInsets.all(8.0),
  //               child: MyImageNet(
  //                 path: '${AppConstants.baseURLPhoto}storage/${appointment.image}',
  //                 sizeh: screenSize.height,
  //               ),
  //             )
  //           else
  //             Image.asset('assets/doctor_placeholder.jpg'),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildFilterCard(Size screenSize) {
    return GetBuilder<Filtercontroller>(
      builder: (controller) => AnimatedPositioned(
        duration: const Duration(milliseconds: 300),
        right: screenSize.width * 0.04,
        top: controller.isenable ? screenSize.height * 0.09 : 0.09,
        child: AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubicEmphasized,
          child: controller.isenable
              ? SizedBox(
            width: screenSize.width * 0.75,
            height: screenSize.height * 0.06,
            child: Card(
              color: const Color(-789517),
              elevation: 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFilterDropdown(screenSize, "التخصص", controller.selectedOption2,
                          (value) => controller.changevalueofoption1(value)),
                  _buildFilterDropdown(screenSize, "المحافظة", controller.selectedOption2,
                          (value) => controller.changevalueofoption2(value)),
                ],
              ),
            ),
          )
              : const SizedBox(),
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(Size screenSize, String hintText, int? selectedOption, Function(int?) onChanged) {
    return Padding(
      padding: EdgeInsets.all(screenSize.height * 0.008),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.04),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedOption,
              hint: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_drop_down, color: Colors.black),
                  Text(
                    hintText,
                    style: TextStyle(fontSize: screenSize.height * 0.018, color: Colors.grey[700]),
                  ),
                ],
              ),
              icon: const SizedBox.shrink(),
              items: controller.options.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text(
                    option,
                    style: TextStyle(fontSize: screenSize.height * 0.018, color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}