import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


import 'constands.dart';
import 'apiServices.dart';

import 'package:firebase_database/firebase_database.dart';

import 'moreInfoPage.dart';

// homepage
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}


class HomePageState extends State<HomePage>{

  // initialize the lists  before i use it
  late List playingNowTVSeries = [];

  late List playingNowTVSeriesImg = [];

  late List playingNowMovies = [];
  late List topRatedMovies = [];
  late List upcomingMovies = [];
  late List popularTVSeries = [];
  late List topRatedTVSeries = [];


  @override
  void initState() {
    // initialize all the list of items from the database using the links from the constands file
    super.initState();
    getData(playingNowTVSeries, playingNowTVSeriesURL);
    getData(playingNowMovies, playingNowMoviesURL);
    getData(topRatedMovies, topRatedMoviesURL);
    getData(upcomingMovies, upcomingMoviesURL);
    getData(popularTVSeries, popularTVSeriesURL);
    getData(topRatedTVSeries, topRatedTVSeriesURL);

  }

  void getData(List list, String url) async {
    try {
      final List fetchedData = await ApiService.fetchListOfData(url);
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



  // build the home page state widget

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
                  CarouselTile(title: 'Playing Now TV Series', list: playingNowTVSeries, listType: 'tv',),
                  const SizedBox(height: 15,),
                  CarouselTile(title: 'Popular TV Series', list: popularTVSeries, listType: 'tv',),
                  const SizedBox(height: 15,),
                  CarouselTile(title: 'Top Rated TV Series', list: topRatedTVSeries, listType: 'tv',),
                  const SizedBox(height: 25,),
                  BoxTitles(
                    title:"MOVIES"
                  ),
                  CarouselTile(title: 'Playing Now Movies', list: playingNowMovies, listType: 'movie',),
                  const SizedBox(height: 15,),
                  CarouselTile(title: 'Top Rated Movies', list: topRatedMovies, listType: 'movie',),
                  const SizedBox(height: 15,),
                  CarouselTile(title: 'Upcoming Movies', list: upcomingMovies, listType: 'movie',),
                  const SizedBox(height: 25,),
                ],
              ),
      ),
    );
  }

}
// custom box title configuration for the titles
class BoxTitles extends StatelessWidget {
  final String title;

  BoxTitles({Key? key, required this.title, }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      // decoration: const BoxDecoration(color: Colors.tealAccent),
      padding: const EdgeInsets.all(16.0),
      width: MediaQuery.of(context).size.width,
      child: Text(
        title.toString(),
        style:  TextStyle(
          fontSize: 18.0,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// carousel configurations
class CarouselHomePage extends StatelessWidget {
  CarouselController buttonCarouselController = CarouselController();

  late List<dynamic>  itemList;

  late String listType;

  CarouselHomePage({required this.itemList, required this.listType, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      CarouselSlider(
        items: itemList.map((item) {
          // make the  items into a list
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      // remove the colors from the button
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        elevation: 0, // this removes the shadow
                        padding: EdgeInsets.zero, // Remove padding
                      ),

                      onPressed: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  MoreInfoPage(inputId: item['id'], inputType: listType,)),
                        );
                      },
                      child: Container(
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
                        // ),
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
                                // color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
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
          // this is an effect to make the the center image bigger
          // emphasise to the center image but i disabled
          // it because cause some problems
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
  const CarouselTile({super.key, required this.list, required this.title, required this.listType});

  final List list;
  final String title;
  final String listType;

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

        // return loadable icon if the list is empty
        if (list.isEmpty)
          Center(child: CircularProgressIndicator())
        else
        CarouselHomePage(
          itemList: list,
          listType: listType,
        )
      ],
    );
  }
}
