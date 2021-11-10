class ItemDetail {
  final String name;
  final String sprites;
  final String details;

  ItemDetail({
    required this.name,
    required this.details,
    required this.sprites,
  });

  factory ItemDetail.fromJson(Map<String, dynamic> json) {
    final String name = json['name'];
    final String sprites = json['sprites']['default'];
    final String details = json['effect_entries'][0]['effect'];

    return ItemDetail(name: name, sprites: sprites, details: details);
  }
  
}