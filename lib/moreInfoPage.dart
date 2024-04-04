import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apiServices.dart';
import 'constands.dart';






class MoreInfoPage extends StatefulWidget {
  MoreInfoPage({super.key, required this.inputId, required this.inputType});
  late int inputId;
  late String inputType;
  @override
  State<StatefulWidget> createState() {
    return MoreInfoPageState(id: inputId, type: inputType);
  }

}


class MoreInfoPageState extends State<MoreInfoPage> {

  MoreInfoPageState({required this.id, required this.type});
  late int id;
  late String type;


  late List<dynamic> itemList = [];

  @override
  void initState() {
  super.initState();


    // if its not a movie then try the link for the tv series
    if (type == "tv"){
      getItem(itemList, '$tvSeriesDetailsURL/$id');
    }
    else{
      getItem(itemList, '$movieDetailsURL/$id');
    }

    print(id);


  }


  void getItem(List<dynamic> list, String url) async {
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
        appBar: AppBar(
        title: Text('MOVIES-LIST'),
    ),
      body: itemList.isEmpty
          ? Center(child: CircularProgressIndicator())
          :
      Container(
        height: double.infinity,
        child: ListView.builder(
          itemCount: itemList.length,

          itemBuilder: (context, index) {
            return Container(
                child: Column(
                  children: [
                    Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Image.network(
                                backdropPathURL + itemList[index]['backdrop_path']??'', // Text content
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, StackTrace? stackTrace) {
                                  return Image.asset(
                                    logoUrl,
                                    fit: BoxFit.cover,
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
                                    "${itemList[index]['vote_average']} "
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
                                    "  |   ${itemList[index]['vote_count']}"
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
                    if (type == "tv")
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          // crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                          children: [
                            Text(
                              itemList[index]['number_of_seasons'] != null
                                  ? "S ${itemList[index]['number_of_seasons']}  |  "
                                  : "S -  |  "

                            ),
                            Text(
                                itemList[index]['number_of_episodes'] != null
                                      ? "E ${itemList[index]['number_of_episodes']}"
                                      : "E -",

                            ),
                          ]
                        ),
                      ),

                    Container(
                      margin: EdgeInsets.only(top: 30),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align children with space between
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                              children:[
                                Text(
                                  type == "tv" ? itemList[index]['name']??"" : itemList[index]['title']??"",
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 15,),
                                Text(
                                  type== "tv" ? itemList[index]['first_air_date']??"" : itemList[index]['release_date']??"",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ), // Circle shape
                                  ),
                                  onPressed: (){
                                     print("predef");
                                  },
                                  child: Icon(
                                    Icons.add
                                  )
                              )
                            ],
                          )
                        ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      margin: EdgeInsets.only(top: 30),
                      child: Wrap(
                        spacing: 15.0, // Space between each nested item
                        children: itemList[index]['genres'].map<Widget>((nestedItem) {
                          return Chip(
                            label: Text(nestedItem['name']),
                            // Add other properties as needed
                          );
                        }).toList(),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 40, bottom: 40),
                      padding: EdgeInsets.symmetric(horizontal: 20 ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Text(
                              "OVERVIEW",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            itemList[index]['overview'],
                            style: TextStyle(
                              fontSize: 15
                            ),
                          )
                        ],
                      ),
                    )
                  ]
                ),
            );
          },
        ),
      ),
    );
  }


}