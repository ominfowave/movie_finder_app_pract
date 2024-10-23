import 'package:dio/dio.dart';
import '../model/movie_detail_response.dart';
import '../model/movie_list_response.dart';
import '../utils/string.dart';
import '../utils/utils.dart';
import 'my_api_utils.dart';
import 'my_api_client.dart';

class ApiRepo {
  late MyApiClient apiClient;
  late MyApiUtils myApiUtils;
  late String baseUrl;

  // pass base url
  ApiRepo(String baseUrl) {
    BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 20),
      // 20 seconds
      receiveTimeout: const Duration(seconds: 20), // 90 seconds
    );
    Dio dio = Dio(options);
    apiClient = MyApiClient(dio, baseUrl: baseUrl);
  }

  // For Getting movie list
  getPopularMovieList(String apiKey,String s,String year, Function(String) onError,
      Function(dynamic) onSuccess) async {
    // check internet
    if (await Utils.isInternetConnected()) {
      try {
        MovieListResponse movieListResponse = await apiClient.movieList(apiKey,s,year);
        onSuccess(movieListResponse);
      } on DioException catch (e) {
        Utils.getErrorApi(e, onError);
      }
    } else {
      onError(CustomString.toastPleaseCheckYourInternet);
    }
  }

  // For Getting movie detail
  getMovieDetail(String apiKey,String imdb, Function(String) onError,
      Function(dynamic) onSuccess) async {
    // check internet
    if (await Utils.isInternetConnected()) {
      try {
        MovieDetailResponse movieDetailResponse = await apiClient.movieDetail(apiKey,imdb);
        onSuccess(movieDetailResponse);
      } on DioException catch (e) {
        Utils.getErrorApi(e, onError);
      }
    } else {
      onError(CustomString.toastPleaseCheckYourInternet);
    }
  }
}
