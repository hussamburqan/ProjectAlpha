import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectalpha/Controller/doctor_reservation_controller.dart';
import 'package:projectalpha/models/doctor_reservation_model.dart';

class DoctorReservationsPage extends StatelessWidget {
  final controller = Get.put(DoctorReservationController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المواعيد المؤكدة'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'المواعيد القادمة'),
              Tab(text: 'المواعيد السابقة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildCurrentReservations(),
            _buildPastReservations(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentReservations() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      final currentReservations = controller.reservations
          .where((res) {
        final reservationDate = DateTime.parse(res.date);
        return res.status == 'confirmed' &&
            DateTime(reservationDate.year, reservationDate.month, reservationDate.day)
                .isAtSameMomentAs(today) ||
            reservationDate.isAfter(now);
      })
          .toList();

      if (currentReservations.isEmpty) {
        return Center(child: Text('لا توجد مواعيد مؤكدة'));
      }

      currentReservations.sort((a, b) {
        final dateComparison = DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
        if (dateComparison != 0) return dateComparison;
        return a.time.compareTo(b.time);
      });

      return RefreshIndicator(
        onRefresh: controller.getReservations,
        child: ListView.builder(
          itemCount: currentReservations.length,
          itemBuilder: (context, index) {
            final reservation = currentReservations[index];
            return _buildReservationCard(reservation);
          },
        ),
      );
    });
  }

  Widget _buildPastReservations() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }

      final pastReservations = controller.reservations
          .where((res) =>
      res.status == 'confirmed' &&
          DateTime.parse(res.date).isBefore(DateTime.now()))
          .toList();

      if (pastReservations.isEmpty) {
        return Center(child: Text('لا توجد مواعيد سابقة'));
      }

      return ListView.builder(
        itemCount: pastReservations.length,
        itemBuilder: (context, index) {
          return _buildReservationCard(pastReservations[index], isPast: true);
        },
      );
    });
  }

  Widget _buildReservationCard(DoctorReservation reservation, {bool isPast = false}) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reservation.patient.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            _buildInfoRow(Icons.calendar_today, '${reservation.date} ${reservation.time}'),
            _buildInfoRow(Icons.phone, reservation.patient.phone),
            _buildInfoRow(Icons.person, 'العمر: ${reservation.patient.age}'),
            _buildInfoRow(Icons.notes, 'سبب الزيارة: ${reservation.reasonForVisit}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String? text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(text!),
          SizedBox(width: 8),
          Icon(icon, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}