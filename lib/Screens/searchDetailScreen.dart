import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocktail_recipe_generator/Modals/searchModal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cocktail_recipe_generator/Modals/cocktail.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../apis/getCocktailbyId.dart';

class searchDetailScreen extends StatefulWidget {
  final searchModal newCocktail;

  searchDetailScreen({required this.newCocktail});

  @override
  State<searchDetailScreen> createState() => _searchDetailScreenState();
}

class _searchDetailScreenState extends State<searchDetailScreen> {
  bool isDataSet=false;
  String userId="";
  bool isLoading=true;
  Cocktail newCockTail=Cocktail(
      idDrink: "idDrink",
      strDrink: "strDrink",
      strCategory: "strCategory",
      strAlcoholic: "strAlcoholic",
      strGlass: "strGlass",
      strInstructions: "strInstructions",
      strDrinkThumb: "strDrinkThumb",
      ingredients: [],
      measures: []
  );

  List<String> separateInstructions(String instructions) {
    List<String> points =
    instructions.split('.').where((s) => s.trim().isNotEmpty).toList();
    return points.map((point) => '$point.').toList();
  }

  Future<void> saveImageToGallery(BuildContext context, String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final result = await ImageGallerySaver.saveImage(
            Uint8List.fromList(response.bodyBytes));
        if (result != null && result.isNotEmpty) {
          print('Image saved to gallery: $result');
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Image Saved'),
                content: Text('The image has been saved to your gallery.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          // Image saving failed
          print('Failed to save the image to the gallery.');
        }
      }
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

// Function to save a favorite cocktail to Firestore
  Future<bool> saveFavoriteCocktail(Cocktail cocktail) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final userDocRef =
      FirebaseFirestore.instance.collection("Favourites").doc(userId);

      final cocktailData = {
        "idDrink": cocktail.idDrink,
        "strDrink": cocktail.strDrink,
        "strCategory": cocktail.strCategory,
        "strAlcoholic": cocktail.strAlcoholic,
        "strGlass": cocktail.strGlass,
        "strInstructions": cocktail.strInstructions,
        "strDrinkThumb": cocktail.strDrinkThumb,
        "ingredients": cocktail.ingredients,
        "measures": cocktail.measures,
      };

      await userDocRef.set(
        {
          "favoriteCocktails": FieldValue.arrayUnion([cocktailData])
        },
        SetOptions(merge: true),
      );

      return true; // Data was successfully saved
    } catch (e) {
      print("Error saving favorite cocktail: $e");
      return false; // Data was not saved due to an error
    }
  }

// Function to retrieve the user's favorite cocktails from Firestore
  Future<bool> isCocktailInFavorites(String cocktailId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final userDoc = await FirebaseFirestore.instance.collection("Favourites").doc(userId).get();

    final favoriteCocktailsData = userDoc.data()?["favoriteCocktails"];

    if (favoriteCocktailsData != null && favoriteCocktailsData is List) {
      final List<Map<String, dynamic>> favoriteCocktails = List<Map<String, dynamic>>.from(favoriteCocktailsData);

      // Check if a cocktail with the specified ID exists in the user's favorites
      bool isFavorite = favoriteCocktails.any((cocktailData) => cocktailData["idDrink"] == cocktailId);

      return isFavorite;
    }

    return false; // User has no favorite cocktails or an error occurred.
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCockTailbyId(widget.newCocktail.idDrink).then((value) {
      setState(() {
        newCockTail=value;
        isLoading=false;
      });
    });
  }

  @override
  Widget build(BuildContext context){

    List<String> instructionPoints =
    separateInstructions(newCockTail.strInstructions);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.newCocktail.strDrink),
        actions: [
          FutureBuilder<bool>(
            future: isCocktailInFavorites(widget.newCocktail.idDrink),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final isFavorite = snapshot.data;
                if (isFavorite!) {
                  return IconButton(
                    onPressed: () {
                      // Remove from favorites logic
                    },
                    icon: Icon(Icons.favorite_rounded, color: Colors.red,),
                  );
                } else {
                  return IconButton(
                    onPressed: () {
                      saveFavoriteCocktail(newCockTail).then((value) {
                        setState(() {
                          isDataSet=true;
                        });
                      });
                    },
                    icon: isDataSet? Icon(Icons.favorite_rounded, color: Colors.red,)  : Icon(Icons.favorite_outline_rounded),
                  );
                }
              }
              return Text('Something went wrong.');
            },
          )
        ],
      ),
      body:  SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Hero(
                  tag: widget.newCocktail.strDrinkThumb,
                  child: CachedNetworkImage(
                    imageUrl: widget.newCocktail.strDrinkThumb,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
                Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: IconButton(
                          onPressed: () {
                            Permission.storage.request().then((value) {
                              saveImageToGallery(
                                  context, widget.newCocktail.strDrinkThumb);
                            });
                          },
                          icon: const Icon(Icons.download)),
                    )),
              ],
            ),
            isLoading? Center(
              child: CircularProgressIndicator(),
            ) : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    newCockTail.strCategory,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.local_bar, color: Color(0xFFD4AF37), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Alcoholic:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                       newCockTail.strAlcoholic,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.local_drink,
                          color: Colors.red.shade300, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Glass:',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                       newCockTail.strGlass,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  if (newCockTail.ingredients
                      .any((ingredient) => ingredient.isNotEmpty))
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Ingredients:',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: newCockTail.ingredients.length,
                            itemBuilder: (context, index) {
                              final ingredient =
                              newCockTail.ingredients[index];
                              final measure =
                              newCockTail.measures[index];

                              if (ingredient.isNotEmpty && measure.isNotEmpty) {
                                return IngredientCard(ingredient, measure);
                              }
                              return SizedBox.shrink();
                            },
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  if (instructionPoints.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: instructionPoints.asMap().entries.map((entry) {
                        final index =
                            entry.key + 1;
                        final point = entry.value;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors
                                    .blue,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$index',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                point.trim(),
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IngredientCard extends StatelessWidget {
  final String ingredient;
  final String measure;

  IngredientCard(this.ingredient, this.measure);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 16),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ingredient,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(height: 4),
              Text(
                measure,
                style: TextStyle(
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
