import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'constands.dart';


class ApiService {

  static Future<List<dynamic>> fetchListOfData(String apiUrl) async {

    var url = Uri.parse(apiUrl);

    try {
      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var results = jsonData['results'];
        // in some cases the response has result and i want the results.
        // in some other cases the response does not have result
        // and  i want all the content. so this code check if results is null
        // and then get all the data from json data
        results ??= [jsonData];

        return results != null ? List.from(results) : [];
      } else {
        throw Exception('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error during request: $error');
    }
  }
}
