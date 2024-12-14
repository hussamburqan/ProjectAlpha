import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/authcontroller.dart';
import 'package:projectalpha/Controller/patient_controller.dart';

class PatientProfilePage extends StatelessWidget {
  final PatientController patientController = Get.put(PatientController());

  PatientProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    final patientId = controller.getPatientId();

    if (patientId == null) {
      return Scaffold(
        backgroundColor: Color(-7763575),
        appBar: AppBar(
          backgroundColor: Color(-15441249),
          centerTitle: true,
          title: Text('الملف الشخصي للمريض'),
        ),
        body: Center(child: Text('لم يتم العثور على معرف المريض.')),
      );
    }

    patientController.fetchPatientData(patientId);

    return Scaffold(
      backgroundColor: Color(-789517),
      appBar: AppBar(
        backgroundColor: Color(-15441249),
        centerTitle: true,
        title: Text('الملف الشخصي للمريض',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit,color: Colors.white),
            onPressed: () => Get.to(() => UpdatePatientPage(patientController: patientController)),
          ),
        ],
      ),
      body: Obx(() {
        if (patientController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (patientController.patientData.isEmpty) {
          return Center(child: Text('لم يتم العثور على بيانات المريض.'));
        }

        final patient = patientController.patientData;

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard('المعلومات الشخصية', [
                _buildInfoRow('الاسم', patient['user']['name']),
                _buildInfoRow('البريد الإلكتروني', patient['user']['email']),
                _buildInfoRow('الهاتف', patient['user']['phone']),
                _buildInfoRow('العنوان', patient['user']['address']),
                _buildInfoRow('العمر', patient['user']['age'].toString()),
                _buildInfoRow('الجنس', patient['user']['gender']),
              ]),
              SizedBox(height: 16),
              _buildInfoCard('المعلومات الطبية', [
                _buildInfoRow('التاريخ الطبي', patient['medical_history']),
                _buildInfoRow('الحساسية', patient['allergies']),
                _buildInfoRow('فصيلة الدم', patient['blood_type']),
                _buildInfoRow('الأدوية الحالية', patient['current_medications']),
                _buildInfoRow('التوصيات الطبية', patient['medical_recommendations']),
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
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(-15441249)),
            ),
            Divider(color: Color(-15441249)),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(-15441249)),
          ),
          Text(value, style: TextStyle(color: Colors.black87)),
        ],
      ),
    );
  }
}

class UpdatePatientPage extends StatelessWidget {
  final PatientController patientController;

  UpdatePatientPage({Key? key, required this.patientController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final patient = patientController.patientData;

    final nameController = TextEditingController(text: patient['user']['name']);
    final emailController = TextEditingController(text: patient['user']['email']);
    final phoneController = TextEditingController(text: patient['user']['phone']);
    final addressController = TextEditingController(text: patient['user']['address']);
    final ageController = TextEditingController(text: patient['user']['age'].toString());
    final genderController = TextEditingController(text: patient['user']['gender']);
    final medicalHistoryController = TextEditingController(text: patient['medical_history']);
    final allergiesController = TextEditingController(text: patient['allergies']);
    final bloodTypeController = TextEditingController(text: patient['blood_type']);
    final currentMedicationsController = TextEditingController(text: patient['current_medications']);
    final recommendationsController = TextEditingController(text: patient['medical_recommendations']);

    return Scaffold(
      backgroundColor: Color(-789517),
      appBar: AppBar(
        backgroundColor: Color(-15441249),
        centerTitle: true,
        title: Text('تحديث معلومات المريض',style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
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
              _buildTextField('العمر', ageController),
              _buildTextField('الجنس', genderController),
              _buildTextField('التاريخ الطبي', medicalHistoryController),
              _buildTextField('الحساسية', allergiesController),
              _buildTextField('فصيلة الدم', bloodTypeController),
              _buildTextField('الأدوية الحالية', currentMedicationsController),
              _buildTextField('التوصيات الطبية', recommendationsController),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    patientController.updatePatientData(
                      patient['id'],
                      {
                        'user': {
                          'name': nameController.text,
                          'email': emailController.text,
                          'phone': phoneController.text,
                          'address': addressController.text,
                          'age': int.parse(ageController.text),
                          'gender': genderController.text,
                        },
                        'medical_history': medicalHistoryController.text,
                        'allergies': allergiesController.text,
                        'blood_type': bloodTypeController.text,
                        'current_medications': currentMedicationsController.text,
                        'medical_recommendations': recommendationsController.text,
                      },
                    );
                    Get.back();
                  }
                },
                child: Text('تحديث المعلومات'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(-15441249),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  shadowColor: Color(-15441249).withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(-15441249)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(-15441249)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Color(-15441249), width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(color: Colors.black87),
        validator: (value) => value!.isEmpty ? 'هذا الحقل مطلوب' : null,
      ),
    );
  }
}

