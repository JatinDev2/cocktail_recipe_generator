class Cocktail {
  final String idDrink;
  final String strDrink;
  final String strCategory;
  final String strAlcoholic;
  final String strGlass;
  final String strInstructions;
  final String strDrinkThumb;
  List ingredients;
  List measures;

  Cocktail({
    required this.idDrink,
    required this.strDrink,
    required this.strCategory,
    required this.strAlcoholic,
    required this.strGlass,
    required this.strInstructions,
    required this.strDrinkThumb,
    required this.ingredients,
    required this.measures,
  });

  factory Cocktail.fromJson(Map<String, dynamic> json) {
    return Cocktail(
        idDrink: json['idDrink'] ?? "",
        strDrink: json['strDrink'] ?? "",
        strCategory: json['strCategory'] ?? "",
        strAlcoholic: json['strAlcoholic'] ?? "",
        strGlass: json['strGlass'] ?? "",
        strInstructions: json['strInstructions'] ?? "",
        strDrinkThumb: json['strDrinkThumb'] ?? "",
        ingredients: [
          json['strIngredient1'] ?? "",
          json['strIngredient2'] ?? "",
          json['strIngredient3'] ?? "",
          json['strIngredient4'] ?? "",
          json['strIngredient5'] ?? "",
          json['strIngredient6'] ?? "",
          json['strIngredient7'] ?? "",
          json['strIngredient8'] ?? "",
          json['strIngredient9'] ?? "",
          json['strIngredient10'] ?? "",
          json['strIngredient11'] ?? "",
          json['strIngredient12'] ?? "",
          json['strIngredient13'] ?? "",
          json['strIngredient14'] ?? "",
          json['strIngredient15'] ?? "",
        ],
        measures: [
          json['strMeasure1'] ?? "",
          json['strMeasure2'] ?? "",
          json['strMeasure3'] ?? "",
          json['strMeasure4'] ?? "",
          json['strMeasure5'] ?? "",
          json['strMeasure6'] ?? "",
          json['strMeasure7'] ?? "",
          json['strMeasure8'] ?? "",
          json['strMeasure9'] ?? "",
          json['strMeasure10'] ?? "",
          json['strMeasure11'] ?? "",
          json['strMeasure12'] ?? "",
          json['strMeasure13'] ?? "",
          json['strMeasure14'] ?? "",
          json['strMeasure15'] ?? "",
        ]);
  }
}
