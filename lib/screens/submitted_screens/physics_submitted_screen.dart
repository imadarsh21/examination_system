
import 'package:flutter/material.dart';


class PhysicsSubmittedScreen extends StatefulWidget {
  const PhysicsSubmittedScreen({Key? key}) : super(key: key);
  static String namedRoute = "/physics-submitted-screen";

  @override
  _PhysicsSubmittedScreenState createState() => _PhysicsSubmittedScreenState();
}

class _PhysicsSubmittedScreenState extends State<PhysicsSubmittedScreen> {

  @override
  Widget build(BuildContext context) {

    final score = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 300.0, vertical: 200),
        child: SizedBox(
          child: Center(
            child: Text("Your score is $score", style: const TextStyle(
              fontSize: 35
            ),),
          ),
        ),
      ),
    );
  }
}
