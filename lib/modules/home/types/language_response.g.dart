// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'language_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LanguageResponse _$LanguageResponseFromJson(Map<String, dynamic> json) =>
    LanguageResponse(
      plant: json['plant'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      language: json['language'] as String? ?? '',
      crAt: json['crAt'] as String? ?? '',
      crBy: json['crBy'] as String? ?? '',
      upAt: json['upAt'],
      upBy: json['upBy'],
      isActive: json['isActive'] as String? ?? '',
    );

Map<String, dynamic> _$LanguageResponseToJson(LanguageResponse instance) =>
    <String, dynamic>{
      'plant': instance.plant,
      'id': instance.id,
      'language': instance.language,
      'crAt': instance.crAt,
      'crBy': instance.crBy,
      'upAt': instance.upAt,
      'upBy': instance.upBy,
      'isActive': instance.isActive,
    };
