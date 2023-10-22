import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Modals/cocktail.dart';

Future<Cocktail> fetchRandomCocktail() async {
  final response = await http.get(Uri.parse("https://www.thecocktaildb.com/api/json/v1/1/random.php"));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Cocktail.fromJson(data['drinks'][0]);
  } else {
    throw Exception('Failed to load data from the API');
  }
}
