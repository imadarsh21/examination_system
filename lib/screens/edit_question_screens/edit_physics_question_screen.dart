import 'package:examination_system/providers/question.dart';
import 'package:examination_system/providers/questions/physics_questions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditPhysicsQuestionScreen extends StatefulWidget {
  const EditPhysicsQuestionScreen({Key? key}) : super(key: key);
  static String namedRoute = "/edit-physics-question";

  @override
  _EditPhysicsQuestionScreenState createState() => _EditPhysicsQuestionScreenState();
}

class _EditPhysicsQuestionScreenState extends State<EditPhysicsQuestionScreen> {
  bool _isLoading = false;

  // final _priceFocusNode = FocusNode();
  // final _descriptionFocusNode = FocusNode();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedQuestion = Question(
      id: null,
      question: '',
      option1: '',
      option2: "",
      option3: '',
      option4: "");

  var _initValues = {
    "question": "",
    "option1": "",
    "option2": "",
    "option3": "",
    "option4": "",
    "correctOption": ""
  };

  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final questionId = ModalRoute.of(context)!.settings.arguments;
      // debugPrint("inside override");
      if (questionId != null) {
        // debugPrint("inside editing");
        _editedQuestion =
            Provider.of<PhysicsQuestions>(context).findById(questionId.toString());
        _initValues = {
          "question": _editedQuestion.question,
          "option1": _editedQuestion.option1,
          "option2": _editedQuestion.option2,
          "option3": _editedQuestion.option3,
          "option4": _editedQuestion.option4,
          "correctOption": _editedQuestion.correctOption,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  // //this override helps us to dispose the value stored in memory when not in use
  // @override
  // void dispose() {
  //   _priceFocusNode.dispose();
  //   _descriptionFocusNode.dispose();
  //   _imageUrlFocusNode.dispose();
  //   _imageUrlController.dispose();
  //   super.dispose();
  // }

  Future<void> _saveForm() async {
    final _isValid = _form.currentState!.validate();
    if (!_isValid) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedQuestion.id == null) {
      // debugPrint("inside add question ");

      try {
        await Provider.of<PhysicsQuestions>(context, listen: false)
            .addQuestion(_editedQuestion);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: const Text("An error occurred."),
                  content: const Text("Something went wrong."),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text("OK"))
                  ],
                ));
      }
    } else {
      // debugPrint("inside update question");
      await Provider.of<PhysicsQuestions>(context, listen: false)
          .updateQuestion(_editedQuestion.id, _editedQuestion);
    }

    setState(() {
      _isLoading = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _editedQuestion.id == null
            ? const Text("Add Question ")
            : const Text("Edit Question"),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Question",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                        ),
                      ),
                      maxLines: 5,
                      textInputAction: TextInputAction.next,
                      initialValue: _initValues["question"],
                      validator: (data) {
                        if (data!.isEmpty) {
                          return "Please enter the question";
                        }
                        //in validator returning null means everything is good and returning
                        // a string means there's some problem so show the returned text on the screen as an error
                        return null;
                      },
                      onSaved: (value) => _editedQuestion = Question(
                          id: _editedQuestion.id,
                          question: value!,
                          option1: _editedQuestion.option1,
                          option2: _editedQuestion.option2,
                          option3: _editedQuestion.option3,
                          option4: _editedQuestion.option4,
                          correctOption: _editedQuestion.correctOption),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Option1",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                        ),
                      ),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      initialValue: _initValues["option1"],
                      validator: (data) {
                        if (data!.isEmpty) {
                          return "Please enter option1";
                        }
                        return null;
                      },
                      onSaved: (value) => _editedQuestion = Question(
                          id: _editedQuestion.id,
                          question: _editedQuestion.question,
                          option1: value!,
                          option2: _editedQuestion.option2,
                          option3: _editedQuestion.option3,
                          option4: _editedQuestion.option4,
                          correctOption: _editedQuestion.correctOption),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Option2",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      initialValue: _initValues["option2"],
                      validator: (data) {
                        if (data!.isEmpty) {
                          return "Please enter Option2";
                        }
                        return null;
                      },
                      onSaved: (value) => _editedQuestion = Question(
                          id: _editedQuestion.id,
                          question: _editedQuestion.question,
                          option1: _editedQuestion.option1,
                          option2: value!,
                          option3: _editedQuestion.option3,
                          option4: _editedQuestion.option4,
                          correctOption: _editedQuestion.correctOption),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Option3",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      initialValue: _initValues["option3"],
                      validator: (data) {
                        if (data!.isEmpty) {
                          return "Please enter Option3";
                        }
                        return null;
                      },
                      onSaved: (value) => _editedQuestion = Question(
                          id: _editedQuestion.id,
                          question: _editedQuestion.question,
                          option1: _editedQuestion.option1,
                          option2: _editedQuestion.option2,
                          option3: value!,
                          option4: _editedQuestion.option4,
                          correctOption: _editedQuestion.correctOption),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Option4",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      initialValue: _initValues["option4"],
                      validator: (data) {
                        if (data!.isEmpty) {
                          return "Please enter Option4";
                        }
                        return null;
                      },
                      onSaved: (value) => _editedQuestion = Question(
                          id: _editedQuestion.id,
                          question: _editedQuestion.question,
                          option1: _editedQuestion.option1,
                          option2: _editedQuestion.option2,
                          option3: _editedQuestion.option3,
                          option4: value!,
                          correctOption: _editedQuestion.correctOption),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "correctOption",
                        labelStyle: TextStyle(color: Colors.black54),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.75)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(0, 0, 0, 0.85)),
                        ),
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      initialValue: _initValues["correctOption"],
                      validator: (data) {
                        if (data!.isEmpty) {
                          return "Please enter correctOption";
                        }
                        return null;
                      },
                      onSaved: (value) => _editedQuestion = Question(
                          id: _editedQuestion.id,
                          question: _editedQuestion.question,
                          option1: _editedQuestion.option1,
                          option2: _editedQuestion.option2,
                          option3: _editedQuestion.option3,
                          option4: _editedQuestion.option4,
                          correctOption: value!),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  inputAction() {
    setState(() {
      TextInputAction.done;
    });
  }
}
