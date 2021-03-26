import 'dart:convert';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:minor/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  var authTimer;

  bool get isAuth {
    if (token != null) return true;
    return false;
  }

  String get token {
    if (_expiryDate != null &&
        _token != null &&
        _expiryDate.isAfter(DateTime.now())) return _token;
    return null;
  }
  String get userId{
    return _userId;
  }

  Future<void> signUp(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDrvc4E9EOBJWTEJY8Ema7vHZg2KQTjVyU';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      else{
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn']) ));
        autoLogout();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDrvc4E9EOBJWTEJY8Ema7vHZg2KQTjVyU';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }else{
        _token = responseData['idToken'];
        _userId = responseData['localId'];
        _expiryDate = DateTime.now().add(Duration(seconds:int.parse(responseData['expiresIn']) ));
        autoLogout();
        notifyListeners();
        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'token':_token,
          'expiryDate':_expiryDate.toIso8601String(),
          'userId':_userId,
        });
        prefs.setString('userData', userData);
      }
    } catch (error) {
      throw error;
    }
  }
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    print('a');
    if (!prefs.containsKey('userData')) {
      return false;
    }
    print('b');
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    print('c');
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    print(_token);
    print(_expiryDate.toIso8601String());
    notifyListeners();
    autoLogout();
    return true;
  }
  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    authTimer.cancel();
    authTimer= null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }
  void autoLogout()
  {
      if(authTimer!= null)
      {
        authTimer.cancel();
      }
      int timeLeft = _expiryDate.difference(DateTime.now()).inSeconds;
      authTimer=Timer(Duration(seconds: timeLeft), logout);
  }
}
