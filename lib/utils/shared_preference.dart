import 'dart:convert';

import 'package:movi/model/movie_list_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SharedPref{
  final String savedMovies = "KEY_SAVED_MOVIES"; // store saved movies
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void setSavedMovie(List<Search> savedUser)async{
    final SharedPreferences prefs = await _prefs;
    prefs.setString(savedMovies, jsonEncode(savedUser));
  }

  Future<List<Search>> getSavedMovie() async{
    final SharedPreferences prefs = await _prefs;
    List<dynamic> list = jsonDecode(prefs.getString(savedMovies)!);
    List<Search> savedMovie = [];
    for(var item in list){
      savedMovie.add(Search.fromJson(item));
    }
    return savedMovie;
  }
}