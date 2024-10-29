import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';



class RegForm extends StatefulWidget {
  const RegForm();

  @override
  _RegFormState createState() => _RegFormState();
}

class _RegFormState extends State<RegForm> {
  int? selectedDay;
  String? selectedMonth;
  int? selectedYear;
  String? selectedGender;

  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    List<int> days = List<int>.generate(31, (index) => index + 1);
    List<String> months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو',
      'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    List<int> years = List<int>.generate(100, (index) => DateTime.now().year - index);


    return Scaffold(
      backgroundColor: Color(-15702880),
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
                SizedBox(height: screenSize.height * 0.11 ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'قم بإنشاء حساب',
                    style: TextStyle(fontSize: screenSize.width * 0.07, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          DraggableScrollableSheet(
              controller: _controller,
              initialChildSize: 0.83,
              minChildSize: 0.83,
              maxChildSize: 0.83,

              builder: (BuildContext context, ScrollController scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(screenSize.width * 0.05),
                    children: [
                      const Center(
                        child: SizedBox(
                          width: 50,
                          child: Divider(thickness: 5),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),


                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'الاسم الثاني',
                                    style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                Container(
                                  height: screenSize.height * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.05),
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'الاسم الاول',
                                    style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                Container(
                                  height: screenSize.height * 0.05,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'السنة',
                                  style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: selectedYear,
                                    hint: Text('اختر سنة'),
                                    isExpanded: true,
                                    items: years.map((year) {
                                      return DropdownMenuItem<int>(
                                        value: year,
                                        child: Text(year.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedYear = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'الشهر',
                                  style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedMonth,
                                    hint: Text('اختر شهر'),
                                    isExpanded: true,
                                    items: months.map((month) {
                                      return DropdownMenuItem<String>(
                                        value: month,
                                        child: Text(month),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedMonth = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.05),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'اليوم',
                                  style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: selectedDay,
                                    hint: Text('اختر يوم'),
                                    isExpanded: true,
                                    items: days.map((day) {
                                      return DropdownMenuItem<int>(
                                        value: day,
                                        child: Text(day.toString()),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedDay = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenSize.height * 0.02),
                      Align(alignment: Alignment.topRight,
                        child: Text(
                          'الجنس',
                          style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.black),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [

                              Text('أنثى', style: TextStyle(fontSize: screenSize.width * 0.045)),
                              Radio<String>(
                                value: 'أنثى',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [

                              Text('ذكر', style: TextStyle(fontSize: screenSize.width * 0.045)),
                              Radio<String>(
                                value: 'ذكر',
                                groupValue: selectedGender,
                                onChanged: (value) {
                                  setState(() {
                                    selectedGender = value;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'البريد الالكتروني',
                          style: TextStyle(fontSize: screenSize.width * 0.045),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Container(
                        height: screenSize.height * 0.05,
                        child: TextField(
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
                          obscureText: true,
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
                          'تاكيد كلمة المرور',
                          style: TextStyle(fontSize: screenSize.width * 0.045),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Container(
                        height: screenSize.height * 0.05,
                        child: TextField(
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
                          onPressed: () {},
                          child: Text(
                            'انشاء حساب',
                            style: TextStyle(fontSize: screenSize.width * 0.045, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}