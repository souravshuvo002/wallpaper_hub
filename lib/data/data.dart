import 'package:wallpaper_app/models/category_model.dart';

String apiKEY = "563492ad6f91700001000001ee672c31a50e4e62a9bcfc8e8bbe1cab";

List<CategorieModel> getCategories() {
  List<CategorieModel> categoriesList = [];
  CategorieModel categorieModel = new CategorieModel();

  // 1.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/545008/pexels-photo-545008.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Street Art";
  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  // 2.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/704320/pexels-photo-704320.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Wild Life";
  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  // 3.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/34950/pexels-photo.jpg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Nature";
  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  // 4.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/466685/pexels-photo-466685.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "City";
  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  // 5.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/1434819/pexels-photo-1434819.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260";
  categorieModel.categorieName = "Motivation";

  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  // 6.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/2116475/pexels-photo-2116475.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Bikes";
  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  // 7.
  categorieModel.imgUrl =
      "https://images.pexels.com/photos/1149137/pexels-photo-1149137.jpeg?auto=compress&cs=tinysrgb&dpr=2&w=500";
  categorieModel.categorieName = "Cars";
  categoriesList.add(categorieModel);
  categorieModel = new CategorieModel();

  return categoriesList;
}
