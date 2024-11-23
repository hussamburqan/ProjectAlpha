class Appointment {
  final int id;
  final String doctorName;
  final String clinicName;
  final String specialization;
  final String date;
  final String time;
  final String status;
  final String? image;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.clinicName,
    required this.specialization,
    required this.date,
    required this.time,
    required this.status,
    this.image,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorName: json['doctor']['name'],
      clinicName: json['clinic']['name'],
      specialization: json['doctor']['specialization'],
      date: json['date'],
      time: json['time'],
      status: json['status'],
      image: json['doctor']['photo'],
    );
  }
}