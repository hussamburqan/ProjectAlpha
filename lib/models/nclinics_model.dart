import 'package:projectalpha/models/doctor_model.dart';

class NClinic {
  final int id;
  final String name;
  final String location;
  final String description;
  final String openingTime;
  final String closingTime;
  final String status;
  final String? photo;
  final String? major;
  final List<Doctor> doctors;

  NClinic({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.openingTime,
    required this.closingTime,
    required this.status,
    required this.major,
    this.photo,
    required this.doctors,
  });

  factory NClinic.fromJson(Map<String, dynamic> json) {
    return NClinic(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      openingTime: json['opening_time'],
      closingTime: json['closing_time'],
      status: json['status'],
      major: json['major']['name'],
      photo: json['photo'],
      doctors: (json['doctors'] as List)
          .map((doctorJson) => Doctor.fromJson(doctorJson))
          .toList(),
    );
  }
}
