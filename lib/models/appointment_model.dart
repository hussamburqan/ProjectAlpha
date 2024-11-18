class Appointment {
  final int id;
  final String doctorName;
  final String clinicName;
  final String date;
  final String? image;

  Appointment({
    required this.id,
    required this.doctorName,
    required this.clinicName,
    required this.date,
    this.image,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      doctorName: json['doctor_name'],
      clinicName: json['clinic_name'],
      date: json['date'],
      image: json['image'],
    );
  }
}