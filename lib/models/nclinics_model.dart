import 'package:projectalpha/models/doctor_model.dart';
import 'package:projectalpha/models/major_model.dart';
import 'package:projectalpha/models/user_model.dart';

class Clinic {
  final int id;
  final int userId;
  final int majorId;
  final String location;
  final String? photo;
  final String? coverPhoto;
  final String description;
  final String openingTime;
  final String closingTime;
  final User user;
  final Major major;
  final int doctorsCount;
  final List<Doctor> doctors;

  Clinic({
    required this.id,
    required this.userId,
    required this.majorId,
    required this.location,
    this.photo,
    this.coverPhoto,
    required this.description,
    required this.openingTime,
    required this.closingTime,
    required this.user,
    required this.major,
    required this.doctorsCount,
    required this.doctors,
  });

  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'],
      userId: json['user_id'],
      majorId: json['major_id'],
      location: json['location'],
      photo: json['photo'],
      coverPhoto: json['cover_photo'],
      description: json['description'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      user: User.fromJson(json['user']),
      major: Major.fromJson(json['major']),
      doctorsCount: json['doctors_count'],
      doctors: (json['doctors'] as List).map((d) => Doctor.fromJson(d)).toList(),
    );
  }
}