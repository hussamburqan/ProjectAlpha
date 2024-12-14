import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/patient_archive_controller.dart';
import 'package:projectalpha/models/doctor_reservation_model.dart';
import 'package:projectalpha/models/patient_archive_model.dart';

class PatientArchiveForm extends StatefulWidget {
  final DoctorReservation reservation;
  final bool isEdit;
  final PatientArchive? existingArchive;

  PatientArchiveForm({
    required this.reservation,
    required this.isEdit,
    this.existingArchive,
  });

  @override
  _PatientArchiveFormState createState() => _PatientArchiveFormState();
}

class _PatientArchiveFormState extends State<PatientArchiveForm> {
  final PatientArchiveController controller = Get.put(PatientArchiveController());
  final TextEditingController diagnosisController = TextEditingController();
  final TextEditingController treatmentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.existingArchive == null) {
      controller.getArchiveByReservationId(widget.reservation.id);
    }
print(widget.existingArchive);
    if (widget.existingArchive != null) {
      diagnosisController.text = widget.existingArchive!.description;
      treatmentController.text = widget.existingArchive!.instructions;
      controller.status.value = widget.existingArchive!.status;
    }
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
        backgroundColor: Color(-15441249),
        title: Text(widget.isEdit ? 'تعديل السجل' : 'إنشاء سجل' ,style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: controller.formKey,
          child: ListView(
            children: [
              Center(child: Text(widget.isEdit ? 'انت تقوم بتعديل ارشيف موجود' : 'انت تنشئ ارشيف جديد')),
              const SizedBox(height: 16),
              TextFormField(
                controller: diagnosisController,
                decoration: InputDecoration(
                  labelText: 'الوصف',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'الوصف مطلوب' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: treatmentController,
                decoration: InputDecoration(
                  labelText: 'التعليمات',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'التعليمات مطلوبة' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: controller.status.value.isNotEmpty &&
                    ['good', 'bad', 'need_to_care'].contains(controller.status.value)
                    ? controller.status.value
                    : null,
                items: [
                  const DropdownMenuItem(value: 'good', child: Text('بصحة جيدة')),
                  const DropdownMenuItem(value: 'bad', child: Text('بصحة سيئة')),
                  const DropdownMenuItem(value: 'need_to_care', child: Text('يجب ان تلتزم')),
                ],
                onChanged: (value) => controller.status.value = value!,
                decoration: InputDecoration(
                  labelText: 'الحالة',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  controller.submitArchive(
                    reservationId: widget.reservation.id,
                    isEdit: widget.isEdit,
                    diagnosis: diagnosisController.text,
                    treatment: treatmentController.text,
                    archiveId: widget.existingArchive != null ? widget.existingArchive!.id : null,
                    patientId: widget.reservation.patient.id,
                  );
                },style: ElevatedButton.styleFrom(
                backgroundColor: Color(-15441249),
                padding: EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                textStyle: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
                child: Text(widget.isEdit ? 'تحديث' : 'حفظ',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
