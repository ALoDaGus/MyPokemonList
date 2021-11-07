import 'package:flutter/material.dart';
import 'package:my_pokemon_list/models/pokemon.dart';
import 'package:my_pokemon_list/models/pokemon_type.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:my_pokemon_list/models/stats_color.dart';

class PokemonPage extends StatefulWidget {
  PokemonPage({Key? key}) : super(key: key);

  static const routeName = '/Pokemon';

  @override
  _PokemonPageState createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  @override
  Widget build(BuildContext context) {
    var pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    // pokemonName = name;
    // print(pokemon.sprites['back_default']);

    return Scaffold(
        appBar: AppBar(
          title: Text('Pokemon'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pokemonImage(pokemon),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                pokemon.name,
                style: Theme.of(context).textTheme.headline5,
              )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (Map<String, dynamic> type in pokemon.types)
                  _typeCard(type['type']['name'])
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Weight: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${pokemon.weight / 10} kg')
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    children: [
                      Text(
                        'Height: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${pokemon.height / 10} m')
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 200.0,
              width: 500.0,
              child: _createBarChart(pokemon),
            )
          ],
        ));
  }

  Container _pokemonImage(Pokemon pokemon) {
    return Container(
      height: 250.0,
      color: Colors.teal[100],
      child: Image.network(
        pokemon.sprites['front_default'],errorBuilder: (
                                      BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,
                                    ) {
                                      return Image(image: AssetImage('images/pokemons/defult_pokemon.png'), height: 100,);
                                    },
        scale: 0.1,
      ),
    );
  }

  _typeCard(type) {
    var pt = PokemonType();
    return Card(
      color: pt.getColor(type),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          type,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 1.5,
                color: Colors.white,
                offset: Offset(1.5, 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createBarChart(Pokemon pokemon) {

    List<StatBar>? sb = [];
    StatColor sc = StatColor();

    for(Map<String, dynamic> stat in pokemon.stats){
      // print(stat['stat']['name'] + stat['base_stat']);
      sb.add(StatBar(stat['stat']['name'], stat['base_stat'], sc.getColor(stat['stat']['name'])));
    }

    if(sb.length <= 1)
      return SizedBox.shrink();

    return charts.BarChart(_createData(sb));
  }

  List<charts.Series<dynamic, String>> _createData(List<StatBar> sb) {
    final data = sb;

    return [
      charts.Series<StatBar, String>(
        id: 'Stats',
        data: data,
        // seriesColor: charts.ColorUtil.fromDartColor(Colors.teal),
        domainFn: (StatBar stats, _) => stats.name,
        measureFn: (StatBar stats, _) => stats.value,
        colorFn: (StatBar stats, _) => stats.color!,
      )
    ];
  }

  // _buildPokemonDetail(BuildContext context) {
  //   return FutureBuilder<List<Pokemon>>(
  //     future: _futurePokemon,
  //     builder: (context, snapshot) {

  //       if (snapshot.connectionState != ConnectionState.done){
  //         return const Center(child: CircularProgressIndicator(),);
  //       }

  //       if (snapshot.hasData){
  //         var pokemon = snapshot.data;

  //         return Container(
  //           child: Text(pokemon.),
  //         )
  //       }

  //     },
  //   );
  // }
}

class StatBar {
  final String name;
  final int value;
  final charts.Color? color;

  StatBar(this.name, this.value, this.color);
}
