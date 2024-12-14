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
      backgroundColor: Color(-921103),

      appBar: AppBar(
        iconTheme: IconThemeData(
        color: Colors.white,
      ),centerTitle: true,
        title: Text('تفاصيل الأرشيف الطبي',style: TextStyle(color: Colors.white),),backgroundColor: Color(-15441249),),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.archives != null && controller.archives.isNotEmpty) {
          final archive = controller.archives[0];
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerRight,
                    child: Text('الوصف: ${archive.description}', style: TextStyle(fontSize: 16))),
                SizedBox(height: 16),
                Align(alignment: Alignment.centerRight,
                    child: Text('التعليمات: ${archive.instructions}', style: TextStyle(fontSize: 16))),
                SizedBox(height: 16),
                Align(alignment: Alignment.centerRight,
                    child: Text('الحالة: ${_getStatusLabel(archive.status)}', style: TextStyle(fontSize: 16))),
                SizedBox(height: 16),
                Align(alignment: Alignment.centerRight,
                    child: Text('اخر تحديث في : ${archive.date}', style: TextStyle(fontSize: 16))),
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
