import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../api/api_repo.dart';
import '../../api/my_api_utils.dart';
import '../../model/movie_list_response.dart';

part 'movie_list_state.dart';

class MovieListCubit extends Cubit<MovieListState> {

  MovieListCubit() : super(const MovieListStateInitial());

  Future<MovieListResponse?> getMovieList({
    required String name,
    required String year,
    required BuildContext context,
  }) async {
    MovieListResponse? movieListResponse;
    emit(const LoadData());
    await ApiRepo(MyApiUtils.baseUrl).getPopularMovieList(
        MyApiUtils.apiKey,
        name,year, (error) {
      emit(AuthError(error));
    }, (resp) {
      if (resp is MovieListResponse) {
        emit(MovieListData(resp));
        movieListResponse = resp;
      } else {
        emit(const AuthError("Response not proper"));
      }
    });
    return movieListResponse;
  }
}
