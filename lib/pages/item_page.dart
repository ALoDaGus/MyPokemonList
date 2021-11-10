import 'package:flutter/material.dart';
import 'package:my_pokemon_list/models/item_detail.dart';

class ItemPage extends StatefulWidget {
  ItemPage({Key? key}) : super(key: key);

  static const routeName = '/Item';

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {

    late ItemDetail pageItem = ModalRoute.of(context)!.settings.arguments as ItemDetail;
    
    // pokemonName = name;
    // print(pageItem.sprites['back_default']);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Item'),
        ),
        body: 
        ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _pokemonImage(pageItem),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                pageItem.name,
                style: Theme.of(context).textTheme.headline5,
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(child: Text(pageItem.details)),
            )
          ],
        )
    );
  }

  Container _pokemonImage(ItemDetail pageItem) {
    var defultImage = 'images/pokemons/defult_pokemon.png';
    return Container(
      height: 250.0,
      color: Colors.teal[100],
      child: Image.network(
        pageItem.sprites,
        errorBuilder: (
          BuildContext context,
          Object exception,
          StackTrace? stackTrace,
        ) {
          return Image(
            image: AssetImage(defultImage),
            height: 100,
          );
        },
        scale: 0.1,
      ),
    );
  }


}