class DoctorReservation {
  final int id;
  final String date;
  final String time;
  final int durationMinutes;
  final String status;
  final String reasonForVisit;
  final String? notes;
  final DoctorInfo doctor;
  final ClinicInfo clinic;
  final PatientInfo patient;
  final String createdAt;
  final String updatedAt;

  DoctorReservation({
    required this.id,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.status,
    required this.reasonForVisit,
    this.notes,
    required this.doctor,
    required this.clinic,
    required this.patient,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DoctorReservation.fromJson(Map<String, dynamic> json) {
    return DoctorReservation(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      status: json['status'] ?? '',
      reasonForVisit: json['reason_for_visit'] ?? '',
      notes: json['notes'],
      doctor: DoctorInfo.fromJson(json['doctor'] ?? {}),
      clinic: ClinicInfo.fromJson(json['clinic'] ?? {}),
      patient: PatientInfo.fromJson(json['patient'] ?? {}),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class DoctorInfo {
  final int id;
  final DoctorUserInfo user;
  final String photo;
  final String speciality;

  DoctorInfo({
    required this.id,
    required this.user,
    required this.photo,
    required this.speciality,
  });

  factory DoctorInfo.fromJson(Map<String, dynamic> json) {
    return DoctorInfo(
      id: json['id'] ?? 0,
      user: DoctorUserInfo.fromJson(json['user'] ?? {}),
      photo: json['photo'] ?? '',
      speciality: json['speciality'] ?? '',
    );
  }
}

class DoctorUserInfo {
  final int id;
  final String name;

  DoctorUserInfo({
    required this.id,
    required this.name,
  });

  factory DoctorUserInfo.fromJson(Map<String, dynamic> json) {
    return DoctorUserInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ClinicInfo {
  final int id;
  final int userId;
  final int majorId;
  final String location;
  final String? photo;
  final String? coverPhoto;
  final String description;
  final String openingTime;
  final String closingTime;
  final ClinicUserInfo user;
  final MajorInfo major;

  ClinicInfo({
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
  });

  factory ClinicInfo.fromJson(Map<String, dynamic> json) {
    return ClinicInfo(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      majorId: json['major_id'] ?? 0,
      location: json['location'] ?? '',
      photo: json['photo'],
      coverPhoto: json['cover_photo'],
      description: json['description'] ?? '',
      openingTime: json['opening_time'] ?? '',
      closingTime: json['closing_time'] ?? '',
      user: ClinicUserInfo.fromJson(json['user'] ?? {}),
      major: MajorInfo.fromJson(json['major'] ?? {}),
    );
  }
}

class ClinicUserInfo {
  final int id;
  final String name;
  final String phone;
  final int age;
  final String gender;

  ClinicUserInfo({
    required this.id,
    required this.name,
    required this.phone,
    required this.age,
    required this.gender,
  });

  factory ClinicUserInfo.fromJson(Map<String, dynamic> json) {
    return ClinicUserInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }
}

class MajorInfo {
  final int id;
  final String name;

  MajorInfo({
    required this.id,
    required this.name,
  });

  factory MajorInfo.fromJson(Map<String, dynamic> json) {
    return MajorInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class PatientInfo {
  final int id;
  final PatientUserInfo user;

  PatientInfo({
    required this.id,
    required this.user,
  });

  factory PatientInfo.fromJson(Map<String, dynamic> json) {
    return PatientInfo(
      id: json['id'] ?? 0,
      user: PatientUserInfo.fromJson(json['user'] ?? {}),
    );
  }
}

class PatientUserInfo {
  final String name;
  final String phone;
  final int age;
  final String gender;

  PatientUserInfo({
    required this.name,
    required this.phone,
    required this.age,
    required this.gender,
  });

  factory PatientUserInfo.fromJson(Map<String, dynamic> json) {
    return PatientUserInfo(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }
}