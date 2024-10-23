import 'dart:async';

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../model/movie_detail_response.dart';
import '../model/movie_list_response.dart';
import 'my_api_utils.dart';

part 'my_api_client.g.dart';

@RestApi(baseUrl: MyApiUtils.baseUrl)
abstract class MyApiClient {
  factory MyApiClient(Dio dio, {String baseUrl}) = _MyApiClient;

  //For User detail from username
  @GET("")
  Future<MovieListResponse> movieList(@Query("apikey") String apikey, @Query("s") String s,@Query("y") String year);

  @GET("")
  Future<MovieDetailResponse> movieDetail(@Query("apikey") String apikey, @Query("i") String imdb);
}