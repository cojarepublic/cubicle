import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;


  Product({
    @required this.title,
    @required this.imageUrl,
    @required this.id,
    @required this.price,
    @required this.description,
    this.isFavorite = false,
  });

  void changeFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

}
