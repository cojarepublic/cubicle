import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  void _setFavValue (bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> changeFavoriteStatus(String token) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = 'https://cubicle-9215d.firebaseio.com/products/$id.json?auth=$token';
    try{
      final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite
      }));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }

  }

}
