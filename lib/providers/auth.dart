import 'dart:convert';

import 'package:cubicle/models/http_exception.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate (String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyD4TNdT0XK0sj0cUzMkTqPRE2JoBmFmnmE';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
    if (responseData['error'] != null) {
      throw HttpException(responseData['error']['message']);
    }
    _token = responseData['idToken'];
    _userId = responseData['localId'];
    _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseData['expiresIn']),));
    notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp (String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn (String email, String password) async {
   return _authenticate(email, password, 'signInWithPassword');
  }

  void logout () {
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();

  }
}
