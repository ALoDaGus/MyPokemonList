import 'package:flutter/material.dart';
import 'package:my_pokemon_list/models/apipokemon_list.dart';
import 'package:my_pokemon_list/models/pokemon.dart';
import 'package:my_pokemon_list/models/pokimon_list.dart';
import 'package:my_pokemon_list/pages/pokemon_page.dart';
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
  int limit = 1118;
  int mylimit = 21;
  late int itemCount;
  int offset = 0;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    itemCount = (mylimit / 3).ceil();
    _futurePokemonList = _loadPokemons();
  }

  Future<List<PokemonList>> _loadPokemons() async {
    var jsonBody = await Api().fetch('pokemon',
        queryParams: {'limit': '$limit', 'offset': '$offset'});

    List apiResult = ApiPokemonList.fromJson(jsonBody).results;

    var myPokemonList =
        apiResult.map((item) => PokemonList.fromJson(item)).toList();
    return myPokemonList;
  }

  Future<Pokemon> _loadPokemonDetail(String name) async {
    var jsonBody = await Api().fetch('pokemon/$name');
    var myPokemon = Pokemon.fromJson(jsonBody);

    setState(() => _isLoading = false);

    Navigator.pushNamed(context, PokemonPage.routeName, arguments: myPokemon);

    return myPokemon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: BottomNavigationBar(
      //   items: [
      //     BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu'),
      //     BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Menu')
      //   ],
      // ),
      body: Stack(
        children: [
          Column(
            children: [

              Expanded(child: _buildPokemonList(context)),
              _pageSelector(5),
            ],
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
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
              int start = (3 * index) + (currentPage - 1) * mylimit;
              int end = start + 3 > limit ? limit : start + 3;

              return Row(
                children: [
                  for (int i = start; i < end; i++)
                    Expanded(
                      child: SizedBox(
                        // height: 200.0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isLoading = true;
                              _loadPokemonDetail(pokemonList![i].name);
                            });
                          },
                          child: Card(
                            shadowColor: Colors.teal,
                            elevation: 3.0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: [
                                  Text('${pokemonList![i].id}'),
                                  Image.network(
                                    pokemonList![i].imageUrl,
                                    errorBuilder: (
                                      BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace,
                                    ) {
                                      return Image(image: AssetImage('images/pokemons/defult_pokemon.png'), height: 100,);
                                    },
                                  ),
                                  Text(pokemonList[i].name),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
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
                      // itemCount = limit - (currentPage - 1) * mylimit;
                      itemCount = ((mylimit / 3).floor() -
                          ((mylimit * currentPage - limit) / 3).floor());
                    else
                      itemCount = (mylimit / 3).ceil();
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
