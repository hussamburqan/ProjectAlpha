class Doctor {
  final int id;
  final String name;
  final int userId;
  final int experienceYears;
  final String specialization;
  final String education;
  final String? photo; // Nullable
  final String startWorkTime;
  final String endWorkTime;
  final int defaultTimeReservations;
  final String? bio; // Nullable

  Doctor({
    required this.id,
    required this.name,
    required this.userId,
    required this.experienceYears,
    required this.specialization,
    required this.education,
    this.photo,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.defaultTimeReservations,
    this.bio,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      name: json['user']?['name'] ?? 'Unknown',
      userId: json['user']?['id'] ?? 0,
      experienceYears: json['experience_years'] ?? 0,
      specialization: json['specialization'] ?? 'General',
      education: json['education'] ?? 'Unknown',
      photo: json['photo'],
      startWorkTime: json['start_work_time'] ?? '00:00:00',
      endWorkTime: json['end_work_time'] ?? '00:00:00',
      defaultTimeReservations: json['default_time_reservations'] ?? 30,
      bio: json['bio'],
    );
  }
}
