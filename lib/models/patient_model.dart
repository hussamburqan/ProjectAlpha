class Patient {
  final int id;
  final String name;
  final String? phone;
  final int? age;
  final String? gender;

  Patient({
    required this.id,
    required this.name,
    this.phone,
    this.age,
    this.gender,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      name: json['user']['name'],
      phone: json['user']['phone'],
      age: json['user']['age'],
      gender: json['user']['gender'],
    );
  }
}