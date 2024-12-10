import 'package:projectalpha/models/doctor_reservation_model.dart';
import 'package:projectalpha/models/patient_model.dart';

class PatientArchive {
  final int id;
  final String date;
  final String description;
  final String instructions;
  final String status;
  final Patient patient;
  final DoctorReservation reservation;

  PatientArchive({
    required this.id,
    required this.date,
    required this.description,
    required this.instructions,
    required this.status,
    required this.patient,
    required this.reservation,
  });

  factory PatientArchive.fromJson(Map<String, dynamic> json) {
    return PatientArchive(
      id: json['id'],
      date: json['date'],
      description: json['description'],
      instructions: json['instructions'],
      status: json['status'] ?? 'pending',
      reservation: DoctorReservation.fromJson(json['reservation']),
      patient: Patient.fromJson(json['patient'])
    );
  }
}