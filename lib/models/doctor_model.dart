class Doctor {
  final int id;
  final int userId;
  final int experienceYears;
  final String specialization;
  final String education;
  final String? photo;
  final String startWorkTime;
  final String endWorkTime;
  final int defaultTimeReservations;
  final String bio;

  Doctor({
    required this.id,
    required this.userId,
    required this.experienceYears,
    required this.specialization,
    required this.education,
    this.photo,
    required this.startWorkTime,
    required this.endWorkTime,
    required this.defaultTimeReservations,
    required this.bio,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      userId: json['user']['id'],
      experienceYears: json['experience_years'],
      specialization: json['specialization'],
      education: json['education'],
      photo: json['photo'],
      startWorkTime: json['start_work_time'],
      endWorkTime: json['end_work_time'],
      defaultTimeReservations: json['default_time_reservations'],
      bio: json['bio'],
    );
  }
}