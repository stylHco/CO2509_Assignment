import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constands.dart';


class ApiService {

  static Future<List<dynamic>> fetchListOfData(String apiUrl) async {

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



