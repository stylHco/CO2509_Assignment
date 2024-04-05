import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apiServices.dart';
import 'constands.dart';
import 'moreInfoPage.dart';



class ListContent extends StatefulWidget {
  ListContent({super.key, required this.inputListType, required this.inputItemType});
  late String inputItemType;
  ListType inputListType;
  @override
  State<StatefulWidget> createState() {
    return ListContentState(listType: inputListType, itemType: inputItemType);
  }

}


class ListContentState extends State<ListContent> {

  ListContentState({required this.listType, required this.itemType});
  late ListType listType;
  late String itemType;

  bool dataIsLoading = false;

  // late List<dynamic> itemList = [];
  late List<List<dynamic>> allItemList = [];
  late List<int>  idsList = [];

  @override
  void initState() {
    super.initState();
    progressOfFetchData();
  }


  Future<void> getItem(List<dynamic> list, String url) async {
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


   Future<List<int>> getIDs() async {
     List<int> numbersList = [];
     final FirebaseAuth auth = FirebaseAuth.instance;
     String userId = auth.currentUser!.uid;
     final ref = FirebaseDatabase.instance.ref('users/$userId/lists/$itemType/${listType.toString().split('.').last}');

     final snapshot = await ref.get();
     if (snapshot.exists) {
       Map<dynamic, dynamic>? mapData = snapshot.value as Map?;
       if (mapData != null) {
         numbersList = mapData.keys.map((key) => int.parse(key)).toList();
       }
     }

     return numbersList;

   }



  Future<void> progressOfFetchData() async{

    setState(() {
      dataIsLoading = true;
      allItemList.clear();
    });

    idsList = await getIDs();

    for (int i=0;i<idsList.length;i++){
      late List<dynamic> itemList = [];
      // if its not a movie then try the link for the tv series
      if (itemType == "tv"){
        await getItem(itemList, '$tvSeriesDetailsURL/${idsList[i]}');
      }
      else{
        await getItem(itemList, '$movieDetailsURL/${idsList[i]}');
      }

      allItemList.add(itemList);

    }



    setState(() {
      dataIsLoading = false;
    });


  }



  Future<void> removeItem(int id,BuildContext context) async {
    List<int> numbersList = [];
    final FirebaseAuth auth = FirebaseAuth.instance;
    String userId = auth.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('users/$userId/lists/$itemType/${listType.toString().split('.').last}/$id');

    print("here");


    try{
      await ref.remove();
      await progressOfFetchData();
    }catch(e){
      showDialog(
          context: context,
          builder: (_)
          {
            return AlertDialog(
              title: const Text('Cannot Remove The Item'),
              content:
              Container(
                child: Text(
                    "Something Went Wrong... Try again"
                ),
              ),
              actions: [
                TextButton(
                  onPressed: Navigator
                      .of(context)
                      .pop,
                  child: const Text('OK'),
                )
              ],
            );
          }
      );
    }

  }


  void removeItemFromList(int id) {
    removeItem(id, context);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('MOVIES-LIST'),
        ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "${itemType.toUpperCase()}  /  ${listType.toString().split('.').last.toUpperCase()}",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            const SizedBox(height: 25),
            if (dataIsLoading)
              Center(child: CircularProgressIndicator())

            else if (!dataIsLoading && allItemList.isEmpty)
              Center(child: Text(
                "You have no items in the list",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                ),
              ))
            else
            Flexible(
              child: MoviesList(allItemList: allItemList,itemType: itemType, removeItemCallback: removeItemFromList,),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.teal[100],
    );
  }


}


class MoviesList extends StatelessWidget {
  final List<List<dynamic>> allItemList;

  const MoviesList({required this.allItemList,required this.itemType ,Key? key, required this.removeItemCallback}) : super(key: key);

  final String itemType;

  final Function(int) removeItemCallback;


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: ListView.builder(
        itemCount: allItemList.length,
        itemBuilder: (context, index) {
          return Column(
            children: allItemList[index].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.tealAccent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.tealAccent, width: 3),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MoreInfoPage(inputId: item['id'], inputType: itemType)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 150,
                          width: 150,
                          child: Stack(
                            children: <Widget>[
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
                          child: Column(
                            children: [
                              Padding(
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
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                margin: EdgeInsets.only(top: 20),
                                // alignment: Alignment.topLeft,
                                child: ElevatedButton(
                                  onPressed: (){
                                    removeItemCallback(item['id']);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red
                                  ),
                                  child: Icon(Icons.close),
                                ),
                              )
                            ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}




