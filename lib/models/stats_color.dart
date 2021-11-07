import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StatColor {

  // ignore: prefer_final_fields
  Map<String, charts.Color> _statsColor = {
    'hp': charts.MaterialPalette.red.shadeDefault,
    'attack': charts.MaterialPalette.deepOrange.shadeDefault,
    'defense': charts.MaterialPalette.yellow.shadeDefault,
    'special-attack': charts.MaterialPalette.green.shadeDefault,
    'special-defense': charts.MaterialPalette.cyan.shadeDefault,
    'speed': charts.MaterialPalette.pink.shadeDefault,
  };

  StatColor() {
    
  }

  charts.Color? getColor(String color){
    return _statsColor[color];
  }

}