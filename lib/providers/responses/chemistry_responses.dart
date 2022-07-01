import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChemistryResponse {
  String? quesId;
  String? givenAns;


  ChemistryResponse(this.quesId, this.givenAns);
}

class ChemistryResponses with ChangeNotifier {
  String? token;
  String? userId;
  List<ChemistryResponse>? items;

  ChemistryResponses(this.token, this.userId, this.items);


  Future<void> fetchAndGetChemistryResponses() async{
    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryResponses/$userId.json?auth=$token');

    var response = await http.get(url);
    //debugPrint(json.decode(response.body).toString());

    var extractedData = json.decode(response.body) as Map<String, dynamic>?;

    if(extractedData == null){
      return;
    }
    List<ChemistryResponse> loadedResponse = [];
    extractedData.forEach((quesId, givenAns) {
      loadedResponse.add(ChemistryResponse(quesId, givenAns));
    });
    items =[];
    items = loadedResponse;
    notifyListeners();
  }
}
