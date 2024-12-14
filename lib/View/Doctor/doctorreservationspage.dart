import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/doctor_reservation_controller.dart';
import 'package:projectalpha/Controller/patient_archive_controller.dart';
import 'package:projectalpha/View/Doctor/PatientArchiveForm.dart';
import 'package:projectalpha/models/doctor_reservation_model.dart';
import 'package:projectalpha/models/patient_archive_model.dart';

class DoctorReservationsPage extends StatelessWidget {
  final controller = Get.put(DoctorReservationController());

  @override
  Widget build(BuildContext context) {
    controller.getReservations();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(-789517),
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                indicatorColor: Color(-15441249), // تغيير لون المؤشر
                labelColor: Color(-15441249), // تغيير لون النص للتاب المختار
                unselectedLabelColor: Colors.black, // تغيير لون النص للتاب الغير مختار
                tabs: const [
                  Tab(text: 'مواعيد اليوم'),
                  Tab(text: 'المواعيد القادمة'),
                  Tab(text: 'المواعيد السابقة'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildReservationsList(
                      filter: (res, today) =>
                          _isSameDay(DateTime.parse(res.date), today),
                      emptyMessage: 'لا توجد مواعيد اليوم',
                    ),
                    _buildReservationsList(
                      filter: (res, today) =>
                      res.status == 'confirmed' &&
                          DateTime.parse(res.date).isAfter(today),
                      emptyMessage: 'لا توجد مواعيد قادمة',
                    ),
                    _buildReservationsList(
                      filter: (res, today) =>
                      res.status == 'confirmed' &&
                          DateTime.parse(res.date).isBefore(today),
                      emptyMessage: 'لا توجد مواعيد سابقة',
                      isPast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationsList({
    required bool Function(DoctorReservation res, DateTime today) filter,
    required String emptyMessage,
    bool isPast = false,
  }) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final today = DateTime.now();
      final reservations = controller.reservations.where((res) => filter(res, today)).toList();

      if (reservations.isEmpty) {
        return Center(child: Text(emptyMessage));
      }

      reservations.sort((a, b) {
        final dateComparison = DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });

      return RefreshIndicator(
        onRefresh: controller.getReservations,
        child: ListView.builder(
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation = reservations[index];
            return _buildReservationCard(reservation, isPast: isPast);
          },
        ),
      );
    });
  }

  Widget _buildReservationCard(DoctorReservation reservation, {bool isPast = false}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reservation.patient.user.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today, '${reservation.date} ${reservation.time}'),
            _buildInfoRow(Icons.phone, reservation.patient.user.phone),
            _buildInfoRow(Icons.person, 'العمر: ${reservation.patient.user.age}'),
            _buildInfoRow(Icons.notes, 'سبب الزيارة: ${reservation.reasonForVisit}'),
            Center(
              child: ElevatedButton(
                onPressed: () => _handleArchiveAction(reservation, isPast),
                child: Text(isPast ? 'تعديل الأرشيف' : 'إنشاء أرشيف',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(-15441249),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  textStyle: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text ?? ''),
          const SizedBox(width: 8),
          Icon(icon, size: 16, color: Colors.grey),
        ],
      ),
    );
  }

  void _handleArchiveAction(DoctorReservation reservation, bool isPast) async {
    final controller1 = Get.put(PatientArchiveController());
    PatientArchive? archive = await controller1.getArchiveByReservationId(reservation.id);

    if (archive != null) {
      Get.to(() => PatientArchiveForm(
        reservation: reservation,
        isEdit: true,
        existingArchive: archive,
      ));
    } else {
      Get.to(() => PatientArchiveForm(
        reservation: reservation,
        isEdit: false,
      ));
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
