import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocktail_recipe_generator/customs/cocktailCard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Modals/cocktail.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {

  Future<List<Cocktail>> getFavoriteCocktails() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userDoc = await FirebaseFirestore.instance.collection("Favourites").doc(userId).get();
    final favoriteCocktailsData = userDoc.data()?["favoriteCocktails"];

    if (favoriteCocktailsData != null && favoriteCocktailsData is List) {
      final favoriteCocktails = List<Cocktail>.from(favoriteCocktailsData.map((cocktailData) {
        return Cocktail(
          idDrink: cocktailData["idDrink"],
          strDrink: cocktailData["strDrink"],
          strCategory: cocktailData["strCategory"],
          strAlcoholic: cocktailData["strAlcoholic"],
          strGlass: cocktailData["strGlass"],
          strInstructions: cocktailData["strInstructions"],
          strDrinkThumb: cocktailData["strDrinkThumb"],
          ingredients: List<String>.from(cocktailData["ingredients"]),
          measures: List<String>.from(cocktailData["measures"]),
        );
      }));
      return favoriteCocktails;
    }
    return <Cocktail>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favourites", style: TextStyle(
          fontWeight: FontWeight.w700,
        ),),
        backgroundColor: Color(0xffFF9431).withOpacity(0.2),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Cocktail>>(
        future: getFavoriteCocktails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData ) {
            return Center(child: Text('No favorite cocktails yet.'));
          } else {
            final favoriteCocktails = snapshot.data;
            return ListView.builder(
              itemCount: favoriteCocktails?.length,
              itemBuilder: (context, index) {
                final cocktail = favoriteCocktails?[index];
                return CocktailCard(newCockTail: cocktail!);
              },
            );
          }
        },
      ),
    );
  }
}
