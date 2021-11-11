import 'package:flutter/material.dart';
import 'package:my_pokemon_list/pages/item_page.dart';

import 'pages/home_page.dart';
import 'pages/pokemon_page.dart';
import 'pages/list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'my pokemon list',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 22.0,),
            bodyText2: TextStyle(fontSize: 18.0)),
      ),
      
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        PokemonListPage.routeName: (context) => PokemonListPage(),
        PokemonPage.routeName: (context) => const PokemonPage(),
        ItemPage.routeName: (context) => const ItemPage(),

      },
      initialRoute: HomePage.routeName,
    );
  }
}
