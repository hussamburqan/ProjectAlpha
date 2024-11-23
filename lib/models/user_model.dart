import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final Patient? patient;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.patient,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      patient: json['patient'] != null ? Patient.fromJson(json['patient']) : null,
    );
  }
}

@HiveType(typeId: 1)
class Patient {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int userId;

  Patient({
    required this.id,
    required this.userId,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      userId: json['user_id'],
    );
  }
}