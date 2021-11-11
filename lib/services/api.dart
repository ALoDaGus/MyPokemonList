import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://pokeapi.co/api/v2';

  Future<dynamic> submit(
    String endPoint,
    Map<String, dynamic> params,
  ) async {
    var url = Uri.parse('$BASE_URL/$endPoint');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(params),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      return jsonBody;
    } else {
      throw 'Server connection failed!';
    }
  }

  Future<dynamic> fetch(
    String endPoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    String queryString = Uri(queryParameters: queryParams).query;
    var url = Uri.parse('$BASE_URL/$endPoint?$queryString');

    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonBody = json.decode(response.body);

      return jsonBody;
    } else {
      throw 'Server connection failed!';
    }
  }
}
