import 'package:json_annotation/json_annotation.dart';

part 'movie_detail_response.g.dart';

@JsonSerializable()
class MovieDetailResponse {
  @JsonKey(name: "Title")
  String? title;
  @JsonKey(name: "Year")
  String? year;
  @JsonKey(name: "Rated")
  String? rated;
  @JsonKey(name: "Released")
  String? released;
  @JsonKey(name: "Runtime")
  String? runtime;
  @JsonKey(name: "Genre")
  String? genre;
  @JsonKey(name: "Director")
  String? director;
  @JsonKey(name: "Writer")
  String? writer;
  @JsonKey(name: "Actors")
  String? actors;
  @JsonKey(name: "Plot")
  String? plot;
  @JsonKey(name: "Language")
  String? language;
  @JsonKey(name: "Country")
  String? country;
  @JsonKey(name: "Awards")
  String? awards;
  @JsonKey(name: "Poster")
  String? poster;
  @JsonKey(name: "Ratings")
  List<Ratings>? ratings;
  @JsonKey(name: "Metascore")
  String? metaScore;
  String? imdbRating;
  String? imdbVotes;
  String? imdbID;
  @JsonKey(name: "Type")
  String? type;
  @JsonKey(name: "DVD")
  String? dVD;
  @JsonKey(name: "BoxOffice")
  String? boxOffice;
  @JsonKey(name: "Production")
  String? production;
  @JsonKey(name: "Website")
  String? website;
  @JsonKey(name: "Response")
  String? response;

  MovieDetailResponse({this.title,
    this.year,
    this.rated,
    this.released,
    this.runtime,
    this.genre,
    this.director,
    this.writer,
    this.actors,
    this.plot,
    this.language,
    this.country,
    this.awards,
    this.poster,
    this.ratings,
    this.metaScore,
    this.imdbRating,
    this.imdbVotes,
    this.imdbID,
    this.type,
    this.dVD,
    this.boxOffice,
    this.production,
    this.website,
    this.response});

  factory MovieDetailResponse.fromJson(Map<String, dynamic> json) => _$MovieDetailResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieDetailResponseToJson(this);

}

@JsonSerializable()
class Ratings {
  @JsonKey(name: "Source")
  String? source;
  @JsonKey(name: "Value")
  String? value;

  Ratings({this.source, this.value});

  factory Ratings.fromJson(Map<String, dynamic> json) => _$RatingsFromJson(json);
  Map<String, dynamic> toJson() => _$RatingsToJson(this);
}