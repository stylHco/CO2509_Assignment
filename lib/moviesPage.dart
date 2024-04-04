import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apiServices.dart';
import 'constands.dart';
import 'searchAndFilterring.dart';

class MoviesPage extends StatefulWidget {
  const MoviesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return MoviesPageState();
  }

}



class MoviesPageState extends State<MoviesPage>{

  late List<dynamic> moviesList = [];
  late List<dynamic> genresList = [];

  static String searchedTitle = "";


  @override
  void initState() {
    super.initState();

    getData(moviesList, "$moviesSearchURL/?query=ded");
    getData(genresList, moviesGenres);

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
          child: Column(
            children:<Widget>[
              const SizedBox(height: 25,),
              Container(
                  child: SearchBarApp()
              ),
              const SizedBox(height: 25,),
              Flexible(
                 child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    // if (moviesList.isEmpty)
                    //   Center(child: CircularProgressIndicator())
                    // else
                      MoviesList(itemList: moviesList),
                    const SizedBox(height: 25,),
                    ],
                 ),
              ),
            ]
          )
        ),

        backgroundColor: Colors.teal[100]
    );
  }
}


class MoviesList extends StatelessWidget {
  final List<dynamic> itemList;

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
                color: Colors.tealAccent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.tealAccent, width: 3)
            ),
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
        );
      }).toList(),
    );
  }
}


class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => searchAdFilterUI();
}

class searchAdFilterUI extends State<SearchBarApp>  {

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Center(
          child:   SearchBar(
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 15.0)),

                  leading: const Icon(Icons.search),
            onChanged: (value) {
              setState(() {
                MoviesPageState.searchedTitle = value;
              });
            },
                )
        ),
        Text('Search Query: ${MoviesPageState.searchedTitle}'),
    ]
      );
  }
}
