// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'author_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthorResponse _$AuthorResponseFromJson(Map<String, dynamic> json) =>
    AuthorResponse(
      plant: json['plant'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      author: json['author'] as String? ?? '',
      crAt: json['crAt'] as String? ?? '',
      crBy: json['crBy'] as String? ?? '',
      upAt: json['upAt'],
      upBy: json['upBy'],
      isActive: json['isActive'] as String? ?? '',
    );

Map<String, dynamic> _$AuthorResponseToJson(AuthorResponse instance) =>
    <String, dynamic>{
      'plant': instance.plant,
      'id': instance.id,
      'author': instance.author,
      'crAt': instance.crAt,
      'crBy': instance.crBy,
      'upAt': instance.upAt,
      'upBy': instance.upBy,
      'isActive': instance.isActive,
    };
