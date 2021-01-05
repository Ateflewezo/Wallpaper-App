import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallpaper_app/Categry.dart';
import 'package:wallpaper_app/Search.dart';
import 'package:wallpaper_app/data/data.dart';
import 'package:wallpaper_app/data/models/CategryModel.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaper_app/data/models/Wallpaper_model.dart';
import 'package:wallpaper_app/imageView.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _loading=true;
  List<CategorieModel> categories = List();
  List<Wallpapermodel> wallpapers = List();
  getTrindingWallpaper() async {
    String url = "https://api.pexels.com/v1/curated?per_page";
    var response = await http.get(url, headers: {"Authorization": apikey});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      Wallpapermodel wallpapermodel = new Wallpapermodel();
      wallpapermodel = Wallpapermodel.fromMap(element);
      wallpapers.add(wallpapermodel);
    }
    
    );
  }
TextEditingController searchtext=new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories = getCategories();
    getTrindingWallpaper();
    setState(() {
          _loading=false;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
      body: _loading?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        
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
                           Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                Search(
           qury: searchtext.text,
                )
        ));
                        },
                        icon: Icon(Icons.search),
                      )),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ListView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CategryTitle(
                      imageUrl: categories[index].imgUrl,
                      title: categories[index].categorieName,
                    );
                  },
                ),
              ),
              SizedBox(height: 10,),
           _loading?CircularProgressIndicator():  Container(
               child:  wallpaperList(),)
            ],
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
          return GestureDetector(
            onTap: (){
               Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                ImageView(
        imageurl: e.src.portrait,
                )
        ));
            },
            child: GridTile(
              child: Hero(
                tag: e.src.portrait,
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(e.src.portrait,fit: BoxFit.cover,)),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CategryTitle extends StatelessWidget {
  String imageUrl;
  String title;
  CategryTitle({@required this.imageUrl, @required this.title});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>
                Categryies(
        categriesname: title.toLowerCase(),
                )
        ));
      }
      ,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        // decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 60,
                  width: 120,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              height: 60,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black26),
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//طريقة اخري لعرض الصور
// Widget wallpaperList() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       child: GridView.builder(
//         itemCount: wallpapers.length,
//         shrinkWrap: true,
//       gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,
//       childAspectRatio: 0.6,
//       crossAxisSpacing: 6.0,
//       mainAxisSpacing: 6.0,
      
//       ),
//         physics: ClampingScrollPhysics(),
//         itemBuilder: (context,index) {
//           return GridTile(
//             child: Container(
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(15),
//                 child: Image.network(wallpapers[index].src.portrait,fit: BoxFit.cover,)),
//             ),
//           );
//         },)
      
//     );
//   }