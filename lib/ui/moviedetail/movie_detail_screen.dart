import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:movi/utils/shared_preference.dart';

import '../../model/movie_list_response.dart';
import 'movie_detail_cubit.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({super.key});

  static const String routeName = "/movie_detail_screen";

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Search movieItem = Search();
  MovieDetailCubit movieDetailCubit = MovieDetailCubit();
  bool isFirst = true;
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    movieItem = arguments["imdbId"];
    if (isFirst) {
      movieDetailCubit.getMovieDetails(imdb: movieItem.imdbID!, context: context);
      setState(() {
        isFirst = false;
      });
    }
    return BlocProvider(
      create: (context) => movieDetailCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Movie Detail", style: TextStyle(fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () async {
                  List<Search> savedMovie =
                      await sharedPref.getSavedMovie();
                  if (savedMovie.any((element) =>
                  element.imdbID == movieItem.imdbID)) {
                    var snackBar = const SnackBar(
                        content: Text(
                            "Item already wishListed."));
                    ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                    return;
                  }
                  savedMovie.add(movieItem);
                  sharedPref.setSavedMovie(savedMovie);
                  var snackBar = const SnackBar(
                      content: Text(
                          "Item added to wishList."));
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar);
                },
                icon: const Icon(Icons.favorite),
                color: Colors.red,
              )
            ]
        ),
        body: BlocConsumer<MovieDetailCubit, MovieDetailState>(
          listener: (context, state) {
            if (state is AuthError) {
              var snackBar = SnackBar(content: Text(state.message));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            if (state is LoadData) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailData) {
              return Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title of movie
                      Text(
                        state.movieDetailResponse.title!,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "${state.movieDetailResponse.year!} • ",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                "${state.movieDetailResponse.rated!} • ",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                state.movieDetailResponse.runtime!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                          Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Colors.black)),
                              padding: const EdgeInsets.all(5),
                              child: Text(state.movieDetailResponse.type!)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // poster
                      SizedBox(
                        height: 200,
                        width: MediaQuery.sizeOf(context).width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            state.movieDetailResponse.poster!,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // more info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 150,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                state.movieDetailResponse.poster!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.black)),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(state.movieDetailResponse.genre!)),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  state.movieDetailResponse.plot!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 5,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 15),
                      // rating
                      RatingStars(
                        starSize: 18,
                        starCount: 5,
                        starColor: Colors.yellow.shade700,
                        starOffColor: Colors.yellow.shade700.withOpacity(0.5),
                        value: 4.5,
                        valueLabelColor: Colors.yellow.shade700,
                      ),
                      const SizedBox(height: 15),
                      // director
                      const Divider(
                        height: 2,
                        color: Colors.black,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      RichText(text: TextSpan(
                          text: "Director  ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            color: Colors.black
                          ),
                        children: [
                          TextSpan(
                              text: state.movieDetailResponse.director!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ]
                      )),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 2,
                        color: Colors.black,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      RichText(text: TextSpan(
                          text: "Writer     ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: state.movieDetailResponse.writer!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ]
                      )),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 2,
                        color: Colors.black,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      RichText(text: TextSpan(
                          text: "Stars       ",

                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.black
                          ),
                          children: [
                            TextSpan(
                              text: state.movieDetailResponse.actors!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ]
                      )),
                      const SizedBox(height: 10),
                      const Divider(
                        height: 2,
                        color: Colors.black,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "Meta Score",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                              Text(
                                state.movieDetailResponse.metaScore!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "IMDB Ratings",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                              Text(
                                state.movieDetailResponse.imdbRating!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              const Text(
                                "IMDB Votes",
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                              Text(
                                state.movieDetailResponse.imdbVotes!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
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
}
