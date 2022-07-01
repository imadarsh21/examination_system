import 'package:examination_system/screens/examination_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  String? userName = "";
  String? roll = "";


  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId{
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String value, {String fullName = "", String dob = "", String rollNumber = ""}) async {
    var url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$value?key=AIzaSyCICo1jZWdfbu4WqS_OpGSxMbZkyrSHIQg");
    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      var responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        // debugPrint(responseData["error"]["message"].toString());
        // debugPrint("${HttpException("hello")}");
        throw HttpException(responseData["error"]["message"]);
      }
      // debugPrint(responseData.toString());
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate =
          DateTime.now().add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _autoLogout();

      //in shared preferences we keep thing is key value pair
      final prefs = await SharedPreferences.getInstance();
      // debugPrint("instance has been created");

      notifyListeners();

      //this will create a string of the data you pass in it which makes it easier to store
      final userData = json.encode({
        "token" : _token,
        "userId" : _userId,
        "expiryDate" : _expiryDate!.toIso8601String()
      });
      prefs.setString("userData", userData); //key, value
      // debugPrint("strings have been set");

      if(value == "signUp"){
        var url = Uri.parse(
            'https://examination-4e1aa-default-rtdb.firebaseio.com/users/$userId.json?auth=$token');
        await http.post(url, body: json.encode({
          "fullName" : fullName,
          "dob" : dob,
          "email" : email,
          "rollNumber" : rollNumber
        }));

      }

    } catch (error) {
      //this error comes if something wrong happens in the http request or response
      // debugPrint(error.toString());
      rethrow;
    }
  }

  Future<void> signup(String email, String password, String fullName, String dob, String rollNumber) async {
    return _authenticate(email, password, "signUp", fullName: fullName, dob: dob, rollNumber: rollNumber);
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }

  Future<bool> tryAutoLogin() async{
    // debugPrint("tryautologin running ");
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey("userData")){
      // debugPrint("does not contain key");
      return false;
    }
    final extractedUserData = json.decode(prefs.getString("userData")!) as Map<String, dynamic>;
    // debugPrint("user data : $extractedUserData");
    final expiryDate = DateTime.parse(extractedUserData["expiryDate"]!);
    // debugPrint("expiry date: $expiryDate");
    
    if(expiryDate.isBefore(DateTime.now())){
      // debugPrint("expiryDate is before today");
      return false;
    }
    // debugPrint("successful");
    _token = extractedUserData["token"];
    _userId = extractedUserData["userId"];
    _expiryDate = expiryDate;

    notifyListeners();
    _autoLogout();
    // debugPrint("started autologout");
    return true;

  }

  Future<void> logout() async{
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(_authTimer != null){
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();

    ExaminationHomeScreen.fetchedName = "User";

    //here ae are creating an instance to the object in which userdata has been stored, this is how it works in shared preferences
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove("userData"); when you want to remove a specific data from shared preferences on your device
    prefs.clear(); //when you want to clear everything


  }

  void _autoLogout(){
    if(_authTimer != null){
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }


  Future<void> getName() async{
    // name = x;

    var url1 = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/users/$userId.json?auth=$token');
    final user =  await http.get(url1);

    final userDetails = json.decode(user.body) as Map<String, dynamic>;

    // debugPrint("getName: $userDetails}");

    userDetails.forEach((key, value) {
      // debugPrint("name: ${value["fullName"]}");
      userName = value["fullName"];
    });

  }

  Future<void> getRoll() async{
    // name = x;

    var url1 = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/users/$userId.json?auth=$token');
    final user =  await http.get(url1);

    final userDetails = json.decode(user.body) as Map<String, dynamic>;

    // debugPrint("getName: $userDetails}");

    userDetails.forEach((key, value) {
      // debugPrint("name: ${value["fullName"]}");
      roll = value["rollNumber"];
    });

  }

}
