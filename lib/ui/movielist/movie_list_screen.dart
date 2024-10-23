import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:movi/ui/saved/saved_movies_screen.dart';
import 'package:movi/utils/shared_preference.dart';
import 'package:movi/utils/string.dart';

import '../../model/movie_list_response.dart';
import '../moviedetail/movie_detail_screen.dart';
import 'movie_list_cubit.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key, required this.isDarkMode, required this.onThemeChanged});

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  MovieListCubit movieListCubit = MovieListCubit();
  SharedPref sharedPref = SharedPref();
  TextEditingController searchQueryController = TextEditingController();
  bool _isSearching = false;
  String searchQuery = "Search query";
  RegExp numeric = RegExp(r'^-?[0-9]+$');

  @override
  void initState() {
    movieListCubit.getMovieList(name: "popular",year: "", context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => movieListCubit,
      child: Scaffold(
        appBar: AppBar(
            title: _isSearching
                ? _buildSearchField()
                : Text(CustomString.appBarMovieList,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
            actions: _buildActions()),
        body: BlocConsumer<MovieListCubit, MovieListState>(
          listener: (context, state) {
            if (state is AuthError) {
              var snackBar = SnackBar(content: Text(state.message));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is LoadData) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieListData) {
              return Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: state.movieListResponse.search != null
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 300,
                                mainAxisSpacing: 20),
                        itemCount: state.movieListResponse.search!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, MovieDetailScreen.routeName,
                                  arguments: {
                                    "imdbId":
                                        state.movieListResponse.search![index]
                                  });
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: SizedBox(
                                    height: 200,
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            state.movieListResponse
                                                .search![index].poster!,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: InkWell(
                                            onTap: () async {
                                              List<Search> savedMovie =
                                                  await sharedPref
                                                      .getSavedMovie();
                                              if (savedMovie.any((element) =>
                                                  element.imdbID ==
                                                  state.movieListResponse
                                                      .search![index].imdbID)) {
                                                var snackBar = const SnackBar(
                                                    content: Text(
                                                        "Item already wishListed."));
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                return;
                                              }
                                              savedMovie.add(state
                                                  .movieListResponse
                                                  .search![index]);
                                              sharedPref
                                                  .setSavedMovie(savedMovie);
                                              var snackBar = const SnackBar(
                                                  content: Text(
                                                      "Item added to wishList."));
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30))),
                                              padding: const EdgeInsets.all(5),
                                              child: const Icon(Icons.favorite,
                                                  color: Colors.red, size: 15),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  state.movieListResponse.search![index].title!,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                RatingStars(
                                  starSize: 10,
                                  starCount: 5,
                                  starColor: Colors.yellow.shade700,
                                  starOffColor: Colors.yellow.shade700.withOpacity(0.5),
                                  value: 4.5,
                                  valueLabelColor: Colors.yellow.shade700,
                                ),
                                Text(
                                  state.movieListResponse.search![index].year!,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text("No Data To Show",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18)),
                      ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchQueryController,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search Data...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.black),
      ),
      style: const TextStyle(color: Colors.black, fontSize: 16.0),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      IconButton(
        onPressed: _startSearch,
        icon: const Icon(Icons.search),
      ),
      Switch(
        value: widget.isDarkMode,
        onChanged: (_newValue) {
          widget.onThemeChanged(_newValue); // Callback to change the theme
        },
      ),
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, SavedMovieScreen.routeName);
        },
        icon: const Icon(Icons.favorite),
        color: Colors.red,
      ),
    ];
  }

  void _startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching));
    setState(() {
      _isSearching = true;
    });
  }

  void updateSearchQuery(String newQuery) {
    setState(() {
      searchQuery = newQuery;
    });
    if (searchQuery.length > 2) {
      if(numeric.hasMatch(searchQuery)){
        movieListCubit.getMovieList(
            name: "", year: searchQuery, context: context);
      }else {
        movieListCubit.getMovieList(
            name: searchQuery, year: "", context: context);
      }
    }
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
    });
  }

  void _clearSearchQuery() {
    setState(() {
      searchQueryController.clear();
      updateSearchQuery("");
    });
  }
}
