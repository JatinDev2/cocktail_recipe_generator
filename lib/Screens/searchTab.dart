import 'package:cocktail_recipe_generator/customs/searchCard.dart';
import 'package:flutter/material.dart';
import '../apis/getSearchCocktail.dart';
import '../Modals/searchModal.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController ingredientController = TextEditingController();
  List<searchModal> _list=[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("Search Cocktails", style: TextStyle(
          fontWeight: FontWeight.w700,
        ),),
        backgroundColor: Color(0xffFF9431).withOpacity(0.2),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: ingredientController,
              decoration: InputDecoration(
                labelText: "Enter an ingredient",
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ),
              onChanged: (value){
                searchCocktailsByIngredient(value).then((obtainedList) {
                  setState((){
                    _list=obtainedList;
                  });
                });
              },
            ),
            SizedBox(height: 10),
            if (_list.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (context, index) {
                    final cocktail = _list[index];
                    return searchCard(newCockTail: cocktail);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
