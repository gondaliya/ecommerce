import 'package:flutter/material.dart';


class CartPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CartPageState();
  }
}

class _CartPageState extends State<CartPage>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("My Cart"),
      ),
      body: Center(child: Text("cart")),
    );
  }
}