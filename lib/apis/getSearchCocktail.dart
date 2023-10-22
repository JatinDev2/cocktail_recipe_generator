import 'dart:convert';
import 'package:cocktail_recipe_generator/Modals/searchModal.dart';
import 'package:http/http.dart' as http;
import '../Modals/cocktail.dart';

Future<List<searchModal>> searchCocktailsByIngredient(String ingredient) async {
  List<searchModal> _list = [];
  final response = await http.get(
    Uri.parse('https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=$ingredient'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    for (int i = 0; i < data['drinks'].length; i++) {
      _list.add(searchModal.fromJson(data['drinks'][i]));
    }
    return _list;
  } else {
    throw Exception('Failed to load data from the API');
  }
}
