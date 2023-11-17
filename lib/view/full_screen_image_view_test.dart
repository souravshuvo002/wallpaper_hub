import 'dart:developer';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_app/models/photos_model.dart';
import 'package:wallpaper_app/widget/popup_widget.dart';

class FullScreenImageViewTest extends StatefulWidget {
  final PhotosModel photosModel;

  FullScreenImageViewTest({required this.photosModel});

  @override
  _FullScreenImageViewTestState createState() =>
      _FullScreenImageViewTestState();
}

class _FullScreenImageViewTestState extends State<FullScreenImageViewTest> {
  var filePath;
  _launchURL(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log(widget.photosModel.photographerUrl.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.photosModel.src?.portrait ?? "",
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: kIsWeb
                  ? Image.network(widget.photosModel.src?.portrait ?? "",
                      fit: BoxFit.cover)
                  : CachedNetworkImage(
                      imageUrl: widget.photosModel.src?.portrait ?? "",
                      placeholder: (context, url) => Container(
                        color: Color(0xfff5f8fd),
                      ),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Color(0xff1C1B1B).withOpacity(0.6),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        bottomSheet(context);
                      },
                      icon: const Icon(
                        Icons.info,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _save();
                      },
                      icon: const Icon(
                        Icons.save_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => PopupWidget(
                                  url: widget.photosModel.src?.portrait ?? "",
                                ));
                      },
                      icon: const Icon(
                        Icons.text_snippet,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  bottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        context: context,
        builder: (context) => Expanded(
              child: Center(
                child: Text(
                  widget.photosModel.photographer ?? "",
                  style: TextStyle(fontSize: 30),
                ),
              ),
            ));
  }

  _save() async {
    //await _askPermission();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Saving...'),
      duration: const Duration(milliseconds: 500),
    ));
    var response = await Dio().get(widget.photosModel.src?.portrait ?? "",
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    if (result['isSuccess'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Wallpaper Saved.'),
        duration: const Duration(seconds: 1),
      ));
      Navigator.pop(context);
    }
  }

  Future<void> setHomeScreenWallpaper(String url) async {
    try {
      int location = WallpaperManager.HOME_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      // ignore: unused_local_variable
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Wallpaper Applied.'),
        duration: const Duration(seconds: 1),
      ));
      Navigator.pop(context);
    } on PlatformException {}
  }

  Future<void> setLockScreenWallpaper(String url) async {
    try {
      int location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      // ignore: unused_local_variable
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Wallpaper Applied.'),
        duration: const Duration(seconds: 1),
      ));
      Navigator.pop(context);
    } on PlatformException {}
  }

  Future<void> setBothScreenWallpaper(String url) async {
    try {
      int location = WallpaperManager.BOTH_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      print(result);
    } on PlatformException {}
  }

  // _askPermission() async {
  //   if (Platform.isIOS) {
  //     /*Map<PermissionGroup, PermissionStatus> permissions =
  //         */
  //     await PermissionHandler().requestPermissions([PermissionGroup.photos]);
  //   } else {
  //     /* PermissionStatus permission = */ await PermissionHandler()
  //         .checkPermissionStatus(PermissionGroup.storage);
  //   }
  // }
}
