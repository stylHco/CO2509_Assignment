import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apiServices.dart';
import 'constands.dart';
import 'moreInfoPage.dart';

// this page is very similar with the tv series page and the peruse
// is to search and display movies

class MoviesPage extends StatefulWidget {
  const MoviesPage({Key? key}) : super(key: key);

  @override
  _MoviesPageState createState() => _MoviesPageState();
}

class _MoviesPageState extends State<MoviesPage> {
  late List moviesList = [];


  String searchedQuery = "";

  bool dataIsLoading = false;
  // check so the message is different before the first search
  bool showInitialMessage = true;

  @override
  void initState() {
    super.initState();
  }


  // this function is to replicate the progress of fetched data. first loading
  // then fetched and so the loading stop.

  Future <void> progressOfFetchData() async{

    setState(() {
      dataIsLoading = true;
      // search is attempted so i cannot show initial message
      showInitialMessage = false;
    });

    getData(moviesList,"$moviesSearchURL?query=$searchedQuery");

    setState(() {
      dataIsLoading = false;
    });


  }



  // this function empty the list and use the url and api call
  // to fill it with the data
  void getData(List list, String url) async {
    try {
      final List fetchedData = await ApiService.fetchListOfData(url);
      setState(() {
        list.clear();
        list.addAll(fetchedData);
      });
    } catch (error) {
      if (kDebugMode) {
        print('Error: $error');
      }
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchedQuery = query;
    });
    progressOfFetchData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            SearchBarApp(onSubmitted: updateSearchQuery),
            const SizedBox(height: 25),
            Flexible(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  if (showInitialMessage)
                    Center(child: Text(
                    "Search for movies",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ))
                  else if (dataIsLoading)
                    Center(child: CircularProgressIndicator())

                  else if (!dataIsLoading && moviesList.isEmpty)
                    Center(child: Text(
                      "No mutching results found...",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ))
                  else
                    MoviesList(itemList: moviesList),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBarApp extends StatelessWidget {
  final Function(String) onSubmitted;

  const SearchBarApp({required this.onSubmitted, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: SearchBar(
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 15.0),
              ),
              leading: const Icon(Icons.search),
              onSubmitted: onSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}

class MoviesList extends StatelessWidget {
  final List itemList;

  const MoviesList({required this.itemList, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: itemList.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Container(
            margin: EdgeInsets.all(15),
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
                // border: Border.all(color: Colors.tealAccent, width: 3)
            ),
            child: Column(
              children:<Widget>[
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
                      MaterialPageRoute(builder: (context) =>  MoreInfoPage(inputId: item['id'], inputType: "movie",)),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: <Widget>[
                      Container(
                        // this ensures that every image has the same size
                        // and at the same time maintain its aspect ratio
                        height: 150,
                        width: 150,
                        child: Stack(
                          children:<Widget> [
                            Positioned.fill(
                              child: Image.network(
                                backdropPathURL + (item['backdrop_path'] ?? ''),
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    logoUrl,
                                    height: 250.0,
                                    width: 250.0,
                                  );
                                },
                              ),
                            ),
                            // a tint to the bottom half of the image to make the text visible
                            // for the linear gradient i used this website https://api.flutter.dev/flutter/painting/LinearGradient-class.html
                            Positioned.fill(
                              bottom: 0.0,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.7),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 10.0,
                              left: 10.0,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "${item['vote_average']} ",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 15.0,
                                  ),
                                  Text(
                                    "  |   ${item['vote_count']}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 25.0),
                          child: Text(
                            "${item['name'] ?? item['title'] ?? 'Title not found'}  ${item['first_air_date'] != null ? DateTime.parse(item['first_air_date']).year : ''}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        );
      }).toList(),
    );
  }
}
