part of 'movie_detail_cubit.dart';

sealed class MovieDetailState extends Equatable {

  const MovieDetailState();

  @override
  List<Object> get props => [];
}

final class MovieDetailStateInitial extends MovieDetailState {

  const MovieDetailStateInitial();
}

class LoadData extends MovieDetailState{

  const LoadData();
}

class MovieDetailData extends MovieDetailState{

  const MovieDetailData(this.movieDetailResponse);

  final MovieDetailResponse movieDetailResponse;

  @override
  List<Object> get props => [movieDetailResponse];
}

class AuthError extends MovieDetailState{

  const AuthError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}