class Pokemon {
  final int id;
  final String name;
  final int baseExperience;
  final int height;
  final bool isDefault;
  final int order;
  final int weight;

  final Map<String, dynamic> sprites;
  final List<dynamic> types;
  final List<dynamic> stats;



  Pokemon({
    required this.id,
    required this.name,
    required this.baseExperience,
    required this.height,
    required this.isDefault,
    required this.order,
    required this.weight,

    required this.sprites,
    required this.types,
    required this.stats,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      baseExperience: json['base_experience'],
      height: json['height'],
      isDefault: json['is_default'],
      order: json['order'],
      weight: json['weight'],

      sprites: json['sprites'],
      types: json['types'],
      stats: json['stats'],
    );
  }
}