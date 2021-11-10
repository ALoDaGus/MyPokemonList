import 'package:flutter/material.dart';
import 'package:my_pokemon_list/pages/list_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
    int columnPerPage =
        (PokemonListPage.myLimit / PokemonListPage.itemPerCollumn).ceil();
    int itemPerCollumn = PokemonListPage.itemPerCollumn;
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _rowItem('Column per page', columnPerPage, 0, 20),
          _rowItem('Item per collumn', itemPerCollumn, 1, 7),
        ],
      ),
    );
  }

  _rowItem(String s, int current, int item, int end) {
    int dropdownValue = current;

    return Center(
      child: SizedBox(
        width: 400.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(s),
            DropdownButton<int>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (int? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  if(item == 0){
                    PokemonListPage.myLimit = dropdownValue * itemPerCollumn;
                    columnPerPage = dropdownValue;
                  }
                  else{
                    PokemonListPage.itemPerCollumn = itemPerCollumn = dropdownValue;
                    PokemonListPage.myLimit = columnPerPage * itemPerCollumn;
                  }
                });
              },
              items: <int>[for (int i = 1; i <= end; i++) i]
                  .map<DropdownMenuItem<int>>((int value) {
                return DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value'),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
