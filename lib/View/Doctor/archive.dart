import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/doctor_reservation_controller.dart';
import 'package:projectalpha/View/Doctor/patientarchivedetailpage.dart';
import 'package:projectalpha/models/patient_archive_model.dart';
import 'package:intl/intl.dart';

class PatientArchivePage extends StatelessWidget {
  final PatientArchiveController controller = Get.put(PatientArchiveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أرشيف المرضى'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildArchiveList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'البحث عن مريض...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: (value) => controller.searchPatients(value),
      ),
    );
  }

  Widget _buildArchiveList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      if (controller.archives.isEmpty) {
        return Center(child: Text('لا يوجد سجلات'));
      }

      return ListView.builder(
        itemCount: controller.archives.length,
        itemBuilder: (context, index) {
          final archive = controller.archives[index];
          return _buildArchiveCard(archive);
        },
      );
    });
  }

  Widget _buildArchiveCard(PatientArchive archive) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => Get.to(() => PatientArchiveDetailPage(archive: archive)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy/MM/dd').format(archive.date as DateTime),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    archive.patient.name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'التشخيص: ${archive.diagnosis}',
                textAlign: TextAlign.right,
              ),
              SizedBox(height: 4),
              Text(
                'العلاج: ${archive.treatment}',
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
