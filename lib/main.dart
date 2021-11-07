import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/pokemon_page.dart';
import 'pages/pokemonlist_page.dart';

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
      
      // home: PokemonListPage(),
      routes: {
        HomePage.routeName: (context) => HomePage(),
        PokemonListPage.routeName: (context) => PokemonListPage(),
        PokemonPage.routeName: (context) => PokemonPage(),

      },
      initialRoute: HomePage.routeName,
    );
  }
}
