import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:http/http.dart'as http;
import 'package:wallpaper_app/data/models/Wallpaper_model.dart';

class Search extends StatefulWidget {
  String qury;
  Search({this.qury});
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
 
  
  List<Wallpapermodel> wallpapers = List();
 getsearchwallpaper(String query) async {
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
  searchtext.text=widget.qury;
    getsearchwallpaper(widget.qury);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(onPressed: (){Navigator.pop(context);},icon: Icon(Icons.arrow_back_ios,size: 25,color: Colors.black,),),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "WallPaper",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "Hub",
              style: TextStyle(color: Colors.blue),
            )
          ],
        ),
      ),
    body: SingleChildScrollView(
       child: Container(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(30)),
                child: TextField(
                  controller: searchtext,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "search Wallpaper",
                      suffixIcon: IconButton(
                        onPressed: () {
                 getsearchwallpaper(searchtext.text);
                        },
                        icon: Icon(Icons.search),
                      )),
                ),
              ),
              SizedBox(
                height: 16,
              ),

          Container(child: wallpaperList(),),

            ]
       ),
       ),

    ),

    );
  }
   Widget wallpaperList() {
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
          return GridTile(
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(e.src.portrait,fit: BoxFit.cover,)),
            ),
          );
        }).toList(),
      ),
    );
  }
}