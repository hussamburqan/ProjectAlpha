import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/DoctorController.dart';
import 'package:projectalpha/Controller/authcontroller.dart';

class DoctorProfilePage extends StatelessWidget {
  final DoctorController doctorController = Get.put(DoctorController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final doctorId = controller.getDoctorId();
    doctorController.fetchDoctorData(doctorId!);

    return Scaffold(
      backgroundColor: Color(-789517),
      appBar: AppBar(
        backgroundColor: Color(-15441249),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text('الملف الشخصي للطبيب',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: Icon(Icons.edit,color: Colors.white,),
            onPressed: () {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                final doctor = doctorController.doctorData.value;
                if (doctor != null) {
                  Get.to(() => DoctorEditProfilePage(), arguments: doctor);
                }
              });
            },
          ),
        ],
      ),
      body: Obx(() {
        if (doctorController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (doctorController.doctorData.value == null) {
          return Center(child: Text('لم يتم العثور على بيانات الطبيب.'));
        }

        final doctor = doctorController.doctorData.value!;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('المعلومات الشخصية', [
                _buildInfoRow('الاسم', doctor.name),
                _buildInfoRow('البريد الإلكتروني', doctor.email),
                _buildInfoRow('الهاتف', doctor.phone),
                _buildInfoRow('العنوان', doctor.address),
                _buildInfoRow('التخصص', doctor.specialization),
              ]),
              SizedBox(height: 16),
              _buildInfoCard('المعلومات المهنية', [
                _buildInfoRow('سنوات الخبرة', '${doctor.experienceYears} سنوات'),
                _buildInfoRow('التعليم', doctor.education),
                _buildInfoRow('وقت بدء العمل', doctor.startWorkTime),
                _buildInfoRow('وقت انتهاء العمل', doctor.endWorkTime),
                _buildInfoRow('مدة الحجز الافتراضية', '${doctor.defaultTimeReservations} دقيقة'),
              ]),
              SizedBox(height: 16),
              _buildInfoCard('نبذة عن الطبيب', [
                Text(doctor.bio),
              ]),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
 }

class DoctorEditProfilePage extends StatefulWidget {
  DoctorEditProfilePage();

  @override
  _DoctorEditProfilePageState createState() => _DoctorEditProfilePageState();
}

class _DoctorEditProfilePageState extends State<DoctorEditProfilePage> {
  final DoctorController doctorController = Get.find();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController specializationController;
  late TextEditingController experienceYearsController;
  late TextEditingController educationController;
  late TextEditingController startWorkTimeController;
  late TextEditingController endWorkTimeController;
  late TextEditingController defaultTimeReservationsController;
  late TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    final doctor = Get.arguments;
    if (doctor != null) {
      nameController = TextEditingController(text: doctor.name);
      emailController = TextEditingController(text: doctor.email);
      phoneController = TextEditingController(text: doctor.phone);
      addressController = TextEditingController(text: doctor.address);
      specializationController = TextEditingController(text: doctor.specialization);
      experienceYearsController = TextEditingController(text: doctor.experienceYears.toString());
      educationController = TextEditingController(text: doctor.education);
      startWorkTimeController = TextEditingController(text:  doctor.startWorkTime.substring(0, 5));

      endWorkTimeController = TextEditingController(text: doctor.endWorkTime.substring(0, 5));
      defaultTimeReservationsController = TextEditingController(text: doctor.defaultTimeReservations.toString());
      bioController = TextEditingController(text: doctor.bio);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (!isLoading) {
      nameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      addressController.dispose();
      specializationController.dispose();
      experienceYearsController.dispose();
      educationController.dispose();
      startWorkTimeController.dispose();
      endWorkTimeController.dispose();
      defaultTimeReservationsController.dispose();
      bioController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(-789517),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: Text('تعديل الملف الشخصي',style: TextStyle(color: Colors.white),),
        backgroundColor: Color(-15441249),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTextField('الاسم', nameController),
              _buildTextField('البريد الإلكتروني', emailController),
              _buildTextField('الهاتف', phoneController),
              _buildTextField('العنوان', addressController),
              _buildTextField('التخصص', specializationController),
              _buildTextField('سنوات الخبرة', experienceYearsController,
                  keyboardType: TextInputType.number),
              _buildTextField('التعليم', educationController),
              _buildTextField('وقت بدء العمل', startWorkTimeController),
              _buildTextField('وقت انتهاء العمل', endWorkTimeController),
              _buildTextField(
                'مدة الحجز الافتراضية (بالدقائق)',
                defaultTimeReservationsController,
                keyboardType: TextInputType.number,
              ),
              _buildTextField('نبذة عن الطبيب', bioController,
                  maxLines: 5),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('حفظ التغييرات',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(-15441249),
                  padding: EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16),
                  textStyle: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType? keyboardType}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(-15441249), width: 2),
          ),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authController = Get.find<AuthController>();
        final doctorId = authController.getDoctorId();

        if (doctorId == null) {
          throw Exception('لم يتم العثور على معرف الطبيب');
        }

        final updatedData = {
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'specialization': specializationController.text,
          'experience_years': int.parse(experienceYearsController.text),
          'education': educationController.text,
          'start_work_time': startWorkTimeController.text,
          'end_work_time': endWorkTimeController.text,
          'default_time_reservations':
          int.parse(defaultTimeReservationsController.text),
          'bio': bioController.text,
        };

        await doctorController.updateDoctorData(doctorId, updatedData);

      } catch (e) {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء تحديث البيانات',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }
}


