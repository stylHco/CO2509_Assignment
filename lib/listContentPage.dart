import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'apiServices.dart';
import 'constands.dart';
import 'moreInfoPage.dart';

// this page is the content of the lists. each list (favorites, watched...)
// calls this page to represent its data.


class ListContent extends StatefulWidget {
  ListContent({super.key, required this.inputListType, required this.inputItemType});
  // item type means movie or tv

  late String inputItemType;

  // list type is each list favorite watched and plan to watch
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

  late List<List> allItemList = [];
  late List<int>  idsList = [];

  @override
  void initState() {
    super.initState();
    progressOfFetchData();
  }


  // fill the list from the api
  Future<void> getItem(List list, String url) async {
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



  // get all the id of the items for that list (e.g. movie and favorites ) for
  // a specific user from the firebase.
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


   // this function is to say simulate the process of fetching
  // the data loading fetching and stop loading. so we know when
  // to display the loading animation

  Future<void> progressOfFetchData() async{

    setState(() {
      dataIsLoading = true;
      allItemList.clear();
    });

    idsList = await getIDs();

    for (int i=0;i<idsList.length;i++){
      late List itemList = [];
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


// this function removes item from the firebase and then calls the list again

  Future<void> removeItem(int id,BuildContext context) async {
    List<int> numbersList = [];
    final FirebaseAuth auth = FirebaseAuth.instance;
    String userId = auth.currentUser!.uid;
    final ref = FirebaseDatabase.instance.ref('users/$userId/lists/$itemType/${listType.toString().split('.').last}/$id');

    print("here");


    try{
      await ref.remove();
      // call again the firebase so update the ui
      await progressOfFetchData();
    }catch(e){
      showDialog(
          context: context,
          builder: (_)
          {
            // modal if somethig is wrong
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

  // call back function
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
            // still fetching data so show load
            if (dataIsLoading)
              Center(child: CircularProgressIndicator())

              // the api fetched nothing
            else if (!dataIsLoading && allItemList.isEmpty)
              Center(child: Text(
                "You have no items in the list",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                ),
              ))

              // the data in a flexible
            else
            Flexible(
              child: MoviesList(allItemList: allItemList,itemType: itemType, removeItemCallback: removeItemFromList,),
            ),
          ],
        ),
      ),
    );
  }


}


// put all the data in the list format

class MoviesList extends StatelessWidget {
  final List<List> allItemList;

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
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Theme.of(context).primaryColor, width: 3),
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
                                // because movies has names and tv has title check if any of
                                // those exists and prints it and if both of them are null
                                // then means there is not title
                                "${item['name'] ?? item['title'] ?? 'Title not found'}  ${item['first_air_date'] != null ? DateTime.parse(item['first_air_date']).year : ''}",
                                textAlign: TextAlign.left,
                                style:  TextStyle(
                                  color: Theme.of(context).primaryColorDark,
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




