// lib/models/author_model.dart
class Author {
  final int? id;
  final String? authorName;

  Author({this.id, this.authorName});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      // This maps 'authorName' from the API JSON to our model
      authorName: json['authorName'] ?? json['name'], 
    );
  }
}