import 'package:flutter/material.dart';

class NotificationsService {

   static GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String messeage){
  
    final snackBar = SnackBar(
      content: Text(messeage, style: TextStyle(color: Colors.red, fontSize: 20),),
      );

      messengerKey.currentState.showSnackBar(snackBar);
  
  }
  
}