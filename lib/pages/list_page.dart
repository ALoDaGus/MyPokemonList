import 'package:flutter/material.dart';
import 'package:my_pokemon_list/models/item_detail.dart';
import 'package:my_pokemon_list/models/item_list.dart';
import 'package:my_pokemon_list/models/pokemon.dart';
import 'package:my_pokemon_list/models/pokemon_list.dart';
import 'package:my_pokemon_list/pages/item_page.dart';
import 'package:my_pokemon_list/pages/pokemon_page.dart';
import 'package:my_pokemon_list/services/api.dart';

class PokemonListPage extends StatefulWidget {
  PokemonListPage({Key? key}) : super(key: key);

  static String page = 'pokemon';
  static int myLimit = 30;
  static int limit = 1118;
  static int currentPage = 1;
  static int itemPerCollumn = 3;
  static const routeName = '/PokemonList';

  @override
  _PokemonListPageState createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  late Future<List<dynamic>> _futurePageList;
  late Future<List<dynamic>> _futureItemList;
  late Future<List<dynamic>> _futurePokemonList;

  late int limit;

  final int offset = 0;
  late int itemCount;

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    itemCount = PokemonListPage.myLimit;
    _futurePokemonList = _loadPokemons(1118, true);
    _futureItemList = _loadPokemons(954, false);
  }

  Future<List<dynamic>> _loadPokemons(int limit, bool check) async {
    Map<String, dynamic> jsonBody = await Api().fetch(
        check ? 'pokemon' : 'item',
        queryParams: {'limit': '$limit', 'offset': '$offset'});

    List<dynamic> myItem = [];
    for (Map<String, dynamic> list in jsonBody['results']) {
      myItem.add(check ? PokemonList.fromJson(list) : ItemList.fromJson(list));
    }

    return myItem;
  }

  _loadDetail(int id, String s) async {
    var jsonBody = await Api().fetch('$s/$id');
    var myPokemon = s == 'pokemon'
        ? Pokemon.fromJson(jsonBody)
        : ItemDetail.fromJson(jsonBody);

    setState(() => _isLoading = false);
    Navigator.pushNamed(
        context, s == 'pokemon' ? PokemonPage.routeName : ItemPage.routeName,
        arguments: myPokemon);

    return myPokemon;
  }

  @override
  Widget build(BuildContext context) {
    if (PokemonListPage.page == 'pokemon') {

      _futurePageList = _futurePokemonList;
      limit = 1118;
    } else {
      _futurePageList = _futureItemList;
      limit = 954;
    }
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _buildPokemonList(context)),
              _pageSelector(7),
            ],
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  Widget _buildPokemonList(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _futurePageList,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          var pokemonList = snapshot.data;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: PokemonListPage.itemPerCollumn,
              mainAxisExtent: 195.0,
            ),
            shrinkWrap: true,
            padding: const EdgeInsets.all(8.0),
            itemCount: itemCount,
            itemBuilder: (BuildContext context, int index) {
              int myIndex = index +
                  (PokemonListPage.myLimit * (PokemonListPage.currentPage - 1));

              return InkWell(
                onTap: () {
                  setState(() {
                    _isLoading = true;

                    _loadDetail(pokemonList![myIndex].id,
                        PokemonListPage.page == 'pokemon' ? 'pokemon' : 'item');
                  });
                },
                child: Card(
                  shadowColor: Colors.teal,
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: ListView(
                      // itemExtent: 20.0,
                      children: [
                        Center(child: Text('${pokemonList![myIndex].id}')),
                        Image.network(
                          pokemonList[myIndex].imageUrl,
                          height: 100.0,
                          errorBuilder: (
                            BuildContext context,
                            Object exception,
                            StackTrace? stackTrace,
                          ) {
                            return const Image(
                              image: AssetImage(
                                  'images/pokemons/defult_pokemon.png'),
                              height: 120,
                            );
                          },
                        ),
                        Center(child: Text(pokemonList[myIndex].name)),
                      ],
                    ),
                  ),
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

  _pageButton(int page) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: PokemonListPage.currentPage == page
              ? null
              : () {
                  _changePage(page);
                },
          child: Text('$page')),
    ));
  }

  _changePage(int page) {
    setState(() {
      PokemonListPage.currentPage = page;
      if (PokemonListPage.currentPage ==
          (limit / PokemonListPage.myLimit).floor() + 1) {
        itemCount = ((PokemonListPage.myLimit).floor() -
            ((PokemonListPage.myLimit * PokemonListPage.currentPage - limit))
                .floor());
      } else {
        itemCount = PokemonListPage.myLimit;
      }
    });
  }

  _pageSelector(int page) {
    int start = PokemonListPage.currentPage - page / 2 <= 1
        ? 1
        : PokemonListPage.currentPage - (page / 2).floor();

    int end = start + page > (limit / PokemonListPage.myLimit).ceil()
        ? (limit / PokemonListPage.myLimit).ceil() + 1
        : start + page;

    if (end == (limit / PokemonListPage.myLimit).ceil() + 1) start = end - page;

    var list = [
      for (int i = 1; i <= (limit / PokemonListPage.myLimit).ceil(); i++) '$i'
    ];
    var _chosenValue = '${PokemonListPage.currentPage}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Row(
        children: [
          for (int i = start; i < end; i++)
            PokemonListPage.currentPage == i
                ? myDropdownButton(_chosenValue, list)
                : _pageButton(i),
        ],
      ),
    );
  }

  DropdownButton myDropdownButton(String _chosenValue, List<String> list) {
    return DropdownButton<String>(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      value: _chosenValue,
      elevation: 5,
      dropdownColor: Colors.teal[100],
      style: TextStyle(color: Colors.teal[900]),
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          _chosenValue = value!;
          _changePage(int.parse(_chosenValue));
        });
      },
    );
  }
}
