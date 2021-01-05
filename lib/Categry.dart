import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/data/models/Wallpaper_model.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/imageView.dart';
class Categryies extends StatefulWidget {
  String categriesname;
  Categryies({this.categriesname});
  @override
  _CategryiesState createState() => _CategryiesState();
}

class _CategryiesState extends State<Categryies> {
    bool _loading=true;
  
  List<Wallpapermodel> wallpapers = List();
 getCategrywallpaper(String query) async {
    String url = "https://api.pexels.com/v1/search?query=$query&per_page";
    var response = await http.get(url, headers: {"Authorization": apikey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      Wallpapermodel wallpapermodel = new Wallpapermodel();
      wallpapermodel = Wallpapermodel.fromMap(element);
      wallpapers.add(wallpapermodel);
    });
  }
TextEditingController searchtext=new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 
    getCategrywallpaper(widget.categriesname);
  
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
         leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios,size: 25,color: Colors.black,),),
        centerTitle: true,
        title:RichText(
  text: TextSpan(
    text: 'Wallpaper ',
    style: TextStyle(color: Colors.black),
    children: <TextSpan>[
      TextSpan(text: 'Hub', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue,fontSize: 20)),
     
    ],
  ),
)
      ),
       body: SingleChildScrollView(child: 
       Container(child: categrywallpaperList(),)
       
       ),
    );
  }
   Widget categrywallpaperList() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        childAspectRatio: 0.6,
        crossAxisSpacing: 6.0,
        mainAxisSpacing: 6.0,
        physics: ClampingScrollPhysics(),
        children: wallpapers.map((e) {
          return GestureDetector(
            onTap: (){
                Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                ImageView(
        imageurl: e.src.portrait,
                )
        ));
            },
            child: (
         GridTile(
                  child: Hero(
                    tag: e.src.portrait,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(e.src.portrait,fit: BoxFit.cover,)),
                ),
              )
         )
            ),
          );
        }).toList(),
      ),
    );
  }
}
