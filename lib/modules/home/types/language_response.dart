import 'package:json_annotation/json_annotation.dart';

part 'language_response.g.dart';

@JsonSerializable()
class LanguageResponse {
  @JsonKey(defaultValue: '')
  final String plant;
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String language;
  @JsonKey(defaultValue: '')
  final String crAt;
  @JsonKey(defaultValue: '')
  final String crBy;
  final dynamic upAt;
  final dynamic upBy;
  @JsonKey(defaultValue: '')
  final String isActive;

  const LanguageResponse({
    required this.plant,
    required this.id,
    required this.language,
    required this.crAt,
    required this.crBy,
    this.upAt,
    this.upBy,
    required this.isActive,
  });

  factory LanguageResponse.fromJson(Map<String, dynamic> json) =>
      _$LanguageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LanguageResponseToJson(this);
}
