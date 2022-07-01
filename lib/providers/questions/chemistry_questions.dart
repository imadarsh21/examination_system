import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:examination_system/providers/question.dart';
import 'package:http/http.dart' as http;

import '../../model/http_exception.dart' as exception;
class ChemistryQuestions with ChangeNotifier {

  List<Question> _items = [];

  String? token;
  String? userId;

  ChemistryQuestions(this.token, this.userId, this._items);

  Question findById(String? id) {
    return items.firstWhere((ques) => ques.id == id);
  }

  List<Question> get items {
    return [..._items]; //just returning the copy of our _items list
  }

  Future<void> fetchAndSetQuestions() async {

    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryQuestions.json?auth=$token');
    try {
      var response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      // debugPrint("here we go : $extractedData");
      if(extractedData == null){
        return;
      }

      final List<Question> loadedQuestions = [];
      extractedData.forEach((quesId, quesData) {
        loadedQuestions.add(Question(
            id: quesId,
            question: quesData["question"],
            option1: quesData["option1"],
            option2: quesData["option2"],
            option3: quesData["option3"],
            option4: quesData["option4"],
            correctOption: quesData["correctOption"]
        ));
      });
      _items = loadedQuestions;
      notifyListeners();
      // debugPrint("${json.decode(response.body)}");
    } catch (error) {
      rethrow;
    }

    // var url = Uri.parse(
    //     'https://examination-system-38b70-default-rtdb.firebaseio.com/questions.json?auth=$token');

  }

  Future<void> addQuestion(Question question) async {

    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryQuestions.json?auth=$token');
    //here you don't need to put return statement since we are using async,
    // it returns futures automatically and also wrap things written inside that async function into future
    try {
      final response = await http.post(url, body: json.encode({
        "question": question.question,
        "option1": question.option1,
        "option2": question.option2,
        "option3" : question.option3,
        "option4" : question.option4,
        "correctOption" : question.correctOption,
      }));
      Question newQuestion = Question(
          id: json.decode(response.body)["name"],
          question: question.question,
          option1: question.option1,
          option2: question.option2,
          option3: question.option3,
          option4: question.option4
      );
      _items.add(
          newQuestion); //adds the question at the last of the list, _items.insert(0, newQuestion) will add the question item at the beginning
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    // final url = Uri.parse(
    //     "https://examination-system-38b70-default-rtdb.firebaseio.com/questions.json?auth=$token");


  }

  Future<void> updateQuestion(String? questionId, Question newQuestion) async{

    final questionIndex = _items.indexWhere((ques) =>
    ques.id == questionId); //returns index
    if (questionIndex >= 0) {
      final url = Uri.parse(
          "https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryQuestions/$questionId.json?auth=$token");
      await http.patch(url, body: json.encode({
        "question" : newQuestion.question,
        "option1" : newQuestion.option1,
        "option2" : newQuestion.option2,
        "option3" : newQuestion.option3,
        "option4" : newQuestion.option4,
        "correctOption" : newQuestion.correctOption
      }));
      _items[questionIndex] = newQuestion;
      notifyListeners();
    }
    else{}
  }

  Future<void> removeQuestion(String questionId) async{
    //here, we will use the optimistic updating

    final url = Uri.parse(
        "https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryQuestions/$questionId.json?auth=$token");
    final existingQuestionIndex = _items.indexWhere((ques) => ques.id == questionId);
    Question? existingQuestion = _items[existingQuestionIndex];
    _items.removeAt(existingQuestionIndex);
    notifyListeners();

    var response = await http.delete(url);
    //this expression indicates an error in case of deleting
    if(response.statusCode >= 400){
      _items.insert(existingQuestionIndex, existingQuestion);
      notifyListeners();
      throw exception.HttpException("Could not delete the question");
    }

    existingQuestion = null; //it never executes if there is any kind of error in deleting from database


  }
}