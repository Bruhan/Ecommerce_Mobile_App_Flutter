import 'package:json_annotation/json_annotation.dart';

part 'author_response.g.dart';

@JsonSerializable()
class AuthorResponse {
  @JsonKey(defaultValue: '')
  final String plant;
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String author;
  @JsonKey(defaultValue: '')
  final String crAt;
  @JsonKey(defaultValue: '')
  final String crBy;
  final dynamic upAt;
  final dynamic upBy;
  @JsonKey(defaultValue: '')
  final String isActive;

  const AuthorResponse({
    required this.plant,
    required this.id,
    required this.author,
    required this.crAt,
    required this.crBy,
    this.upAt,
    this.upBy,
    required this.isActive,
  });

  factory AuthorResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthorResponseToJson(this);
}
