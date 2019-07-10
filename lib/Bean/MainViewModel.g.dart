// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MainViewModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subjects _$SubjectsFromJson(Map<String, dynamic> json) {
  return Subjects(
      json['rating'] == null
          ? null
          : Rating.fromJson(json['rating'] as Map<String, dynamic>),
      (json['genres'] as List)?.map((e) => e as String)?.toList(),
      json['title'] as String,
      (json['casts'] as List)
          ?.map((e) =>
              e == null ? null : Casts.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['durations'] as List)?.map((e) => e as String)?.toList(),
      json['collect_count'] as int,
      json['mainland_pubdate'] as String,
      json['has_video'] as bool,
      json['original_title'] as String,
      json['subtype'] as String,
      (json['directors'] as List)
          ?.map((e) =>
              e == null ? null : Casts.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      (json['pubdates'] as List)?.map((e) => e as String)?.toList(),
      json['year'] as String,
      (json['images'] as Map<String, dynamic>)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      json['alt'] as String,
      json['id'] as String);
}

Map<String, dynamic> _$SubjectsToJson(Subjects instance) => <String, dynamic>{
      'rating': instance.rating,
      'geners': instance.genres,
      'title': instance.title,
      'casts': instance.casts,
      'durations': instance.durations,
      'collect_count': instance.collect_count,
      'mainland_pubdate': instance.mainland_pubdate,
      'has_video': instance.has_video,
      'original_title': instance.original_title,
      'subtype': instance.subtype,
      'directors': instance.directors,
      'pubdates': instance.pubdates,
      'year': instance.year,
      'images': instance.images,
      'alt': instance.alt,
      'id': instance.id
    };

Rating _$RatingFromJson(Map<String, dynamic> json) {
  return Rating(
      json['max'] as int,
      (json['average'] as num)?.toDouble(),
      json['details'] as Map<String, dynamic>,
      json['starts'] as String,
      json['min'] as int);
}

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'max': instance.max,
      'average': instance.average,
      'details': instance.details,
      'starts': instance.starts,
      'min': instance.min
    };

Casts _$CastsFromJson(Map<String, dynamic> json) {
  return Casts(
      json['avatars'] as Map<String, dynamic>,
      json['name_en'] as String,
      json['name'] as String,
      json['alt'] as String,
      json['id'] as String);
}

Map<String, dynamic> _$CastsToJson(Casts instance) => <String, dynamic>{
      'avatars': instance.avatars,
      'name_en': instance.name_en,
      'name': instance.name,
      'alt': instance.alt,
      'id': instance.id
    };
