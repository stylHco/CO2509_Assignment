import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'constands.dart';
import 'apiServices.dart';

import 'package:firebase_database/firebase_database.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  // fetchedData = '';

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}


class HomePageState extends State<HomePage>{

  late List<dynamic> playingNowTVSeries = [];

  late List<dynamic> playingNowTVSeriesImg = [];

  late List<dynamic> playingNowMovies = [];
  late List<dynamic> topRatedMovies = [];
  late List<dynamic> upcomingMovies = [];
  late List<dynamic> popularTVSeries = [];
  late List<dynamic> topRatedTVSeries = [];

  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    getData(playingNowTVSeries, playingNowTVSeriesURL);
    getData(playingNowMovies, playingNowMoviesURL);
    getData(topRatedMovies, topRatedMoviesURL);
    getData(upcomingMovies, upcomingMoviesURL);
    getData(popularTVSeries, popularTVSeriesURL);
    getData(topRatedTVSeries, topRatedTVSeriesURL);
  }

  void getData(List<dynamic> list, String url) async {
    try {
      final List<dynamic> fetchedData = await ApiService.fetchListOfData(url);
      setState(() {
        list.clear(); // Clear the existing content
        list.addAll(fetchedData); // Add the new data
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  BoxTitles(
                    title:"TV SERIES"
                  ),
                  CarouselTile(title: 'Playing Now TV Series', movies: playingNowTVSeries),
                  CarouselTile(title: 'Popular TV Series', movies: popularTVSeries),
                  CarouselTile(title: 'Top Rated TV Series', movies: topRatedTVSeries),
                  const SizedBox(height: 25,),
                  BoxTitles(
                    title:"MOVIES"
                  ),
                  CarouselTile(title: 'Playing Now Movies', movies: playingNowMovies),
                  CarouselTile(title: 'Top Rated Movies', movies: topRatedMovies),
                  CarouselTile(title: 'Upcoming Movies', movies: upcomingMovies),
                  const SizedBox(height: 25,),
                ],
              ),
      ),
        backgroundColor: Colors.teal[100]
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100,
        padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
        child: Text('',
            style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold)
                    ),
    );
  }
}

class BoxTitles extends StatelessWidget {
  final String title;
  BoxTitles({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = const TextStyle(
        fontSize: 18.0,
        color: Colors.black54,
        fontWeight: FontWeight.w600,
    );

    return Container(
      decoration: const BoxDecoration(color: Colors.tealAccent),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Text(
        title.toString(),
        style: textStyle,
      ),
    );
  }
}

class CarouselHomePage extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();

  late List<dynamic>  itemList;



  CarouselHomePage({required this.itemList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      CarouselSlider(
        items: itemList.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      // this ensures that every image has the same size
                      // and at the same time maintain ist aspect ratio
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.network(
                                backdropPathURL + item['backdrop_path']??'', // Text content
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    logoUrl,
                                    height: 250.0,
                                    width: 250.0,
                                  );
                                }
                            ),
                          ),
                          // a tint to the bottom half of the image to make the text visible
                          // for the linear gradient i used this website https://api.flutter.dev/flutter/painting/LinearGradient-class.html
                          Positioned.fill(
                            bottom: 0.0,
                              child: Container(
                                decoration:  BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              )
                          ),
                          Positioned(
                            bottom: 10.0,
                            left: 10.0,
                            child: Row(
                              children: <Widget>[
                                Text(
                                  "${item['vote_average']} "
                                  , // Text content
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                Text(
                                  "  |   ${item['vote_count']}"
                                  , // Text content
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ]
                      ),
                    ),
                    const SizedBox(height: 5,),
                    Expanded(
                      // padding: EdgeInsets.all(1.3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Builder(
                          builder: (BuildContext context) {
                            // decide which title to display based on movies or tv series
                            String title = item['name'] ?? item['title'] ?? 'Title not found';

                           // decide which year to display based on movies or tv series
                            String year = '';
                            if (item['release_date'] != null) {
                              year = "${DateTime.parse(item['release_date']).year}";
                            } else if (item['first_air_date'] != null) {
                              year = "${DateTime.parse(item['first_air_date']).year}";
                            }

                            // Combine title/name and year
                            String displayText = "$title $year".trim(); // Trim to remove any trailing spaces

                            return Text(
                              displayText,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        // child: Column(
                        //   children:[
                        //     if (item['name'] != null)
                        //     Text(
                        //       "${item['name']}  ${item['first_air_date'] != null ? DateTime.parse(item['first_air_date']).year : ''}"
                        //       ,
                        //       textAlign: TextAlign.left,// Text content
                        //       style: const TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 20.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     )
                        //     else  if (item['title'] != null)
                        //       Text(
                        //         "${item['title']}  ${item['first_air_date'] != null ? DateTime.parse(item['first_air_date']).year : ''}"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )
                        //     else
                        //       const Text(
                        //         "Title not found"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     if (item['release_date'] != null)
                        //       Text(
                        //         "${DateTime.parse(item['release_date']).year}"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )
                        //     else if (item['first_air_date'] != null)
                        //       Text(
                        //         "${DateTime.parse(item['first_air_date']).year}"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )
                        //   ]
                        // ),
                      ),
                    ),
                    Expanded(
                      // padding: EdgeInsets.all(1.3),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Builder(
                          builder: (BuildContext context) {
                            // decide which title to display based on movies or tv series
                            String title = item['name'] ?? item['title'] ?? 'Title not found';

                            // decide which year to display based on movies or tv series
                            String year = '';
                            if (item['release_date'] != null) {
                              year = "${DateTime.parse(item['release_date']).year}";
                            } else if (item['first_air_date'] != null) {
                              year = "${DateTime.parse(item['first_air_date']).year}";
                            }

                            // Combine title/name and year
                            String displayText = "$title $year".trim(); // Trim to remove any trailing spaces

                            return Text(
                              displayText,
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        // child: Column(
                        //   children:[
                        //     if (item['name'] != null)
                        //     Text(
                        //       "${item['name']}  ${item['first_air_date'] != null ? DateTime.parse(item['first_air_date']).year : ''}"
                        //       ,
                        //       textAlign: TextAlign.left,// Text content
                        //       style: const TextStyle(
                        //         color: Colors.black,
                        //         fontSize: 20.0,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     )
                        //     else  if (item['title'] != null)
                        //       Text(
                        //         "${item['title']}  ${item['first_air_date'] != null ? DateTime.parse(item['first_air_date']).year : ''}"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )
                        //     else
                        //       const Text(
                        //         "Title not found"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       ),
                        //     if (item['release_date'] != null)
                        //       Text(
                        //         "${DateTime.parse(item['release_date']).year}"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )
                        //     else if (item['first_air_date'] != null)
                        //       Text(
                        //         "${DateTime.parse(item['first_air_date']).year}"
                        //         ,
                        //         textAlign: TextAlign.left,// Text content
                        //         style: const TextStyle(
                        //           color: Colors.black,
                        //           fontSize: 20.0,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //       )
                        //   ]
                        // ),
                      ),
                    ),
                  ],
                ),

              );
            },
          );
        }).toList(),
        carouselController: buttonCarouselController,
        options: CarouselOptions(
          autoPlay: false,
          enlargeCenterPage: false,
          aspectRatio: 2.0,
          initialPage: 0,
          height: 200,
          viewportFraction: 0.75, // Display 2 items at a time

        ),
      ),

    ],
  );
}

class CarouselTile extends StatelessWidget {
  const CarouselTile({super.key, required this.movies, required this.title});

  final List<dynamic> movies;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
                title,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold
                )
            ),
          ),
        ),
        CarouselHomePage(
          itemList: movies,
        )
      ],
    );
  }
}
