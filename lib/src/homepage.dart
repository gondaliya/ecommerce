import 'package:flutter/material.dart';
import 'package:gonaturo/src/cart.dart';
import 'package:gonaturo/src/profilepage.dart';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "...";
  SharedPreferences prefs;
  var products = new List<Product>();
  var category = new List<Category>();
  ScrollController scr;
  int _cIndex = 0;

  List<BottomNavigationBarItem> btmItem = [
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.home), title: new Text('Home')),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.heart), title: new Text('Wishlist')),
    BottomNavigationBarItem(
        icon: Icon(FontAwesomeIcons.shoppingBag), title: new Text('Cart'))
  ];

  Future<List> _getProducts() async {
    var data =
        await http.get('http://ganature.cycleclinic.tk/api/getproduct.php');
    Iterable list = json.decode(data.body);
    products = list.map((model) => Product.fromJson(model)).toList();
    return products;
  }

  Future<List> _getCategory() async {
    var data =
        await http.get('http://ganature.cycleclinic.tk/api/getcategory.php');
    Iterable list = json.decode(data.body);
    category = list.map((model) => Category.fromJson(model)).toList();
    return products;
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((instance) {
      prefs = instance;
      setState(() {
        userName = prefs.getString('username');
      });
    });

    super.initState();
  }

  dispose() {
    super.dispose();
  }

  Widget searchField() {
    return Padding(
      padding: const EdgeInsets.only(right: 11, top: 12, bottom: 12),
      child: TextField(
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            filled: true,
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.circular(30)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white10, width: 0.0),
                borderRadius: BorderRadius.circular(30)),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.circular(30)),
            hintText: "E.g. Apple, Chips, Potato",
            hintStyle: TextStyle(
                color: Color.fromRGBO(111, 116, 122, 0.4), wordSpacing: 3)),
      ),
    );
  }

  Widget showCatList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 99,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (BuildContext context, int Index) {
            return Padding(
              padding: EdgeInsets.only(right: 12),
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.green),
                      height: 65,
                      width: 65,
                      child: IconButton(
                          icon: Icon(
                            Icons.shop,
                            size: 45,
                          ),
                          onPressed: null)),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("cat" + Index.toString())),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget showProductList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: SizedBox(
        height: 175,
        child: FutureBuilder(
          future: _getProducts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            print(snapshot.data.toString()+"heyyyyyyyy");
            if (snapshot.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Column(
                      children: <Widget>[
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    image: NetworkImage(snapshot.data[index].imageUrl)
                                ),
                                color: Colors.green),
                            height: 120,
                            width: 120,
                            child: IconButton(
                                icon: Icon(Icons.shop, size: 45), onPressed: null)),
                        Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: SizedBox(
                            width: 120,
                            child: Center(
                                child: Text(
                                    snapshot.data[index].name,
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1),
                          child: SizedBox(
                            width: 120,
                            child: Center(
                                child: Text(
                                    snapshot.data[index].priceToShow.toString(),
                                  softWrap: true,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget wlcmTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Text(
        "Hi, " + userName.toString(),
        style: TextStyle(color: Colors.black),
      ),
    );
  }

  Widget profilePic() {
    return CircleAvatar(
        backgroundColor: Colors.green,
        child: IconButton(
            icon: Icon(Icons.perm_identity,
                color: Color.fromRGBO(255, 255, 255, 0.7)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ProfilePage()))));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            children: <Widget>[profilePic(), wlcmTitle()],
          ),
          actions: <Widget>[],
          titleSpacing: 10,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 8),
          controller: scr,
          child: Column(
            children: <Widget>[
              searchField(),
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Category",
                      style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                    ),
                    showCatList(),
                    Text(
                      "Fresh New Item",
                      style: TextStyle(fontSize: 18, letterSpacing: 0.5),
                    ),
                    showProductList()
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.green,
          elevation: 0,
          currentIndex: _cIndex,
          items: btmItem,
          onTap: (select) {
            setState(() {
              if (select == 2) {
                _cIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CartPage()));
              }
            });
          },
        ),
      ),
    );
  }
}

class Category {
  String id;
  String name;
  String image;

  Category(this.id, this.name, this.image);

  Category.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        image = json['image'];
}

class Product {
  String id;
  String name;
  String priceToShow;
  String imageUrl;

  Product(this.id, this.name, this.priceToShow, this.imageUrl);

  Product.fromJson(Map json)
      : id = json['id'],
        name = json['name'],
        priceToShow = json['price_to_show'],
        imageUrl = json['images'];
}

//FutureBuilder(
//future: _getProducts(),
//builder: (BuildContext context, AsyncSnapshot snapshot) {
//print(snapshot.data);
//if (snapshot.data == null) {
//return Container(child: Center(child: Text("Loading...")));
//} else {
//return ListView.builder(
//itemCount: snapshot.data.length,
//itemBuilder: (BuildContext context, int index) {
//return ListTile(
//title: Text(snapshot.data[index].name),
//subtitle: Text(snapshot.data[index].price + " INR"),
//);
//},
//);
//}
//},
//),



//ListView.builder(
//physics: BouncingScrollPhysics(),
//scrollDirection: Axis.horizontal,
//itemCount: 10,
//itemBuilder: (BuildContext context, int Index) {
//return Padding(
//padding: EdgeInsets.only(right: 12),
//child: Column(
//children: <Widget>[
//Container(
//decoration: BoxDecoration(
//borderRadius: BorderRadius.circular(20),
//color: Colors.green),
//height: 143,
//width: 143,
//child: IconButton(
//icon: Icon(Icons.shop, size: 45), onPressed: null)),
//Padding(
//padding: const EdgeInsets.all(8.0),
//child: Center(child: Text("cat" + Index.toString())),
//)
//],
//),
//);
//},
//)