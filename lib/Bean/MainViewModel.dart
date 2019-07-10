import 'package:json_annotation/json_annotation.dart';

part 'MainViewModel.g.dart';

@JsonSerializable()
class Subjects{

  Subjects(this.rating, this.genres, this.title, this.casts, this.durations, this.collect_count, this.mainland_pubdate,
      this.has_video, this.original_title, this.subtype, this.directors, this.pubdates, this.year, this.images, this.alt,
      this.id);

  final Rating rating;
  final List<String> genres;
  final String title;
  final List<Casts> casts;
  final List<String> durations;
  final int collect_count;
  final String mainland_pubdate;
  final bool has_video;
  final String original_title;
  final String subtype;
  final List<Casts> directors;
  final List<String> pubdates;
  final String year;
  final Map <String, String>images;
  final String alt;
  final String id;

  factory Subjects.fromJson(Map<String, dynamic> json) => _$SubjectsFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectsToJson(this);
}

@JsonSerializable()
class Rating{

  Rating(this.max, this.average, this.details, this.starts, this.min);
  final int max;
  final double average;
  final Map details;
  final String starts;
  final int min;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}


@JsonSerializable()
class Casts{
  Casts(this.avatars, this.name_en, this.name, this.alt, this.id);
  final Map avatars;
  final String name_en;//": "Tom Holland",
  final String name;//": "汤姆·赫兰德",
  final String alt;//": "https://movie.douban.com/celebrity/1325351/",
  final String id;//": "1325351"

  factory Casts.fromJson(Map<String, dynamic> json) => _$CastsFromJson(json);

  Map<String, dynamic> toJson() => _$CastsToJson(this);
}