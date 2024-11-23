class Doctor {
  final int id;
  final String specialization;
  final String name;
  final String education;
  final String bio;
  final String? photo;
  final int experienceYears;
  final double consultationFee;

  Doctor({
    required this.id,
    required this.specialization,
    required this.education,
    required this.name,
    required this.bio,
    this.photo,
    required this.experienceYears,
    required this.consultationFee,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      education: json['education'],
      bio: json['bio'],
      photo: json['photo'],
      experienceYears: json['experience_years'],
      consultationFee: double.tryParse(json['consultation_fee'] ?? '0') ?? 0.0,
    );
  }
}
