import 'package:flutter/material.dart';
import 'package:my_pokemon_list/models/pokimon_list.dart';
import 'package:my_pokemon_list/services/api.dart';

class PokemonListPage extends StatefulWidget {
  PokemonListPage({Key? key}) : super(key: key);

  static const routeName = '/PokemonList';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late Future<List<PokemonList>> _futurePokemonList;

  int currentPage = 1;
  int limit = 115;
  int mylimit = 10;
  late int itemCount;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    itemCount = mylimit;
    _futurePokemonList = _loadPokemons();
  }

  Future<List<PokemonList>> _loadPokemons() async {
    List list = await Api().fetch('pokemon',
        queryParams: {'limit': '${limit}', 'offset': '${offset}'});
    var myPokemonList = list.map((item) => PokemonList.fromJson(item)).toList();
    return myPokemonList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Pokemon List'),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      //     BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu')
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(child: _buildPokemonList(context)),
          _pageSelector(5),
        ],
      ),
    );
  }

  Widget _buildPokemonList(BuildContext context) {
    return FutureBuilder<List<PokemonList>>(
      future: _futurePokemonList,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var pokemonList = snapshot.data;

          return ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              var pokemon = pokemonList![((currentPage - 1) * mylimit) + index];

              return Card(
                child: Row(
                  children: [
                    Image.network(pokemon.imageUrl),
                    Text(pokemon.name),
                  ],
                ),
              );
            },
          );
        }

        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        return const SizedBox.shrink();
      },
    );
  }

  // String getImage(String url) {
  //   String id = url.substring(
  //       url.substring(0, url.length - 1).lastIndexOf('/') + 1, url.length - 1);
  //   var front_defult =
  //       'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${id}.png';
  //   return front_defult;
  // }

  _pageButton(int page) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: currentPage == page
              ? null
              : () {
                  setState(() {
                    currentPage = page;
                    if (currentPage == (limit / mylimit).floor() + 1)
                      itemCount = limit - (currentPage - 1) * mylimit;
                    else
                      itemCount = mylimit;
                  });
                },
          child: Text('${page}')),
    ));
  }

  _pageSelector(int page) {
    int start =
        currentPage - page / 2 <= 1 ? 1 : currentPage - (page / 2).floor();

    int end = start + page > (limit / mylimit).ceil()
        ? (limit / mylimit).ceil() + 1
        : start + page;

    if (end == (limit / mylimit).ceil() + 1) start = end - page;

    return Row(
      children: [for (int i = start; i < end; i++) _pageButton(i)],
    );
  }
}
