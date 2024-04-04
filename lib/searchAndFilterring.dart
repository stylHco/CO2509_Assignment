//
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'constands.dart';
//
// class searchAdFilterUI extends StatelessWidget {
//   final List<dynamic> itemList;
//
//   const searchAdFilterUI({required this.itemList, Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: SearchAnchor(
//             builder: (BuildContext context, SearchController controller) {
//               return SearchBar(
//                   controller: controller,
//                   padding: const MaterialStatePropertyAll<EdgeInsets>(
//                     EdgeInsets.symmetric(horizontal: 16.0)
//                   )
//                   onTap: () {
//                 controller.openView();
//               },
//               onChanged: (_) {
//               controller.openView();
//               },
//               leading: const Icon(Icons.search),
//               )
//             },
//           )
//
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: 50, // Example list size
//             itemBuilder: (context, index) {
//               // Example list item
//               return ListTile(
//                 title: Text('Item $index'),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
// }
//
