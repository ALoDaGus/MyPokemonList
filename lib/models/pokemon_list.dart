class PokemonList {
  final int id;
  final String name;
  final String url;

  String get imageUrl => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  PokemonList({
    required this.id,
    required this.name,
    required this.url,
  });

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final url = json['url'];
    final id = int.parse(url.split('/')[6]);
    
    return PokemonList(id: id, name: name, url: url);
  }
}
