import 'package:examination_system/providers/auth.dart';
import 'package:examination_system/providers/responses/chemistry_responses.dart';
import 'package:examination_system/screens/submitted_screens/chemistry_submitted_screen.dart';
import 'package:flutter/material.dart';
import 'package:examination_system/providers/question.dart';
import 'package:examination_system/providers/questions/chemistry_questions.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChemistryQuestionsList extends StatefulWidget {
  const ChemistryQuestionsList({Key? key}) : super(key: key);

  @override
  State<ChemistryQuestionsList> createState() => _ChemistryQuestionsListState();
}

class _ChemistryQuestionsListState extends State<ChemistryQuestionsList> {
  int? radioValue;
  int? previousRadioValue;
  int score = 0;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    final questionsData = Provider.of<ChemistryQuestions>(context);
    List<Question> questionsList = questionsData.items;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 140.0, vertical: 80),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        "${i + 1}) ${questionsList[i].question}",
                        style: const TextStyle(
                            fontSize: 18.5, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                child: Card(
                  child: Row(
                    children: [
                      Radio(
                          value: 0,
                          groupValue: radioValue,
                          onChanged: (int? value) async {
                            sendResponse(value, i, questionsData);
                          }),
                      Text(
                        questionsList[i].option1,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Card(
                  child: Row(
                    children: [
                      Radio(
                          value: 1,
                          groupValue: radioValue,
                          onChanged: (int? value) async {
                            sendResponse(value, i, questionsData);
                          }),
                      Text(
                        questionsList[i].option2,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Card(
                  child: Row(
                    children: [
                      Radio(
                          value: 2,
                          groupValue: radioValue,
                          onChanged: (int? value) async {
                            sendResponse(value, i, questionsData);
                          }),
                      Text(
                        questionsList[i].option3,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: Card(
                  child: Row(
                    children: [
                      Radio(
                          value: 3,
                          groupValue: radioValue,
                          onChanged: (int? value) async {
                            sendResponse(value, i, questionsData);
                          }),
                      Text(
                        questionsList[i].option4,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                    onPressed: () async {
                      var url = Uri.parse(
                          'https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryResponses/${questionsData.userId}/${questionsData.items[i].id}.json?auth=${questionsData.token}');
                      setState(() {
                        radioValue = null;
                      });
                      await http.delete(url);
                    },
                    child: const Text("Clear Selection")),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (i > 0) {
                              i--;
                              radioValue = previousRadioValue;
                            }
                          });
                        },
                        child: const Text("Previous")),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (i < questionsList.length) {
                              i = (i+1) % questionsList.length;
                              previousRadioValue = radioValue;
                              radioValue = null;
                            }
                          });
                        },
                        child: const Text("Next")),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await Provider.of<ChemistryResponses>(context, listen: false)
                        .fetchAndGetChemistryResponses();
                    getScore();
                    Navigator.of(context).pushNamed(ChemistrySubmittedScreen.namedRoute,
                        arguments: score);
                    Future.delayed(const Duration(seconds: 5))
                        .then((_) async{

                      await Provider.of<Auth>(context, listen: false).logout();
                    });
                  },
                  child: const Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }

  void sendResponse(int? value, int i, ChemistryQuestions questionData) async {
    //debugPrint("sendResponses has been initiated");
    setState(() {
      radioValue = value;
    });
    var url = Uri.parse(
        'https://examination-4e1aa-default-rtdb.firebaseio.com/chemistryResponses/${questionData.userId}/${questionData.items[i].id}.json?auth=${questionData.token}');

    switch (radioValue) {
      case 0:
        {
          await http.put(url,
              body: json.encode(questionData.items[i].option1.toString()));

          break;
        }
      case 1:
        {
          await http.put(url, body: json.encode(questionData.items[i].option2));

          break;
        }
      case 2:
        {
          await http.put(url,
              body: json.encode(questionData.items[i].option3.toString()));

          break;
        }
      case 3:
        {
          await http.put(url,
              body: json.encode(questionData.items[i].option4.toString()));

          break;
        }
    }
  }

  void getScore() {
    List<Question> quesList =
        Provider.of<ChemistryQuestions>(context, listen: false).items;
    List<ChemistryResponse> resList =
    Provider.of<ChemistryResponses>(context, listen: false).items!;
    int k = 0;
    debugPrint(resList.toString());
    for (int i = 0; i < resList.length; i++) {
      int quesIndex =
      quesList.indexWhere((ques) => ques.id == resList[i].quesId);
      if (quesList[quesIndex].correctOption == resList[i].givenAns) {
        debugPrint(
            "inside for loop: ${quesList[quesIndex].correctOption == resList[i].givenAns} ${resList[i].givenAns}");
        setState(() {
          k = k + 1;
          debugPrint(k.toString());
        });
      }
    }
    score = k;
  }
}

