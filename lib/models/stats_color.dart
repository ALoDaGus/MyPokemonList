import 'package:charts_flutter/flutter.dart' as charts;
class StatColor {
  final Map<String, charts.Color> _statsColor = {
    'hp': charts.MaterialPalette.red.shadeDefault,
    'attack': charts.MaterialPalette.deepOrange.shadeDefault,
    'defense': charts.MaterialPalette.yellow.shadeDefault,
    'special-attack': charts.MaterialPalette.green.shadeDefault,
    'special-defense': charts.MaterialPalette.cyan.shadeDefault,
    'speed': charts.MaterialPalette.pink.shadeDefault,
  };

  charts.Color? getColor(String color){
    return _statsColor[color];
  }

}