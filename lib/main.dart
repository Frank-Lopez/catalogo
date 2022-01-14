import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/screens/checck_auth_screen.dart';
import 'package:recetario/screens/register_screen.dart';
import 'package:recetario/screens/screen.dart';

import 'service/services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
    providers: [
      ChangeNotifierProvider(create:  (_) => AuthServer()), 
      ChangeNotifierProvider(create:  (_) => ProductsServices(), 
      ),
    ],
    child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recetario',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'register': (_) => RegisterScreen(),
        'home': (_) => HomeScreen(),
        'product': (_) => ProductScreen(),
        'checking': (_) => CheckAuthScreen()
        
      },
      scaffoldMessengerKey:NotificationsService.messengerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.indigo,
          elevation: 0,
        )
      ),
    );
  }
}
