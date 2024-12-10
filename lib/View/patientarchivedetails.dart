import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/patient_archive_controller.dart';

class PatientArchiveDetails extends StatelessWidget {
  final int reservationId;
  final PatientArchiveController controller = Get.put(PatientArchiveController());

  PatientArchiveDetails({required this.reservationId});

  @override
  Widget build(BuildContext context) {
    controller.getArchiveByReservationId(reservationId);

    return Scaffold(
      appBar: AppBar(title: Text('تفاصيل الأرشيف الطبي')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.archives != null) {
          final archive = controller.archives[0]!;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('الوصف: ${archive.description}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('التعليمات: ${archive.instructions}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('الحالة: ${_getStatusLabel(archive.status)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 16),
                Text('اخر تحديث في : ${_getStatusLabel(archive.date)}', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        }

        return Center(child: Text('لم يتم العثور على تفاصيل الأرشيف.'));
      }),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'مكتمل';
      case 'no_show':
        return 'لم يحضر';
      default:
        return 'معلق';
    }
  }
}
