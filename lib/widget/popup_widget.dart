import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class PopupWidget extends StatefulWidget {
  final String url;
  const PopupWidget({Key? key, required this.url});

  @override
  _PopupWidgetState createState() => _PopupWidgetState();
}

enum menuitem { item1, item2, item3, item4 }

class _PopupWidgetState extends State<PopupWidget> {
  menuitem? _mitem = menuitem.item1;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey[200],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Set As:',
                    style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
          ListTile(
            minVerticalPadding: 0,
            title: const Text('Home Screen'),
            trailing: Radio<menuitem>(
              activeColor: Colors.green,
              value: menuitem.item1,
              groupValue: _mitem,
              onChanged: (menuitem? value) {
                setState(() {
                  _mitem = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Lock Screen'),
            trailing: Radio<menuitem>(
              value: menuitem.item2,
              activeColor: Colors.green,
              groupValue: _mitem,
              onChanged: (menuitem? value) {
                setState(() {
                  _mitem = value;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Home & Lock Screen'),
            trailing: Radio<menuitem>(
              activeColor: Colors.green,
              value: menuitem.item3,
              groupValue: _mitem,
              onChanged: (menuitem? value) {
                setState(() {
                  _mitem = value;
                });
              },
            ),
          ),
          Center(
            child: TextButton(
              onPressed: () {
                if (_mitem == menuitem.item1) {
                  setHomeScreenWallpaper(widget.url, context);
                } else if (_mitem == menuitem.item2) {
                  setLockScreenWallpaper(widget.url, context);
                } else if (_mitem == menuitem.item3) {
                  setBothScreenWallpaper(widget.url, context);
                }
                Navigator.of(context).pop();
              },
              child: Container(
                  width: 160,
                  height: 40,
                  decoration: const BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  child: const Center(
                    child: Text('APPLY',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> setHomeScreenWallpaper(String url, BuildContext context) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Wallpaper Applied.'),
      duration: const Duration(milliseconds: 500),
    ));
    Navigator.pop(context);

    int location = WallpaperManager.HOME_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
  } on PlatformException {}
}

Future<void> setLockScreenWallpaper(String url, BuildContext context) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Wallpaper Applied.'),
      duration: const Duration(milliseconds: 500),
    ));
    Navigator.pop(context);

    int location = WallpaperManager.LOCK_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
  } on PlatformException {}
}

Future<void> setBothScreenWallpaper(String url, BuildContext context) async {
  try {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Wallpaper Applied.'),
      duration: const Duration(milliseconds: 500),
    ));
    Navigator.pop(context);

    int location = WallpaperManager.BOTH_SCREEN;
    var file = await DefaultCacheManager().getSingleFile(url);
    await WallpaperManager.setWallpaperFromFile(file.path, location);
  } on PlatformException {}
}
