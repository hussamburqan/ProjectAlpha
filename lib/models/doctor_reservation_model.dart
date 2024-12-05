import 'package:projectalpha/models/nclinics_model.dart';
import 'package:projectalpha/models/patient_model.dart';

class DoctorReservation {
  final int id;
  final String date;
  final String time;
  final int durationMinutes;
  final String status;
  final String reasonForVisit;
  final String? notes;
  final Patient patient;
  final Clinic clinic;

  DoctorReservation({
    required this.id,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.status,
    required this.reasonForVisit,
    this.notes,
    required this.patient,
    required this.clinic,
  });

  factory DoctorReservation.fromJson(Map<String, dynamic> json) {
    return DoctorReservation(
      id: json['id'],
      date: json['date'],
      time: json['time'],
      durationMinutes: json['duration_minutes'],
      status: json['status'],
      reasonForVisit: json['reason_for_visit'],
      notes: json['notes'],
      patient: Patient.fromJson(json['patient']),
      clinic: Clinic.fromJson(json['clinic']),
    );
  }
}