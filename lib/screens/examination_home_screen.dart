import 'package:examination_system/providers/auth.dart';
import 'package:examination_system/screens/questions_screens/biology_questions_screen.dart';
import 'package:examination_system/screens/questions_screens/chemistry_questions_screen.dart';
import 'package:examination_system/screens/questions_screens/mathematics_questions_screen.dart';
import 'package:examination_system/screens/questions_screens/physics_questions_screen.dart';
import 'package:examination_system/widgets/app_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExaminationHomeScreen extends StatefulWidget {
  const ExaminationHomeScreen({Key? key}) : super(key: key);

  static String namedRoute = "/admin-subjects-screen";
  static String? name;
  static String? fetchedName = "User";
  static String? roll;
  static String? fetchedRoll = "";

  @override
  State<ExaminationHomeScreen> createState() => _ExaminationHomeScreenState();
}

class _ExaminationHomeScreenState extends State<ExaminationHomeScreen> {
  @override
  void initState() {
    super.initState();

    Provider.of<Auth>(context, listen: false).getName().then((_) {
      ExaminationHomeScreen.name =
          Provider.of<Auth>(context, listen: false).userName!;
    });

    Provider.of<Auth>(context, listen: false).getRoll().then((_) {
      ExaminationHomeScreen.roll =
      Provider.of<Auth>(context, listen: false).roll!;
    });
    // debugPrint("inside init");
  }



  @override
  Widget build(BuildContext context) {
    setState(() {
      ExaminationHomeScreen.fetchedName = ExaminationHomeScreen.name;
      ExaminationHomeScreen.fetchedRoll = ExaminationHomeScreen.roll;
      // debugPrint("inside set state");
    });

    // debugPrint("inside build now");

    return Scaffold(
      appBar: AppBar(
        title: const Text("All The Best!"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: SizedBox(
              child: Row(
                children: const [
                  CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(
                        Icons.person,
                        color: Colors.black87,
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Text("",
                      style: TextStyle(color: Colors.black87)),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              await Provider.of<Auth>(context, listen: false).logout();
            },
            icon: const Icon(Icons.logout),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 28.0),
            child: Center(
                child: Text(
              "Logout",
              style: TextStyle(color: Colors.black87),
            )),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                // image: DecorationImage(
                //     image: NetworkImage(
                //         "https://cdn.pixabay.com/photo/2019/10/22/05/52/autumn-leaves-4567704_960_720.jpg"),
                //     fit: BoxFit.fill),
            gradient: LinearGradient(colors: [
              Colors.blue,
              Colors.black
            ])
            ),


          ),
          SingleChildScrollView(
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
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(220, 20, 60, 0.6),
                                borderRadius: BorderRadius.circular(25)),
                            width: 350,
                            height: 200,
                            child: const Center(
                                child: Text(
                                  "Physics",
                                  style: TextStyle(fontSize: 40),
                                )),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                PhysicsQuestionsScreen.namedRoute);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(220, 20, 60, 0.55),
                                borderRadius: BorderRadius.circular(25)),
                            child: const Center(
                                child: Text("Chemistry",
                                    style: TextStyle(fontSize: 40))),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                ChemistryQuestionsScreen.namedRoute);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
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
                                color: const Color.fromRGBO(220, 20, 60, 0.6),
                                borderRadius: BorderRadius.circular(25)),
                            child: const Center(
                                child: Text("Biology",
                                    style: TextStyle(fontSize: 40))),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                BiologyQuestionsScreen.namedRoute);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                            width: 350,
                            height: 200,
                            decoration: BoxDecoration(
                                color: const Color.fromRGBO(220, 20, 60, 0.55),
                                borderRadius: BorderRadius.circular(25)),
                            child: const Center(
                                child: Text("Mathematics",
                                    style: TextStyle(fontSize: 40))),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacementNamed(
                                MathematicsQuestionsScreen.namedRoute);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
