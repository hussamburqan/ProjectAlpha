class MedicalNews {
  final int id;
  final String title;
  final String content;
  final String? image;
  final String category;
  final bool isFeatured;

  MedicalNews({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.category,
    required this.isFeatured,
  });

  factory MedicalNews.fromJson(Map<String, dynamic> json) {
    return MedicalNews(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      category: json['category'],
      isFeatured: json['is_featured'] == 1,
    );
  }
}