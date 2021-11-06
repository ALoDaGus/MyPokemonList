import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_pokemon_list/models/pokemon.dart';
import 'package:my_pokemon_list/models/apipokemon_list.dart';
import 'package:my_pokemon_list/pages/pokemonlist_page.dart';

class Api {
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
      // แปลง text ที่มีรูปแบบเป็น JSON ไปเป็น Dart's data structure (List/Map)
      Map<String, dynamic> jsonBody = json.decode(response.body);
      print('RESPONSE BODY: $jsonBody');

      // แปลง Dart's data structure ไปเป็น model (POJO)
      var apiResult = Pokemon.fromJson(jsonBody);

      if (apiResult != null) {
        return apiResult;
      } else {
        throw apiResult;
      }
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
      // headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // แปลง text ที่มีรูปแบบเป็น JSON ไปเป็น Dart's data structure (List/Map)
      Map<String, dynamic> jsonBody = json.decode(response.body);

      // print('RESPONSE BODY: $jsonBody');

      var apiResult = ApiPokemonList.fromJson(jsonBody);

      // print(apiResult.results);

      if (jsonBody != 'null') {
        return apiResult.results;
      } else {
        throw jsonBody;
      }
    } else {
      throw 'Server connection failed!';
    }
  }
}
