class Major {
  final int id;
  final String name;


  Major({
    required this.id,
    required this.name,

  });

  factory Major.fromJson(Map<String, dynamic> json) {
    return Major(
      id: json['id'],
      name: json['name'],
    );
  }
}
