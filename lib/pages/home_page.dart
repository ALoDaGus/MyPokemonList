import 'package:flutter/material.dart';
import 'package:my_pokemon_list/pages/list_page.dart';
import 'package:my_pokemon_list/pages/setting_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

var _subPageIndex = 0;
Widget? _currentPage = PokemonListPage();

_buildDrawerItem(IconData icon, String title, int onFocus) {
    return Row(
      children: [
        Icon(icon, color: _subPageIndex==onFocus ? Colors.blue : null),
        const SizedBox(width: 8.0),
        Text(
          title,
          style: _subPageIndex == onFocus
              ? Theme.of(context).textTheme.headline5
              : Theme.of(context).textTheme.bodyText2),
      ],
    );
  }

  _showSubPage(BuildContext context, int page) {
    setState(() {
      switch(_subPageIndex = page) {
      case 0 : {

          
        PokemonListPage.page = 'pokemon';
        PokemonListPage.currentPage = 1;
        _currentPage = PokemonListPage();

        break;
      }
      case 1 : {

          
        PokemonListPage.page = 'item';
        PokemonListPage.currentPage = 1;
        _currentPage = PokemonListPage();

        break;
      }
      case 2 : {
        _currentPage = SettingPage();
        
        break;
      }
      default: {

        PokemonListPage.page = 'pokemon';
        PokemonListPage.currentPage = 1;
        _currentPage = PokemonListPage();

        break;
      }
    }
    });
    Navigator.of(context).pop();
    //Navigator.of(context).pushNamed(LoginPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blue,
        title: const Text('My Pokemon List'),
        // actions: [
        //   IconButton(
        //     onPressed: (){},
        //     icon: const Icon(Icons.search),
        //   ),
        //   IconButton(
        //     onPressed: (){},
        //     icon: const Icon(Icons.refresh),
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // DrawerHeader(
            //   decoration: const BoxDecoration(
            //     color: Colors.teal,
            //   ),
            //   child: Column(
            //     children: [
            //       // ClipRRect(
            //       //   borderRadius: BorderRadius.circular(40.0),
            //       //   child: Container(
            //       //     width: 80.0,
            //       //     height: 80.0,
            //       //     child: Container(

            //       //     ),
            //       //   ),
            //       // ),
            //     ],
            //   ),
            // ),
            ListTile(
              title: _buildDrawerItem(
                  Icons.camera_front_sharp,
                  'Pokemon list', 0
              ),
              onTap: () => _showSubPage(context, 0),
            ),
            ListTile(
              title: _buildDrawerItem(
                  Icons.catching_pokemon,
                  'Item list', 1
              ),
              onTap: () => _showSubPage(context, 1),
            ),
            ListTile(
              title: _buildDrawerItem(
                  Icons.settings,
                  'Setting', 2
              ),
              onTap: () => _showSubPage(context, 2),
            ),
          ],

        ),
      ),
      body: _currentPage,
    );
  }
}
