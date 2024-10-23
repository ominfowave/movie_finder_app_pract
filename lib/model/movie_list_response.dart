import 'package:json_annotation/json_annotation.dart';

part 'movie_list_response.g.dart';

@JsonSerializable()
class   MovieListResponse {
  @JsonKey(name: "Search")
  List<Search>? search;
  String? totalResults;
  @JsonKey(name: "Response")
  String? response;

  MovieListResponse({this.search, this.totalResults, this.response});

  factory MovieListResponse.fromJson(Map<String, dynamic> json) => _$MovieListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieListResponseToJson(this);
}

@JsonSerializable()
class Search {
  @JsonKey(name: "Title")
  String? title;
  @JsonKey(name: "Year")
  String? year;
  @JsonKey(name: "imdbID")
  String? imdbID;
  @JsonKey(name: "Type")
  String? type;
  @JsonKey(name: "Poster")
  String? poster;

  Search({this.title, this.year, this.imdbID, this.type, this.poster});

  factory Search.fromJson(Map<String, dynamic> json) => _$SearchFromJson(json);
  Map<String, dynamic> toJson() => _$SearchToJson(this);
}