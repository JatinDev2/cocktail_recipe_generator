import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Providers/googleAuthProvider.dart';
import 'Screens/myBottomNavigationBar.dart';
import 'firebase_options.dart';
import 'loginScreen.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSignInProvider>(
          create: (context) => GoogleSignInProvider(),
        ),
      ],
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.active) {
            final User? user = userSnapshot.data;

            if (user == null) {
              return MaterialApp(
                theme: ThemeData(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xffFF9431),
                  ),
                  useMaterial3: true,
                  textTheme: GoogleFonts.poppinsTextTheme(),
                ),
                home: FoodAppLogin(),
              );
            } else {
              return MaterialApp(
                theme: ThemeData(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xffFF9431),
                  ),
                  useMaterial3: true,
                  textTheme: GoogleFonts.poppinsTextTheme(),
                ),
                home: BottomNavBar(),
                debugShowCheckedModeBanner: false,
              );
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
