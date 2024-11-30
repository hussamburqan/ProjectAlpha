import 'package:projectalpha/models/doctor_model.dart';
import 'package:projectalpha/models/nclinics_model.dart';

class Reservation {
  final int id;
  final String date;
  final String time;
  final int durationMinutes;
  final String status;
  final String reasonForVisit;
  final String? notes;
  final Doctor doctor;
  final Clinic clinic;

  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.status,
    required this.reasonForVisit,
    this.notes,
    required this.doctor,
    required this.clinic,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      durationMinutes: json['duration_minutes'],
      status: json['status'],
      reasonForVisit: json['reason_for_visit'],
      notes: json['notes'],
      doctor: Doctor.fromJson(json['doctor']),
      clinic: Clinic.fromJson(json['clinic']),
    );
  }
}