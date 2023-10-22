import 'package:cocktail_recipe_generator/apis/getRandomCocktail.dart';
import 'package:flutter/material.dart';
import '../Modals/cocktail.dart';
import '../customs/cocktailCard.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Cocktail> _randomCocktails=[];
  bool isLoading=true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCocktail();
  }

  Future<void> fetchCocktail() async{
    for(int i=0; i<10; i++){
      Cocktail newCocktail= await fetchRandomCocktail();
      print(newCocktail.strDrink);
      _randomCocktails.add(newCocktail);
    }
    setState(() {
      isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular Drinks", style: TextStyle(
          fontWeight: FontWeight.w700,
        ),),
        backgroundColor: Color(0xffFF9431).withOpacity(0.2),
        centerTitle: true,
      ),
      body: isLoading? const Center(child: CircularProgressIndicator()): ListView.builder(
        itemCount: _randomCocktails.length,
        itemBuilder: (context, index) {
          return CocktailCard(newCockTail: _randomCocktails[index],);
        },
      ),
    );
  }
}
