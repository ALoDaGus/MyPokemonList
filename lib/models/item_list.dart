class ItemList {
  final int id;
  final String name;
  final String url;

  String get imageUrl => 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/$name.png';

  ItemList({
    required this.id,
    required this.name,
    required this.url,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) {
    final String name = json['name'];
    final String url = json['url'];

    final int id = int.parse(url.split('/')[6]);

    return ItemList(id: id, name: name, url: url);
  }

}