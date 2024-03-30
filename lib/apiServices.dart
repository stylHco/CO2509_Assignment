import 'dart:convert';
import 'package:http/http.dart' as http;


class ApiService {
  //static const String apiKey = 'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwNjAwMDFjNGM1MzZlMjlmMzBhNmExNDBlYWUzOTEwNSIsInN1YiI6IjY1YjExYjNmZGQ5MjZhMDE1MjRkMDMzZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ICnU5fWhhlyM9OSZFr_H4S73J2M_W-Y7gd5K62GC3tM';


  static Future<List<dynamic>> fetchData(String apiUrl) async {
    //var headers = {
      //'accept': 'application/json',
      //'Authorization': 'Bearer $apiKey',
    //};

    var url = Uri.parse(apiUrl);

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var results = jsonData['results']; // Assuming the data is inside 'results' field
        return results != null ? List.from(results) : [];
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during request: $error');
    }
  }
}



