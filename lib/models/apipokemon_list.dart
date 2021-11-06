class ApiPokemonList {
  final int count;
  // final String? next;
  // final String? previous;
  final dynamic results;

  ApiPokemonList({
    required this.count,
    // required this.next,
    // required this.previous,
    required this.results
  });

  factory ApiPokemonList.fromJson(Map<String, dynamic> json) {
    return ApiPokemonList(
      count: json['count'],
      // next: json['next'],
      // previous: json['previous'],
      results: json['results'],
    );
  }
}