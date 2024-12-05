import 'package:projectalpha/models/user_model.dart';

class PatientArchive {
  final int id;
  final String medicalHistory;
  final String allergies;
  final String bloodType;
  final String currentMedications;
  final String medicalRecommendations;
  final User user;

  PatientArchive({
    required this.id,
    required this.medicalHistory,
    required this.allergies,
    required this.bloodType,
    required this.currentMedications,
    required this.medicalRecommendations,
    required this.user,
  });

  factory PatientArchive.fromJson(Map<String, dynamic> json) {
    return PatientArchive(
      id: json['id'] ?? 0,
      medicalHistory: json['medical_history'] ?? '',
      allergies: json['allergies'] ?? '',
      bloodType: json['blood_type'] ?? '',
      currentMedications: json['current_medications'] ?? '',
      medicalRecommendations: json['medical_recommendations'] ?? '',
      user: User.fromJson(json['user']),
    );
  }
}