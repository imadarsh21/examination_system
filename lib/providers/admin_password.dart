import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AdminPassword with ChangeNotifier{

  int? pass;
  String? token;
  AdminPassword(this.token);



  Future<void> fetchPassword() async{
    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/specialPassword.json?auth=$token');

    var response = await http.get(url);
    final extractedData = json.decode(response.body) as int?;
    // debugPrint("here we go : $extractedData");
    if(extractedData == null){
      return;
    }
    pass = extractedData;
    notifyListeners();

  }


}