// import 'dart:isolate';

class Pokemon {
  final int id;
  final String name;
  final int base_experience;
  final int height;
  final bool is_default;
  final int order;
  final int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.base_experience,
    required this.height,
    required this.is_default,
    required this.order,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      base_experience: json['base_experience'],
      height: json['height'],
      is_default: json['is_default'],
      order: json['order'],
      weight: json['weight'],
    );
  }
}