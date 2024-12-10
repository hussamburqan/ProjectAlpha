import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/patient_archive_controller.dart';
import 'package:projectalpha/View/Doctor/PatientArchiveForm.dart';
import 'package:projectalpha/models/patient_archive_model.dart';
import 'package:intl/intl.dart';

class PatientArchivePage extends StatelessWidget {
  final PatientArchiveController controller = Get.put(PatientArchiveController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(-789517),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showArchiveForm(context),
        child: Icon(Icons.add),
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
          return _buildArchiveCard(archive, context);
        },
      );
    });
  }

  Widget _buildArchiveCard(PatientArchive archive, context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _showArchiveForm(context, archive: archive),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('yyyy/MM/dd').format(DateTime.parse(archive.date)),
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
                'التشخيص: ${archive.description}',
                textAlign: TextAlign.right,
              ),
              Text(
                'العلاج: ${archive.instructions}',
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // IconButton(
                  //   icon: Icon(Icons.delete, color: Colors.red),
                  //   onPressed: () => controller.deleteArchive(archive.id),
                  // ),
                  _buildStatusChip(archive.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    String label;
    switch (status) {
      case 'good':
        chipColor = Colors.green;
        label = 'بصحة جيدة';
        break;
      case 'bad':
        chipColor = Colors.red;
        label = 'بصحة سيئة';
        break;
      case 'need_to_care':
        chipColor = Colors.orange;
        label = 'يجب ان تلتزم';
        break;
      default:
        chipColor = Colors.grey;
        label = 'معلق';
    }

    return Chip(
      label: Text(
        label,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: chipColor,
    );
  }

  void _showArchiveForm(BuildContext context, {PatientArchive? archive}) {
    Get.to(() => PatientArchiveForm(
      reservation: archive!.reservation,
      isEdit: archive != null,
      existingArchive: archive,
    ));
  }
}
