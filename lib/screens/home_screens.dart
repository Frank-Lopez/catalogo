import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recetario/screens/screen.dart';
import 'package:recetario/service/services.dart';
import 'package:recetario/widget/widget.dart';
import 'package:recetario/model/models.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final producServer = Provider.of<ProductsServices>(context);
    final authServer = Provider.of<AuthServer>(context, listen: false);

    if (producServer.isLoading) return LoadingScreen();

    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          leading: IconButton(
            icon: Icon(Icons.login_outlined),
            onPressed: () {
              authServer.logout();
              Navigator.pushReplacementNamed(context, 'login');
            },
          ),
        ),
        body: ListView.builder(
          itemCount: producServer.product.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
              onTap: () {
                producServer.selectedProduct =
                    producServer.product[index].copy();
                Navigator.pushNamed(context, 'product');
              },
              child: ProductCard(
                product: producServer.product[index],
              )),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            producServer.selectedProduct =
                Product(available: true, name: '', price: 0);
            Navigator.pushNamed(context, 'product');
          },
        ));
  }
}
