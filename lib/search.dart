import 'package:http/http.dart' as http;
import 'constands.dart';
import 'dart:convert';

class SearchMulti {

  Future<List?> search (String query) async {
    final String url = 'https://api.themoviedb.org/3/search/multi?';

    final http.Response response = await http.get(Uri.parse('${url}query=${query}'), headers: headers);

    try {
      final List results = json.decode(response.body)['results'];
      return results;
    }catch(e) {
      throw Exception(e);
    }
  }

}