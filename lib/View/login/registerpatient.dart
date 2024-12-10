import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';

class RegFormP extends StatefulWidget {
  const RegFormP();

  @override
  _RegFormPState createState() => _RegFormPState();
}

class _RegFormPState extends State<RegFormP> {

  int? selectedDay;
  String? selectedMonth;
  int? selectedYear;
  String? selectedGender;
  String? selectedBloodType;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final DraggableScrollableController _controller = DraggableScrollableController();

  List<int> days = List<int>.generate(31, (index) => index + 1);
  List<String> months = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو',
    'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  final List<String> bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];
  List<int> years = List<int>.generate(100, (index) => DateTime.now().year - index);

  int calculateAge(int year, String month, int day) {
    return DateTime.now().year - year;
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال الاسم كاملاً');
      return;
    }

    if (emailController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال البريد الإلكتروني');
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

    if (passwordController.text.length < 8) {
      Get.snackbar('خطأ', 'كلمة المرور يجب أن تكون 8 أحرف على الأقل');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('خطأ', 'كلمة المرور غير متطابقة');
      return;
    }

    if (selectedDay == null || selectedMonth == null || selectedYear == null) {
      Get.snackbar('خطأ', 'يرجى اختيار تاريخ الميلاد');
      return;
    }

    final age = calculateAge(selectedYear!, selectedMonth!, selectedDay!);
    if (age < 13) {
      Get.snackbar('خطأ', 'يجب أن يكون عمرك 13 سنة على الأقل');
      return;
    }

    if (selectedGender == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الجنس');
      return;
    }

    if (selectedBloodType == null) {
      Get.snackbar('خطأ', 'يرجى اختيار فصيلة الدم');
      return;
    }

    setState(() => isLoading = true);
    try {
      final userData = {
        'name': '${firstNameController.text} ${lastNameController.text}',
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
        'address': addressController.text,
        'phone': '1234567890',
        'age': calculateAge(selectedYear!, selectedMonth!, selectedDay!),
        'gender': selectedGender == 'ذكر' ? 'male' : 'female',
        'blood_type': selectedBloodType,
        'medical_history': 'No major issues',
        'medical_recommendations': 'Regular checkups',
        'current_medications': 'None',
        'allergies': 'None',
      };

      final authController = Get.find<AuthController>();
      await authController.createPatient(userData);
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء تسجيل الحساب: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      setState(() => isLoading = false);
    }
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
            color: const Color(-15904640),
            height: screenSize.height * 0.238,
          ),
          SvgPicture.asset(
            'assets/circle1.svg',
            color: const Color(-15971464),
            height: screenSize.height * 0.2,
          ),
          Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.035, top: screenSize.height * 0.035),
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
                    style: TextStyle(fontSize: screenSize.height * 0.04, color: Colors.white),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: screenSize.height * 0.01),
                        const Center(
                          child: SizedBox(
                            width: 50,
                            child: Divider(thickness: 5),
                          ),
                        ),
                        SizedBox(height: screenSize.height * 0.01),
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.all(screenSize.height * 0.01),
                            children: [
                          
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topRight,
                                          child: Text(
                                            'الاسم الثاني',
                                            style: TextStyle(fontSize: screenSize.height* 0.02, color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        Container(
                                          height: screenSize.height * 0.05,
                                          child: TextField(
                                            textAlign: TextAlign.end,
                                            controller: lastNameController,
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
                                            style: TextStyle(fontSize: screenSize.height* 0.02, color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        Container(
                                          height: screenSize.height * 0.05,
                                          child: TextField(
                                            textAlign: TextAlign.end,
                                            controller: firstNameController,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            )
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
                                          style: TextStyle(fontSize: screenSize.height* 0.02, color: Colors.black),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: selectedYear,
                                            hint: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'اختر سنة',
                                                style: TextStyle(fontSize: screenSize.width * 0.045),
                                              ),
                                            ),
                                            isExpanded: true,
                                            items: years.map((year) {
                                              return DropdownMenuItem<int>(
                                                alignment: AlignmentDirectional.center,
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
                                          style: TextStyle(fontSize: screenSize.height* 0.02, color: Colors.black),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            value: selectedMonth,
                                            hint: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'اختر الشهر',
                                                style: TextStyle(fontSize: screenSize.width * 0.045),
                                              ),
                                            ),
                                            isExpanded: true,
                                            items: months.map((month) {
                                              return DropdownMenuItem<String>(
                                                alignment: AlignmentDirectional.center,
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
                                          style: TextStyle(fontSize: screenSize.height* 0.02, color: Colors.black),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: selectedDay,
                                            hint: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                'اختر اليوم',
                                                style: TextStyle(fontSize: screenSize.width * 0.045),
                                              ),
                                            ),
                                            isExpanded: true,
                                            items: days.map((day) {
                                              return DropdownMenuItem<int>(
                                                alignment: AlignmentDirectional.center,
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Blood Type Dropdown
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'فصيلة الدم',
                                          style: TextStyle(fontSize: screenSize.height* 0.02),
                                        ),
                                        SizedBox(height: screenSize.height * 0.01),
                                        Container(
                                          height: screenSize.height * 0.05,
                                          decoration: BoxDecoration(
                                            border: Border.all(color: Colors.grey),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: selectedBloodType,
                                              hint: Align(
                                                alignment: Alignment.centerRight,
                                                child: Text(
                                                  'إختر فصيلة الدم',
                                                  style: TextStyle(fontSize: screenSize.width * 0.045),
                                                ),
                                              ),
                                              isExpanded: true,
                                              items: bloodTypes.map((type) => DropdownMenuItem(
                                                alignment: AlignmentDirectional.center,
                                                value: type,
                                                child: Text(type),
                                              )).toList(),
                                              onChanged: (value) => setState(() => selectedBloodType = value),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: screenSize.width * 0.05),
                                  // Gender Selection
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'الجنس',
                                          style: TextStyle(fontSize: screenSize.height* 0.02),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                Text('أنثى'),
                                                Radio<String>(
                                                  value: 'أنثى',
                                                  groupValue: selectedGender,
                                                  onChanged: (value) => setState(() => selectedGender = value),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text('ذكر'),
                                                Radio<String>(
                                                  value: 'ذكر',
                                                  groupValue: selectedGender,
                                                  onChanged: (value) => setState(() => selectedGender = value),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenSize.height * 0.02),
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'العنوان',
                                  style: TextStyle(fontSize: screenSize.height* 0.02),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.01),
                              Container(
                                height: screenSize.height * 0.05,
                                child: TextField(textAlign: TextAlign.end,
                                  controller: addressController,
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
                                  'البريد الالكتروني',
                                  style: TextStyle(fontSize: screenSize.height* 0.02),
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
                                  style: TextStyle(fontSize: screenSize.height* 0.02),
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
                              Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  'تاكيد كلمة المرور',
                                  style: TextStyle(fontSize: screenSize.height* 0.02),
                                ),
                              ),
                              SizedBox(height: screenSize.height * 0.01),
                              Container(
                                height: screenSize.height * 0.05,
                                child: TextField(
                                  controller: confirmPasswordController,
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
                                  onPressed: isLoading ? null : register,
                                  child: isLoading
                                      ? CircularProgressIndicator(color: Colors.white)
                                      : Text(
                                    'انشاء حساب',
                                    style: TextStyle(fontSize: screenSize.height* 0.02, color: Colors.white),
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
                        ),
                      ],
                    ),
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}