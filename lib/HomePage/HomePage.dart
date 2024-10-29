import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:projectalpha/HomePage/MyImage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int i = 1;
  int? _selectedOption1;
  int? _selectedOption2;
  bool filterOn = false ;
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

  List<String> options = ['1', '2', '3'];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(-15703137),
        title: const Text(
          "الصفحة الرئيسية",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color(-657931),
      body: Stack(
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
                      duration: Duration(),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          backgroundColor:
                          MaterialStateProperty.all(filterOn ? Colors.white : Color(-15441250)),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                        ),
                        child: Image.asset(
                          color: filterOn ? Color(-15441250) : Colors.white,
                          "assets/filter.png",
                          height: screenSize.width * 0.06,
                          width: screenSize.width * 0.06,
                          fit: BoxFit.fill,
                        ),
                        onPressed: () {
                          setState(() {
                            filterOn = !filterOn;
                          });
                        },
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
                items: [
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
                                  style: TextStyle(color: Color(-7763575),fontSize: screenSize.height * 0.02),
                                  textDirection: TextDirection.rtl,
                                ),
                                SizedBox(height: screenSize.height * 0.005),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      appointment['date']!,
                                      style: TextStyle(color: Color(-13280354),fontSize: screenSize.height * 0.017),
                                      textDirection: TextDirection.rtl,
                                    ),
                                    SizedBox(width: screenSize.width * 0.005),
                                    Icon(
                                      Icons.access_time_filled,
                                      color: Color(-13280354),
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            right: screenSize.width * 0.04,
            top: filterOn ? screenSize.height * 0.09 : 0.09,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubicEmphasized,
              child: filterOn
                  ? Container(
                width: screenSize.width * 0.75,
                height: screenSize.height * 0.06,
                child: Card(
                  color: Color(-789517),
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
                                value: _selectedOption1,
                                hint: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.arrow_drop_down, color: Colors.black),
                                    Text(
                                      "التخصص",
                                      style: TextStyle(fontSize: screenSize.height * 0.018, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                                icon: SizedBox.shrink(),
                                items: options.asMap().entries.map((entry) {
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
                                  setState(() {
                                    _selectedOption1 = value;
                                  });
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
                                value: _selectedOption2,
                                hint: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.arrow_drop_down, color: Colors.black),
                                    Text(
                                      "المحافظة",
                                      style: TextStyle(fontSize: screenSize.height * 0.018, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                                icon: SizedBox.shrink(),
                                items: options.asMap().entries.map((entry) {
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
                                  setState(() {
                                    _selectedOption2 = value;
                                  });
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
                  : SizedBox(),
            ),
          ),


          Align(
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
                    NavItem(0, "assets/home.png"),
                    SizedBox(width: screenSize.width * 0.05),
                    NavItem(1, "assets/Notices.png"),
                    SizedBox(width: screenSize.width * 0.05),
                    NavItem(2, "assets/something.png"),
                    SizedBox(width: screenSize.width * 0.05),
                    NavItem(3, "assets/setting.png"),
                    SizedBox(width: screenSize.width * 0.05),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector NavItem(int index, String assetPath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          i = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.height * 0.06,
        decoration: BoxDecoration(
          color: i == index ? Color(-15703137) : Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset(
            assetPath,
            scale: 4,
            color: i == index ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}
