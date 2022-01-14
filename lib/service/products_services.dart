
import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:recetario/model/models.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {
  
  final String _baseUrl = 'flutter-varios-f939a-default-rtdb.firebaseio.com';
  final List<Product>product =[];
  Product selectedProduct;

  final storage = FlutterSecureStorage();

  File newPictureFile;

  bool isLoading = true;
  bool isSaving = false;

  ProductsServices(){
  this.loadProducts();
  
  }

   Future<List<Product>> loadProducts() async{
   this.isLoading = true;
   notifyListeners();
    final url = Uri.https(_baseUrl, 'product.json',{
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp =await http.get(url);

    final Map<String, dynamic>productsMap = json.decode(resp.body);

    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      this.product.add(tempProduct);
    });

    this.isLoading = false;
    notifyListeners();
    return this.product;
  
  }

  Future saveOrCreateProduct (Product product) async{

  isSaving = true;
  notifyListeners();

  if(product.id == null){
    await this.createProduct(product);
  }else{
    await this.updateProduct(product);
  }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct( Product product) async{
  
    final url = Uri.https(_baseUrl, 'product/${ product.id}.json',{
      'auth': await storage.read(key: 'token') ?? ''
    });
    final resp =await http.put(url, body: product.toJson());
    final decodeData = resp.body;

    final index = this.product.indexWhere((element) => element.id == product.id);
    this.product[index] = product;


    return product.id;

  }

   Future<String> createProduct( Product product) async{
  
    final url = Uri.https(_baseUrl, 'product.json');
    final resp = await http.post(url, body: product.toJson());
    final decodeData = json.decode(resp.body);
 
    product.id = decodeData['name'];

    this.product.add(product);
 
    return product.id;
  }


  void updateSelectedProductImage(String path){

  this.selectedProduct.picture = path;
  this.newPictureFile = File.fromUri(Uri(path: path));

  notifyListeners();
  
  }

  Future<String> uploadImage() async{

    if( this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse('https://api.cloudinary.com/v1_1/dvv1wnx4e/image/upload?upload_preset=ubqptlpt');

    final imageUploadRequest =  http.MultipartRequest('POST', url );

    final file = await http.MultipartFile.fromPath( 'file', newPictureFile.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

  print(resp.body);
    
    if(resp.statusCode != 200 && resp.statusCode != 201){
    
    print('error');
    print(resp.body);
    return null;
    }

    this.newPictureFile = null;

    final decodeData = json.decode(resp.body);
    return decodeData['secure_url'];
  }
}