import 'package:examination_system/providers/auth.dart';
import 'package:examination_system/screens/examination_home_screen.dart';
import 'package:examination_system/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examination_system/providers/questions/physics_questions.dart';
import '../../widgets/questions_lists/physics_questions_list.dart';

class PhysicsQuestionsScreen extends StatefulWidget {
  const PhysicsQuestionsScreen({Key? key}) : super(key: key);

  static String namedRoute = "/physics-questions-screen";

  static String? name;
  static String? fetchedName = "User";
  static String? roll;
  static String? fetchedRoll = "";

  @override
  State<PhysicsQuestionsScreen> createState() => _PhysicsQuestionsScreenState();
}

class _PhysicsQuestionsScreenState extends State<PhysicsQuestionsScreen> {

  @override
  void initState() {
    Provider.of<Auth>(context, listen: false).getName().then((_) {
      PhysicsQuestionsScreen.name =
      Provider.of<Auth>(context, listen: false).userName!;
    });
    Provider.of<Auth>(context, listen: false).getRoll().then((_) {
      ExaminationHomeScreen.roll =
      Provider.of<Auth>(context, listen: false).roll!;
    });
    // debugPrint("inside init");
    super.initState();
  }

  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
        // debugPrint("isInit has been set to true");
      });
        Provider.of<PhysicsQuestions>(context)
            .fetchAndSetQuestions()
            .then((_) {
          // debugPrint("products have been accessed");
          setState(() {
            _isLoading = false;
          });
        });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      PhysicsQuestionsScreen.fetchedName = ExaminationHomeScreen.name;
      PhysicsQuestionsScreen.fetchedRoll = ExaminationHomeScreen.roll;
      // debugPrint("inside set state");
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "All the best!",
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: SizedBox(
                child: Row(
                  children: [
                    const CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person, color: Colors.black87,)
                    ),
                    const SizedBox(width: 5,),
                    Text(PhysicsQuestionsScreen.fetchedName?? "User", style: const TextStyle(color: Colors.black87)),
                  ],
                ),
              ),
            ),

            const Icon(Icons.arrow_right_sharp),
            Padding(
              padding: const EdgeInsets.only(right: 28.0),
              child: Center(child: Text(PhysicsQuestionsScreen.fetchedRoll?? "Roll No", style: const TextStyle(color: Colors.black87),)),
            ),

          ],
        ),
        drawer: const AppDrawer(),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : const PhysicsQuestionsList());
  }
}
