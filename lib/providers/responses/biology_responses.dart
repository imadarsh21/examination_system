import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BiologyResponse {
  String? quesId;
  String? givenAns;


  BiologyResponse(this.quesId, this.givenAns);
}

class BiologyResponses with ChangeNotifier {
  String? token;
  String? userId;
  List<BiologyResponse>? items;

  BiologyResponses(this.token, this.userId, this.items);


  Future<void> fetchAndGetBiologyResponses() async{
    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/biologyResponses/$userId.json?auth=$token');

    var response = await http.get(url);
    //debugPrint(json.decode(response.body).toString());

    var extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if(extractedData == null){
      return;
    }
    List<BiologyResponse> loadedResponse = [];
    extractedData.forEach((quesId, givenAns) {
      loadedResponse.add(BiologyResponse(quesId, givenAns));
    });
    items =[];
    items = loadedResponse;
    notifyListeners();
  }
}
