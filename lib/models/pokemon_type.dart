import 'package:flutter/material.dart';

class PokemonType {
  final Map<String, Color> _typeColor = {
    'normal': Colors.grey,
    'fighting': Colors.red.shade900,
    'flying': Colors.purple.shade100,
    'poison': Colors.purple,
    'ground': Colors.yellow.shade100,
    'rock': Colors.lime.shade900,
    'bug': Colors.lightGreenAccent.shade400,
    'ghost': Colors.purple.shade900,
    'steel': Colors.grey.shade300,
    'fire': Colors.yellow.shade800,
    'water': Colors.blue.shade300,
    'grass': Colors.green,
    'electric': Colors.yellow.shade300,
    'psychic': Colors.pink.shade300,
    'ice': Colors.cyan.shade100,
    'dragon': Colors.deepPurpleAccent.shade700,
    'dark': Colors.brown.shade700,
    'fairy': Colors.pink.shade200,
    'unknow': Colors.cyan.shade900,
    'shadow': Colors.brown.shade200,
  };

  Color? getColor(String color) {
    return _typeColor[color];
  }
}
