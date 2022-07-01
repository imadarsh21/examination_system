import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MathematicsResponse {
  String? quesId;
  String? givenAns;


  MathematicsResponse(this.quesId, this.givenAns);
}

class MathematicsResponses with ChangeNotifier {
  String? token;
  String? userId;
  List<MathematicsResponse>? items;

  MathematicsResponses(this.token, this.userId, this.items);


  Future<void> fetchAndGetMathematicsResponses() async{
    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/mathematicsResponses/$userId.json?auth=$token');

    var response = await http.get(url);
    //debugPrint(json.decode(response.body).toString());

    var extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if(extractedData == null){
      return;
    }
    List<MathematicsResponse> loadedResponse = [];
    extractedData.forEach((quesId, givenAns) {
      loadedResponse.add(MathematicsResponse(quesId, givenAns));
    });
    items =[];
    items = loadedResponse;
    notifyListeners();
  }
}
