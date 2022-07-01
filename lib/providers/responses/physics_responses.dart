import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PhysicsResponse {
  String? quesId;
  String? givenAns;


  PhysicsResponse(this.quesId, this.givenAns);
}

class PhysicsResponses with ChangeNotifier {
  String? token;
  String? userId;
  List<PhysicsResponse>? items;

  PhysicsResponses(this.token, this.userId, this.items);


  Future<void> fetchAndGetPhysicsResponses() async{
    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/physicsResponses/$userId.json?auth=$token');

    var response = await http.get(url);
    //debugPrint(json.decode(response.body).toString());

    var extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if(extractedData == null){
      return;
    }
    List<PhysicsResponse> loadedResponse = [];
    extractedData.forEach((quesId, givenAns) {
      loadedResponse.add(PhysicsResponse(quesId, givenAns));
    });
    items =[];
    items = loadedResponse;
    notifyListeners();
  }
}
