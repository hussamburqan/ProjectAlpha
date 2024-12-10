import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/home_controller.dart';
import 'package:projectalpha/View/patientarchivedetails.dart';
import 'package:projectalpha/component/MyImage.dart';
import 'package:projectalpha/models/reservation_model.dart';
import 'package:projectalpha/services/constants.dart';

class NotificationsPage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;

    controller.getReservations('');

    return Scaffold(
      backgroundColor: Color(-789517),
      body: Column(
        children: [
          SizedBox(height: screenSize.height * 0.01),
          _buildAppointmentList(controller, screenSize),
          SizedBox(height: screenSize.height * 0.1),

        ],
      ),
    );
  }

  Widget _buildAppointmentList(HomeController controller, Size screenSize) {
    return Obx(() {
      if (controller.isLoadingR.value) {
        return Center(child: CircularProgressIndicator());
      }

      final filteredAppointments = controller.reservations
          .where((appointment) =>
      appointment.status != 'canceled' && appointment.status != 'completed')
          .toList()
        ..sort((a, b) {
          final dateTimeA = DateTime.parse('${a.date} ${a.time}');
          final dateTimeB = DateTime.parse('${b.date} ${b.time}');
          return dateTimeA.compareTo(dateTimeB);
        });

      if (filteredAppointments.isEmpty) {
        return Center(child: Text('لا يوجد إشعارات'));
      }

      return Expanded(
        child: ListView.builder(
          itemCount: filteredAppointments.length,
          itemBuilder: (context, index) {
            return _buildAppointmentCard(
                filteredAppointments[index], screenSize);
          },
        ),
      );
    });
  }

  Widget _buildAppointmentCard(Reservation reservation, Size screenSize) {
    String getStatusMessage(String status) {
      switch (status) {
        case 'pending':
          return 'حجزك في قائمة الانتظار';
        case 'accepted':
          return 'تمت الموافقة على حجزك';
        case 'confirmed':
          return 'شكرا لزيارتك لنا يمكنك الضغط لرؤية ملفك الطبي';
        case 'cancelled':
          return 'تم إلغاء حجزك';
        default:
          return '';
      }
    }

    return InkWell(
      onTap: reservation.status == 'pending' ? () {
        showDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('تأكيد الحذف'),
              content: Text('هل تريد حذف هذا التسجيل؟'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('إلغاء'),
                ),
                TextButton(
                  onPressed: () {
                    controller.cancelReservation(reservation.id);
                    Navigator.of(context).pop();
                  },
                  child: Text('حذف'),
                ),
              ],
            );
          },
        );
      } : reservation.status == 'confirmed' ? () {
        Get.to(() => PatientArchiveDetails(reservationId: reservation.id));
      }
          : null,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.02,
          vertical: screenSize.height * 0.005,
        ),
        child: Card(
          color: Color(-789517),
          elevation: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        reservation.doctorName,
                        style: TextStyle(
                          fontSize: screenSize.height * 0.02,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.005),
                      Text(
                        reservation.clinicName,
                        style: TextStyle(
                          color: const Color(-7763575),
                          fontSize: screenSize.height * 0.02,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.005),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${reservation.date} - ${reservation.time}',
                            style: TextStyle(
                              color: const Color(-13280354),
                              fontSize: screenSize.height * 0.017,
                            ),
                          ),
                          SizedBox(width: screenSize.width * 0.005),
                          Icon(
                            Icons.access_time_filled,
                            color: Color(-13280354),
                            size: screenSize.height * 0.025,
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.005),
                      Text(
                        getStatusMessage(reservation.status),
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: screenSize.height * 0.018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (reservation.doctorPhoto != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyImageNet(
                    path: '${AppConstants.baseURLPhoto}storage/${reservation
                        .doctorPhoto}',
                    sizeh: screenSize.height,
                  ),
                )
              else
                Image.asset('assets/doctor_placeholder.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}

