import 'package:flutter/material.dart';
import 'package:my_pokemon_list/models/apipokemon_list.dart';
import 'package:my_pokemon_list/models/item_detail.dart';
import 'package:my_pokemon_list/models/item_list.dart';
import 'package:my_pokemon_list/models/pokemon.dart';
import 'package:my_pokemon_list/models/pokimon_list.dart';
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

  // late int PokemonListPage.myLimit = 30;
  // late int PokemonListPage.currentPage = 1;
  late int limit;

  final int offset = 0;
  late int itemCount;

  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    itemCount = PokemonListPage.myLimit;
    _futurePokemonList = _loadPokemons();
    _futureItemList = _loadItemList();
  }

  Future<List<PokemonList>> _loadPokemons() async {
    limit = 1118;
    var jsonBody = await Api().fetch('pokemon',
        queryParams: {'limit': '$limit', 'offset': '$offset'});

    List apiResult = ApiPokemonList.fromJson(jsonBody).results;

    var myPokemonList =
        apiResult.map((item) => PokemonList.fromJson(item)).toList();
    return myPokemonList;
  }

  Future<List<ItemList>> _loadItemList() async {
    limit = 954;
    Map<String, dynamic> jsonBody = await Api()
        .fetch('item', queryParams: {'limit': '$limit', 'offset': '$offset'});

    List<ItemList> myItem = [];
    for (Map<String, dynamic> list in jsonBody['results']) {
      myItem.add(ItemList.fromJson(list));
    }
    return myItem;
  }

  _loadPokemonDetail(int id) async {
    var jsonBody = await Api().fetch('pokemon/$id');
    var myPokemon = Pokemon.fromJson(jsonBody);

    setState(() => _isLoading = false);

    Navigator.pushNamed(context, PokemonPage.routeName, arguments: myPokemon);

    return myPokemon;
  }

  _loadItemDetail(int id) async {
    var jsonBody = await Api().fetch('item/$id');
    var myPokemon = ItemDetail.fromJson(jsonBody);

    setState(() => _isLoading = false);

    Navigator.pushNamed(context, ItemPage.routeName, arguments: myPokemon);

    return myPokemon;
  }

  @override
  Widget build(BuildContext context) {

    if(PokemonListPage.page == 'pokemon'){
      _futurePageList = _futurePokemonList;
      limit = 1118;
    }
    else{
      _futurePageList = _futureItemList;
      limit = 954;
    }
    // _futurePokemonList =
    //     PokemonListPage.page == 'pokemon' ? _loadPokemons() : _loadItemList();
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
              int myIndex = index + (PokemonListPage.myLimit * (PokemonListPage.currentPage - 1));

              return InkWell(
                onTap: () {
                  setState(() {
                    _isLoading = true;
                    PokemonListPage.page == 'pokemon'
                        ? _loadPokemonDetail(pokemonList![myIndex].id)
                        : _loadItemDetail(pokemonList![myIndex].id);
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
                              // height: 100,
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
          onPressed: PokemonListPage.currentPage == page
              ? null
              : () {
                  _changePage(page);
                },
          child: Text('${page}')),
    ));
  }

  _changePage(int page) {
    setState(() {
      PokemonListPage.currentPage = page;
      if (PokemonListPage.currentPage == (limit / PokemonListPage.myLimit).floor() + 1) {
        itemCount =
            ((PokemonListPage.myLimit).floor() - ((PokemonListPage.myLimit * PokemonListPage.currentPage - limit)).floor());
      } else {
        itemCount = PokemonListPage.myLimit;
      }
    });
  }

  _pageSelector(int page) {
    int start =
        PokemonListPage.currentPage - page / 2 <= 1 ? 1 : PokemonListPage.currentPage - (page / 2).floor();

    int end = start + page > (limit / PokemonListPage.myLimit).ceil()
        ? (limit / PokemonListPage.myLimit).ceil() + 1
        : start + page;

    if (end == (limit / PokemonListPage.myLimit).ceil() + 1) start = end - page;

    var list = [for (int i = 1; i <= (limit / PokemonListPage.myLimit).ceil(); i++) '$i'];
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

  DropdownButton<String> myDropdownButton(
      String _chosenValue, List<String> list) {
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
