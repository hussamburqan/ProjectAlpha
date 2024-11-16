import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/component/MyImage.dart';
import 'package:projectalpha/controller/filtercontroller.dart';

// ignore: must_be_immutable
class Homepage extends StatelessWidget {
  Homepage({super.key});

  List<Map<String, String>> appointments = [
    {
      'name': 'د.احمد العربي',
      'clinic': 'Middle East Heart Clinic',
      'date': '22/10/2024 الثلاثاء 10 صباحاً',
      'image': 'assets/doctor1.png',
    },
    {
      'name': 'د.صفاء الحربي',
      'clinic': 'The Golden Dentists',
      'date': '23/10/2024 الثلاثاء 2 مساءً',
      'image': 'assets/doctor2.png',
    },
  ];


  @override
  Widget build(BuildContext context) {
        final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    AnimatedContainer(
                      width: screenSize.height * 0.06,
                      height: screenSize.height * 0.06,
                      duration: const Duration(),
                      child: GetBuilder<Filtercontroller>(
                        builder: (controller)=> ElevatedButton(
                        style: ButtonStyle(
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          backgroundColor:
                          WidgetStateProperty.all(controller.isenable ? Colors.white : Color(-15441250)),
                          padding: WidgetStateProperty.all(EdgeInsets.zero),
                        ),
                        child: Image.asset(
                          color: controller.isenable ? const Color(-15441250) : Colors.white,
                          "assets/filter.png",
                          height: screenSize.width * 0.06,
                          width: screenSize.width * 0.06,
                          fit: BoxFit.fill,
                        ),
                        onPressed: () {
                            controller.changeEnable();
                        },
                      ),
                      ),
                    ),
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
              ),
              SizedBox(height: screenSize.height * 0.03),
              CarouselSlider(
                items: const [
                  MyImage(path: 'assets/test1.png'),
                  MyImage(path: 'assets/test1.png'),
                  MyImage(path: 'assets/test1.png')
                ],
                disableGesture: true,
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
              ),
              SizedBox(height: screenSize.height * 0.03),
              Padding(
                padding: EdgeInsets.only(
                    right: screenSize.width * 0.06,
                    left: screenSize.width * 0.06
                ),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "المواعيد القادمة",
                    style: TextStyle(fontSize: screenSize.height * 0.021, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.01),
              Expanded(
                child: ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = appointments[index];
                    return Padding(
                      padding: EdgeInsets.only(
                          left: screenSize.width * 0.02,
                          right: screenSize.width * 0.02,
                          top: screenSize.height * 0.005,
                          bottom: screenSize.height * 0.005
                      ),
                      child: Card(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  appointment['name']!,
                                  style: TextStyle(color: Colors.black, fontSize: screenSize.height * 0.02),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: screenSize.height * 0.005),
                                Text(
                                  appointment['clinic']!,
                                  style: TextStyle(color: const Color(-7763575),fontSize: screenSize.height * 0.02),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: screenSize.height * 0.005),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      appointment['date']!,
                                      style: TextStyle(color: const Color(-13280354),fontSize: screenSize.height * 0.017),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    SizedBox(width: screenSize.width * 0.005),
                                    Icon(
                                      Icons.access_time_filled,
                                      color: const Color(-13280354),
                                      size: screenSize.height * 0.016,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                appointment['image']!,
                                height: screenSize.height * 0.1,
                                width: screenSize.height * 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          GetBuilder<Filtercontroller>(builder: (controller) =>           AnimatedPositioned(
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
                      Padding(
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
                                value: controller.selectedOption1,
                                hint: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                                    Text(
                                      "التخصص",
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
                                onChanged: (value) {
                                  
                                    controller.changevalueofoption1(value);
                              
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(screenSize.height * 0.008),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(color: Colors.black, width: 0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.06),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                value: controller.selectedOption2,
                                hint: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Icon(Icons.arrow_drop_down, color: Colors.black),
                                    Text(
                                      "المحافظة",
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
                                onChanged: (value) {
                                  controller.changevalueofoption2(value);
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox(),
            ),
          )
          )
        ]
    );
  }
}