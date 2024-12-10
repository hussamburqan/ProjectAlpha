import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:projectalpha/Controller/doctor_register_controller.dart';

class DoctorRegisterPage extends StatefulWidget {
  const DoctorRegisterPage({Key? key}) : super(key: key);

  @override
  _DoctorRegisterPageState createState() => _DoctorRegisterPageState();
}

class _DoctorRegisterPageState extends State<DoctorRegisterPage> {
  final controller = Get.put(DoctorRegisterController());
  final _formKey = GlobalKey<FormState>();
  final DraggableScrollableController _controller = DraggableScrollableController();
  TimeOfDay? startWorkTime;
  TimeOfDay? endWorkTime;
  TextEditingController defaultTimeReservationsController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final experienceYearsController = TextEditingController();
  final specializationController = TextEditingController();
  final educationController = TextEditingController();
  final bioController = TextEditingController();

  String? selectedGender;
  int? selectedMajor;
  int? selectedClinic;
  String? photoPath;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startWorkTime = picked;
        } else {
          endWorkTime = picked;
        }
      });
    }
  }

  String convertTo24Hour(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          photoPath = image.path;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصورة',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

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

    if (phoneController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال رقم الهاتف');
      return;
    }
    if (phoneController.text.length >10) {
      Get.snackbar('خطأ', 'يجب ان يتكون رقم الهاتف من عشر ارقام');
      return;
    }

    if (addressController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال العنوان');
      return;
    }

    if (startWorkTime != null && endWorkTime != null) {
      String startTime = convertTo24Hour(startWorkTime!);
      String endTime = convertTo24Hour(endWorkTime!);

      if (startTime.compareTo(endTime) >= 0) {
        Get.snackbar('خطأ', 'وقت بدء العمل يجب أن يكون قبل وقت النهاية');
        return;
      }
    }

    if (experienceYearsController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال سنوات الخبرة');
      return;
    }
    final experienceYears = int.tryParse(experienceYearsController.text);
    if (experienceYears == null || experienceYears < 0 || experienceYears > 50) {
      Get.snackbar('خطأ', 'يرجى إدخال عدد سنوات خبرة صحيح');
      return;
    }

    if (specializationController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال التخصص');
      return;
    }

    if (educationController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال المؤهلات العلمية');
      return;
    }

    if (bioController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال نبذة عن الطبيب');
      return;
    }

    if (selectedMajor == null) {
      Get.snackbar('خطأ', 'يرجى اختيار التخصص');
      return;
    }

    if (selectedClinic == null) {
      Get.snackbar('خطأ', 'يرجى اختيار العيادة');
      return;
    }

    if (selectedGender == null) {
      Get.snackbar('خطأ', 'يرجى اختيار الجنس');
      return;
    }

    if (startWorkTime == null || endWorkTime == null) {
      Get.snackbar('خطأ', 'يرجى تحديد أوقات العمل');
      return;
    }

    if (defaultTimeReservationsController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى تحديد مدة الحجز الافتراضية');
      return;
    }

    int defaultTimeReservations = int.tryParse(defaultTimeReservationsController.text) ?? 0;
    if (defaultTimeReservations < 15 || defaultTimeReservations > 120) {
      Get.snackbar('خطأ', 'مدة الحجز يجب أن تكون بين 15 و 120 دقيقة');
      return;
    }

    if (photoPath == null) {
      Get.snackbar('خطأ', 'يرجى اختيار صورة');
      return;
    }

    String formatTimeToString(TimeOfDay time) {
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    }

    final formattedStartTime = formatTimeToString(startWorkTime!);
    final formattedEndTime = formatTimeToString(endWorkTime!);

    await controller.registerDoctor(
      formDataMap: {
        'name': "${firstNameController.text} ${lastNameController.text}",
        'email': emailController.text,
        'password': passwordController.text,
        'password_confirmation': passwordController.text,
        'address': addressController.text,
        'phone': phoneController.text,
        'age': 30,
        'gender': selectedGender == 'ذكر' ? 'male' : 'female',
        'experience_years': experienceYears!,
        'specialization': specializationController.text,
        'education': educationController.text,
        'bio': bioController.text,
        'major_id': selectedMajor!,
        'nclinic_id': selectedClinic!,
        'start_work_time': formattedStartTime,
        'end_work_time': formattedEndTime,
        'default_time_reservations': defaultTimeReservations,
      },
      photoPath: photoPath!,
    );

  }

  String formatTimeToAMPM(String? timeString) {
    if (timeString == null || timeString.isEmpty) return '';

    try {
      final timeParts = timeString.split(':');
      if (timeParts.length < 2) return '';

      int hours = int.parse(timeParts[0]);
      final minutes = timeParts[1];

      final period = hours >= 12 ? 'PM' : 'AM';
      hours = hours > 12 ? hours - 12 : hours;
      hours = hours == 0 ? 12 : hours;

      return '$hours:$minutes $period';
    } catch (e) {
      return '';
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
                SizedBox(height: screenSize.height * 0.11),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    'تسجيل طبيب جديد',
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
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    controller: scrollController,
                    children: [
                      // Basic Information
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'الاسم الثاني',
                                    style: TextStyle(fontSize: screenSize.height * 0.02),
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
                                    style: TextStyle(fontSize: screenSize.height * 0.02),
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
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: screenSize.height * 0.02),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'الجنس',
                            style: TextStyle(fontSize: screenSize.height * 0.02),
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

                      SizedBox(height: screenSize.height * 0.02),
                      Text(
                        'المعلومات المهنية',
                        style: TextStyle(fontSize: screenSize.height * 0.025, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenSize.height * 0.02),

                      Obx(() {
                        return Column(
                          children: [
                            DropdownButtonFormField<int>(
                              value: selectedMajor,
                              decoration: InputDecoration(
                                labelText: 'التخصص الرئيسي',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: [
                                DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('اختر التخصص'),
                                ),
                                ...controller.majors.map((major) => DropdownMenuItem(
                                  value: major['id'] as int,
                                  child: Text(major['name'] as String),
                                )).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedMajor = value;
                                });
                              },
                              validator: (value) => value == null ? 'يرجى اختيار التخصص' : null,
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            DropdownButtonFormField<int>(
                              value: selectedClinic,
                              decoration: InputDecoration(
                                labelText: 'العيادة',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              items: [
                                DropdownMenuItem<int>(
                                  value: null,
                                  child: Text('اختر العيادة'),
                                ),
                                ...controller.clinics.map((clinic) => DropdownMenuItem(
                                  value: clinic['id'] as int,
                                  child: Text(clinic['name'] as String),
                                )).toList(),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  selectedClinic = value;
                                  if (value != null) {
                                    controller.updateSelectedClinicWorkHours(value);
                                  }
                                });
                              },
                              validator: (value) => value == null ? 'يرجى اختيار العيادة' : null,
                            ),
                          ],
                        );
                      }),
                      SizedBox(height: screenSize.height * 0.02),
                      Align(alignment: Alignment.centerRight,
                        child: Text(
                          'يجب ان يكون وقت العمل من ضمن اوقات العيادة',
                          style: TextStyle(fontSize: screenSize.height * 0.018),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${formatTimeToAMPM(controller.selectedClinicWorkHours.value['closing_time'])}',
                            style: TextStyle(fontSize: screenSize.height * 0.018),
                          ),

                          Text(
                            ' الى ',
                            style: TextStyle(fontSize: screenSize.height * 0.018),
                          ),
                          Text(
                            '${formatTimeToAMPM(controller.selectedClinicWorkHours.value['opening_time'])}',
                            style: TextStyle(fontSize: screenSize.height * 0.018),
                          ),
                         Text(' اوقات عمل العيادة من ',
                            style: TextStyle(fontSize: screenSize.height * 0.018),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Row(
                        children: [

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [


                                Text(
                                  'وقت نهاية العمل',
                                  style: TextStyle(fontSize: screenSize.height * 0.02),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                InkWell(
                                  onTap: () => _selectTime(context, false),
                                  child: Container(
                                    height: screenSize.height * 0.05,
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          endWorkTime?.format(context) ?? 'اختر الوقت',
                                          style: TextStyle(fontSize: screenSize.height * 0.02),
                                        ),
                                        Icon(Icons.access_time),
                                      ],
                                    ),
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
                                  'وقت بدء العمل',
                                  style: TextStyle(fontSize: screenSize.height * 0.02),
                                ),
                                SizedBox(height: screenSize.height * 0.01),
                                InkWell(
                                  onTap: () => _selectTime(context, true),
                                  child: Container(
                                    height: screenSize.height * 0.05,
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          startWorkTime?.format(context) ?? 'اختر الوقت',
                                          style: TextStyle(fontSize: screenSize.height * 0.02),
                                        ),
                                        Icon(Icons.access_time),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

// مدة الحجز الافتراضية
                      SizedBox(height: screenSize.height * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'مدة الحجز الافتراضية (بالدقائق)',
                            style: TextStyle(fontSize: screenSize.height * 0.02),
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          Container(
                            height: screenSize.height * 0.05,
                            child: TextField(
                              controller: defaultTimeReservationsController,
                              textAlign: TextAlign.end,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'مثال: 30',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      buildTextField(experienceYearsController, 'سنوات الخبرة', screenSize),
                      buildTextField(specializationController, 'التخصص الدقيق', screenSize),
                      buildTextField(educationController, 'المؤهلات العلمية', screenSize),
                      buildTextField(bioController, 'نبذة عن الطبيب', screenSize, maxLines: 3),
                      buildTextField(addressController, 'العنوان', screenSize),
                      buildTextField(phoneController, 'الهاتف', screenSize),
                      buildTextField(emailController, 'البريد الالكتروني', screenSize),
                      buildTextField(passwordController, 'كلمة المرور', screenSize, isPassword: true),
                      buildTextField(confirmPasswordController, 'تأكيد كلمة المرور', screenSize, isPassword: true),

                      // Photo Selection
                      SizedBox(height: screenSize.height * 0.02),
                      InkWell(
                        onTap: pickImage,
                        child: Container(
                          height: screenSize.height * 0.2,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: photoPath != null
                              ? Image.file(File(photoPath!))
                              : Center(child: Text('اختر صورة')),
                        ),
                      ),

                      // Submit Button
                      SizedBox(height: screenSize.height * 0.02),
                      SizedBox(
                        width: double.infinity,
                        child: Obx(() => ElevatedButton(
                          onPressed: controller.isLoading.value ? null : register,
                          child: controller.isLoading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            'تسجيل',
                            style: TextStyle(fontSize: screenSize.height * 0.02, color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(15),
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label, Size screenSize,
      {bool isPassword = false, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: screenSize.height * 0.02),
        Text(
          label,
          style: TextStyle(fontSize: screenSize.height * 0.02),
        ),
        SizedBox(height: screenSize.height * 0.01),
        Container(
          height: maxLines == 1 ? screenSize.height * 0.05 : screenSize.height * 0.1,
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            maxLines: maxLines,
            textAlign: TextAlign.end,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}