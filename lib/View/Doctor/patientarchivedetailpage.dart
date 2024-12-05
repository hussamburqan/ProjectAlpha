import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:projectalpha/models/patient_archive_model.dart';
import 'package:projectalpha/services/constants.dart';

class PatientArchiveDetailPage extends StatelessWidget {
  final PatientArchive archive;

  const PatientArchiveDetailPage({Key? key, required this.archive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل السجل الطبي'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _buildPatientInfo(),
              SizedBox(height: 20),
              _buildDivider('التشخيص'),
              _buildContentBox(archive.diagnosis),
              SizedBox(height: 20),
              _buildDivider('العلاج'),
              _buildContentBox(archive.treatment),
              if (archive.notes != null) ...[
                SizedBox(height: 20),
                _buildDivider('ملاحظات'),
                _buildContentBox(archive.notes!),
              ],
              if (archive.nextVisitDate != null) ...[
                SizedBox(height: 20),
                _buildDivider('موعد الزيارة القادمة'),
                _buildContentBox(archive.nextVisitDate!),
              ],
              if (archive.images != null && archive.images!.isNotEmpty) ...[
                SizedBox(height: 20),
                _buildDivider('الصور'),
                _buildImagesGrid(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              archive.patient.name,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            _buildInfoRow('العمر', '${archive.patient.age} سنة'),
            _buildInfoRow('الجنس', archive.patient.gender == 'male' ? 'ذكر' : 'أنثى'),
            _buildInfoRow('تاريخ الزيارة', archive.date),
            if (archive.patient.phone != null)
              _buildInfoRow('رقم الهاتف', archive.patient.phone!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(value),
          SizedBox(width: 8),
          Text(
            '$label:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Divider(thickness: 1),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentBox(String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        content,
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildImagesGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: archive.images!.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => _showImage(context, archive.images![index]),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              '${AppConstants.baseURLPhoto}${archive.images![index]}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showImage(BuildContext context, String imagePath) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              panEnabled: true,
              boundaryMargin: EdgeInsets.all(20),
              minScale: 0.5,
              maxScale: 4,
              child: Image.network(
                '${AppConstants.baseURLPhoto}$imagePath',
                fit: BoxFit.contain,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }
}