
class Reservation {
  final int id;
  final String date;
  final String time;
  final int durationMinutes;
  final String status;
  final String reasonForVisit;
  final String? notes;
  final String doctorName;
  final String doctorPhoto;
  final String doctorSpeciality;
  final String clinicName;
  final String clinicPhone;
  final String clinicMajor;

  Reservation({
    required this.id,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.status,
    required this.reasonForVisit,
    this.notes,
    required this.doctorName,
    required this.doctorPhoto,
    required this.doctorSpeciality,
    required this.clinicName,
    required this.clinicPhone,
    required this.clinicMajor,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      durationMinutes: json['duration_minutes'] ?? 0,
      status: json['status'] ?? '',
      reasonForVisit: json['reason_for_visit'] ?? '',
      notes: json['notes'],
      clinicMajor: json['clinic']['major']['name'] ?? '',
      clinicName: json['clinic']['user']['name'] ?? '',
      clinicPhone: json['clinic']['user']['phone'] ?? '',
      doctorPhoto: json['doctor']['photo'] ?? '',
      doctorName: json['doctor']['user']['name'] ?? '',
      doctorSpeciality: json['doctor']['speciality'] ?? '',
    );
  }
}
