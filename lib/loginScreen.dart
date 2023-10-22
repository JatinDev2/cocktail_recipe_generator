import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'Providers/googleAuthProvider.dart';
import 'Screens/homePage.dart';


class FoodAppLogin extends StatefulWidget {
  const FoodAppLogin({super.key});

  @override
  State<FoodAppLogin> createState() => _FoodAppLoginState();
}
//~/StudioProjects/cocktail_recipe_generator
class _FoodAppLoginState extends State<FoodAppLogin> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    final height=MediaQuery.of(context).size.height;
    final width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height,
            width: width,
            child: Image.asset("assets/img.jpg", height: height, width: width, fit: BoxFit.cover,),
          ),
       Container(
            height: height,
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                splashColor: Colors.red.shade100,
                  onTap:(){
                    setState((){
                      isLoading=true;
                    });
                      final provider= Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.googleLogIn().then((value){
                        if(value==true){
                          setState((){
                            isLoading=false;
                          });
                          Navigator.of(context).push(MaterialPageRoute(builder: (_){
                            return HomePage();
                          }));
                        }
                      });
                  },
                  child: Container(
                    height:50,
                    width: width-30,
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(color: Colors.black, width: 1)
                    ),
                    child: isLoading? const Center(
                      child: CircularProgressIndicator(),
                    ) : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset("assets/google.svg"),
                       const SizedBox(width: 24,),
                       const Text(
                          "Continue with Google",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff12121d),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
