import 'package:co2509_assignment/constands.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apiServices.dart';
import 'homePage.dart';
import 'listContentPage.dart';


class ListsPage extends StatefulWidget {
  const ListsPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return ListsPageState();
  }

}


class ListsPageState extends State<ListsPage>{

  late List<dynamic> itemsList = [];

  late ListType listType;

  bool itemIsLoading = false;

  @override
  void initState() {
    super.initState();
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
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                    children: [
                      Text(
                        "Lists",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                ),
              ),
              Container(
                child: Column(
                  children: [
                    ExpansionTile(
                      title: Text(
                        "MOVIES"
                      ),

                      children: <Widget>[
                        ListTile(
                          title: TextButton(
                            style: ButtonStyle(
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  ListContent(inputItemType: 'movie',inputListType: ListType.favorites ,)),
                              );
                            },
                            child: Text(
                              "Favorites"
                            ),
                          )
                        ),
                        ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  ListContent(inputItemType: 'movie',inputListType: ListType.watched ,)),
                                );
                              },
                              child: Text(
                                  "Watched"
                              ),
                            )
                        ),
                        ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  ListContent(inputItemType: 'movie',inputListType: ListType.planToWatch ,)),
                                );
                              },
                              child: Text(
                                  "PlanToWatch"
                              ),
                            )
                        )
                      ],
                    ),
                    ExpansionTile(
                      title: Text(
                          "TV SERIES"
                      ),

                      children: <Widget>[
                        ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  ListContent(inputItemType: 'tv',inputListType: ListType.favorites ,)),
                                );
                              },
                              child: Text(
                                  "Favorites"
                              ),
                            )
                        ),
                        ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  ListContent(inputItemType: 'tv',inputListType: ListType.watched ,)),
                                );
                              },
                              child: Text(
                                  "Watched"
                              ),
                            )
                        ),
                        ListTile(
                            title: TextButton(
                              style: ButtonStyle(
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  ListContent(inputItemType: 'tv',inputListType: ListType.planToWatch ,)),
                                );
                              },
                              child: Text(
                                  "PlanToWatch"
                              ),
                            )
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.teal[100]
    );
  }

}



