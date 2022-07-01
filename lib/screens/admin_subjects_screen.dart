import 'package:examination_system/providers/questions/biology_questions.dart';
import 'package:examination_system/providers/questions/chemistry_questions.dart';
import 'package:examination_system/providers/questions/mathematics_questions.dart';
import 'package:examination_system/providers/questions/physics_questions.dart';
import 'package:examination_system/screens/admin_question_screens/admin_biology_question_screen.dart';
import 'package:examination_system/screens/admin_question_screens/admin_chemistry_question_screen.dart';
import 'package:examination_system/screens/admin_question_screens/admin_mathematics_question_screen.dart';
import 'package:examination_system/screens/admin_question_screens/admin_physics_question_screen.dart';
import 'package:examination_system/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminSubjectsScreen extends StatelessWidget {
  const AdminSubjectsScreen({Key? key}) : super(key: key);

  static String namedRoute = "/admin-subjects-screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Subjects"),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 385, top: 100),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(220, 20, 60, 0.85),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                            child: Text("Physics",
                                style: TextStyle(fontSize: 40))),
                      ),
                      onTap: () async {
                        await Provider.of<PhysicsQuestions>(context,
                            listen: false)
                            .fetchAndSetQuestions();
                        Navigator.of(context)
                            .pushNamed(AdminPhysicsQuestionScreen.namedRoute);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                            child: Text("Chemistry",
                                style: TextStyle(fontSize: 40))),
                      ),
                      onTap: () async {
                        await Provider.of<ChemistryQuestions>(context,
                            listen: false)
                            .fetchAndSetQuestions();
                        Navigator.of(context)
                            .pushNamed(AdminChemistryQuestionScreen.namedRoute);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                            child: Text("Biology",
                                style: TextStyle(fontSize: 40))),
                      ),
                      onTap: () async {
                        await Provider.of<BiologyQuestions>(context,
                            listen: false)
                            .fetchAndSetQuestions();
                        Navigator.of(context)
                            .pushNamed(AdminBiologyQuestionScreen.namedRoute);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: Container(
                        width: 350,
                        height: 200,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(220, 20, 60, 0.85),
                            borderRadius: BorderRadius.circular(25)),
                        child: const Center(
                            child: Text("Mathematics",
                                style: TextStyle(fontSize: 40))),
                      ),
                      onTap: () async {
                        await Provider.of<MathematicsQuestions>(context,
                            listen: false)
                            .fetchAndSetQuestions();
                        Navigator.of(context).pushNamed(
                            AdminMathematicsQuestionScreen.namedRoute);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}
