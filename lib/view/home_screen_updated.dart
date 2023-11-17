import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpaper_app/data/data.dart';
import 'dart:convert';
import 'package:wallpaper_app/models/category_model.dart';
import 'package:wallpaper_app/view/category_screen.dart';
import 'package:wallpaper_app/view/search_view.dart';
import 'package:wallpaper_app/widget/wallpaper_widget.dart';
import '../models/photos_model.dart';

bool showFAB = false;

class HomeScreenUpdated extends StatefulWidget {
  @override
  _HomeScreenUpdatedState createState() => _HomeScreenUpdatedState();
}

class _HomeScreenUpdatedState extends State<HomeScreenUpdated> {
  List<CategorieModel> categoriesList = [];

  int page = 1;

  List<PhotosModel> photosList = [];

  getTrendingWallpaper() async {
    List<PhotosModel> photosList1 = [];
    await http.get(Uri.parse("https://api.pexels.com/v1/curated?per_page=80"),
        headers: {"Authorization": apiKEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);

        photosList1.add(photosModel);
      });

      setState(() {
        photosList.addAll(photosList1);
      });
    });
  }

  loadmore() async {
    List<PhotosModel> photosList2 = [];
    setState(() {
      page = page + 1;
      log(page.toString());
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http
        .get(Uri.parse(url), headers: {'Authorization': apiKEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        //print(element);
        PhotosModel photosModel = new PhotosModel();
        photosModel = PhotosModel.fromMap(element);

        photosList2.add(photosModel);
      });

      setState(() {
        photosList.addAll(photosList2);
      });
    });
  }

  TextEditingController searchController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    //getWallpaper();
    getTrendingWallpaper();
    categoriesList = getCategories();
    super.initState();

    searchController.text = '';

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        showFAB = true;
        loadmore();
      } else if (_scrollController.position.pixels ==
          _scrollController.position.minScrollExtent) {
        setState(() {
          showFAB = false;
        });
      }
    });
  }

  _launchURL(String _url) async {
    if (!await launchUrl(Uri.parse(_url))) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: brandName(),
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f8fd),
                  borderRadius: BorderRadius.circular(30),
                ),
                margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: "Search wallpapers",
                          border: InputBorder.none),
                    )),
                    InkWell(
                        onTap: () {
                          if (searchController.text != "") {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SearchView(
                                              search: searchController.text,
                                            )))
                                .then((value) => searchController.text = '');
                          }
                        },
                        child: Container(child: Icon(Icons.search)))
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Made By ",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: 'Overpass'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL("https://www.facebook.com/astalaavistababy");
                    },
                    child: Container(
                        child: Text(
                      "Sourav Das Shuvo",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontFamily: 'Overpass'),
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                height: 80,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    itemCount: categoriesList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      /// Create List Item tile
                      return CategoriesTile(
                        imgUrls: categoriesList[index].imgUrl ?? "",
                        categorie: categoriesList[index].categorieName ?? "",
                      );
                    }),
              ),
              wallPaper(photosList, context),
              SizedBox(
                height: 24,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Photos provided By ",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                        fontFamily: 'Overpass'),
                  ),
                  GestureDetector(
                    onTap: () {
                      _launchURL("https://www.pexels.com/");
                    },
                    child: Container(
                        child: Text(
                      "Pexels",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontFamily: 'Overpass'),
                    )),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Center(
                child: page == 1
                    ? null
                    : Text(
                        "Page: $page",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Overpass'),
                      ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  height: 24,
                  width: 24,
                ),
              ),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: showFAB
          ? FloatingActionButton(
              backgroundColor: Colors.green,
              child: Icon(Icons.arrow_upward),
              onPressed: () {
                scrollUP();
              },
            )
          : null,
    );
  }

  void scrollUP() {
    final double start = 0;
    _scrollController.animateTo(start,
        duration: Duration(seconds: 1), curve: Curves.easeIn);
    setState(() {
      showFAB = false;
    });
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrls, categorie;

  CategoriesTile({required this.imgUrls, required this.categorie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategorieScreen(
                      categorie: categorie,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: kIsWeb
            ? Column(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(
                              imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                  SizedBox(
                    height: 4,
                  ),
                  Container(
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        categorie,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Overpass'),
                      )),
                ],
              )
            : Stack(
                children: <Widget>[
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: kIsWeb
                          ? Image.network(
                              imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: imgUrls,
                              height: 50,
                              width: 100,
                              fit: BoxFit.cover,
                            )),
                  Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Container(
                      height: 50,
                      width: 100,
                      alignment: Alignment.center,
                      child: Text(
                        categorie,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Overpass'),
                      ))
                ],
              ),
      ),
    );
  }
}
