import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/screens/home_screens.dart';
import 'package:recetario/screens/login_screen.dart';
import 'package:recetario/service/services.dart';

class CheckAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final authServer = Provider.of<AuthServer>( context, listen: false );
    return Scaffold(
      body: Center(
        child:FutureBuilder(
          future:authServer.readToken() ,
          builder:(BuildContext context, AsyncSnapshot<String> snapshop){

            if ( !snapshop.hasData ){
            
            
            return Text('');
            }
             if ( snapshop.data == ''){
             
              Future.microtask(() {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder: ( _, __ , ___ ) => LoginScreen(),
                  transitionDuration: Duration(seconds: 0)
                )
               );  
              });
            } else{
            
              Future.microtask(() {
                Navigator.pushReplacement(context, PageRouteBuilder(
                  pageBuilder:( _, __ , ___ ) => HomeScreen(),
                  transitionDuration: Duration(seconds: 0)
                )
               );  
              });
            
            }
            

            return Container();
          }  
        )
      )
    );
  }
}