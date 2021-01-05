
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
class ImageView extends StatefulWidget {
  final String imageurl;
  ImageView({this.imageurl});
  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imageurl,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                widget.imageurl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
               _save();
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 2,
                        decoration: BoxDecoration(
                            color: Color(0xff1C1B1B).withOpacity(0.8),
                            borderRadius: BorderRadius.circular(28)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color(0x36ffffff),
                              Color(0x0ffffff),
                            ]),
                            // color: Colors.white.withOpacity(0.3),
                            border: Border.all(color: Colors.white60, width: 1),
                            borderRadius: BorderRadius.circular(25)),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Column(
                          children: [
                            Text(
                              "setWallpaper",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Text(
                              "image willbe save in galler",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "cancel",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    if (Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio().get(widget.imageurl,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

   _askPermission() async {
    // if (Platform.isIOS) {
    //   /*Map<PermissionGroup, PermissionStatus> permissions =
    //     */await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // } else {
    // /* PermissionStatus permission = */await PermissionHandler()
    //       .checkPermissionStatus(PermissionGroup.storage);


    // }

  }
  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }
  
}

