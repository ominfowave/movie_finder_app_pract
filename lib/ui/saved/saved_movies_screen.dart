import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:movi/utils/shared_preference.dart';

import '../../model/movie_list_response.dart';
import '../../utils/string.dart';
import '../moviedetail/movie_detail_screen.dart';

class SavedMovieScreen extends StatefulWidget {
  const SavedMovieScreen({super.key});
  static const String routeName = "/saved_movie_screen";
  @override
  State<SavedMovieScreen> createState() => _SavedMovieScreenState();
}

class _SavedMovieScreenState extends State<SavedMovieScreen> {
  bool isLoading = true;
  SharedPref sharedPref = SharedPref();
  List<Search> savedMovieList = [];

  getSavedMovieList () async{
    savedMovieList = await sharedPref.getSavedMovie();
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    getSavedMovieList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(CustomString.appBarWishList,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SavedMovieScreen.routeName);
            },
            icon: const Icon(Icons.favorite),
            color: Colors.red,
          )
        ]),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 15),
        child: isLoading ? const Center(child: CircularProgressIndicator(),) :GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisExtent: 300,
              mainAxisSpacing: 20),
          itemCount: savedMovieList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.pushNamed(
                    context, MovieDetailScreen.routeName, arguments: {
                  "imdbId":
                  savedMovieList[index]
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
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              savedMovieList[index]
                                  .poster!,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Positioned(
                            right: 10,
                            bottom: 10,
                            child: InkWell(
                              onTap: () async {
                                List<Search> savedMovie = await sharedPref.getSavedMovie();
                                savedMovie.removeWhere((element) => element.imdbID == savedMovieList[index].imdbID);
                                sharedPref.setSavedMovie(savedMovie);
                                getSavedMovieList();
                                setState(() {});
                                var snackBar = const SnackBar(
                                    content: Text(
                                        "Item removed from wishList."));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
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
                    savedMovieList[index].title!,
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
                    savedMovieList[index].year!,
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
        ),
      ),
    );
  }
}
