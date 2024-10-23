part of 'movie_list_cubit.dart';

sealed class MovieListState extends Equatable {

  const MovieListState();

  @override
  List<Object> get props => [];
}

final class MovieListStateInitial extends MovieListState {

  const MovieListStateInitial();
}

class LoadData extends MovieListState{

  const LoadData();
}

class MovieListData extends MovieListState{

  const MovieListData(this.movieListResponse);

  final MovieListResponse movieListResponse;

  @override
  List<Object> get props => [movieListResponse];
}

class AuthError extends MovieListState{

  const AuthError(this.message);

  final String message;

  @override
  List<String> get props => [message];
}