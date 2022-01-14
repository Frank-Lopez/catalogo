import 'package:flutter/material.dart';
import 'package:recetario/model/models.dart';


class ProductFormProvider extends ChangeNotifier {
  
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();


  Product product;

  ProductFormProvider(this.product);

  updateAvailability(bool value){
    print(value);
    this.product.available = value;
    notifyListeners();
  }

  bool isValidForm(){

    print(product.name);
    print(product.price);
    print(product.available);
  
    return formkey.currentState?.validate() ?? false;
  }


}