import 'package:projectalpha/models/patient_model.dart';

class PatientArchive {
  final int id;
  final String date;
  final String diagnosis;
  final String treatment;
  final String? notes;
  final String? nextVisitDate;
  final Patient patient;
  final List<String>? images;

  PatientArchive({
    required this.id,
    required this.date,
    required this.diagnosis,
    required this.treatment,
    this.notes,
    this.nextVisitDate,
    required this.patient,
    this.images,
  });

  factory PatientArchive.fromJson(Map<String, dynamic> json) {
    return PatientArchive(
      id: json['id'],
      date: json['date'],
      diagnosis: json['diagnosis'],
      treatment: json['treatment'],
      notes: json['notes'],
      nextVisitDate: json['next_visit_date'],
      patient: Patient.fromJson(json['patient']),
      images: json['images'] != null
          ? List<String>.from(json['images'])
          : null,
    );
  }
}