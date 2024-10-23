import 'package:flutter/material.dart';
import 'package:movi/ui/saved/saved_movies_screen.dart';

import 'ui/moviedetail/movie_detail_screen.dart';
import 'ui/movielist/movie_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  final ThemeData _darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark);
  final ThemeData _lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      useMaterial3: true,
      brightness: Brightness.light);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? _darkTheme : _lightTheme,
      home: MovieListScreen(
        isDarkMode: isDarkMode,
        onThemeChanged: (bool newValue) {
          setState(() {
            isDarkMode = newValue;
          });
        },

      ),
      routes: {
        MovieDetailScreen.routeName: (context) => const MovieDetailScreen(),
        SavedMovieScreen.routeName: (context) => const SavedMovieScreen()
      },
    );
  }
}
