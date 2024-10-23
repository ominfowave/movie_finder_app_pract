import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_repo.dart';
import '../../api/my_api_utils.dart';
import '../../model/movie_detail_response.dart';

part 'movie_detail_state.dart';

class MovieDetailCubit extends Cubit<MovieDetailState> {

  MovieDetailCubit() : super(const MovieDetailStateInitial());

  Future<MovieDetailResponse?> getMovieDetails({
    required String imdb,
    required BuildContext context,
  }) async {
    MovieDetailResponse? movieDetailResponse;
    emit(const LoadData());
    await ApiRepo(MyApiUtils.baseUrl).getMovieDetail(
        MyApiUtils.apiKey, imdb, (error) {
      emit(AuthError(error));
    }, (resp) {
      if (resp is MovieDetailResponse) {
        emit(MovieDetailData(resp));
        movieDetailResponse = resp;
      } else {
        emit(const AuthError("Response not proper"));
      }
    });
    return movieDetailResponse;
  }
}
