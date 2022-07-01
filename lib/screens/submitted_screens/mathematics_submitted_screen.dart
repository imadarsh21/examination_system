
import 'package:flutter/material.dart';


class MathematicsSubmittedScreen extends StatefulWidget {
  const MathematicsSubmittedScreen({Key? key}) : super(key: key);
  static String namedRoute = "/mathematics-submitted-screen";

  @override
  _MathematicsSubmittedScreenState createState() => _MathematicsSubmittedScreenState();
}

class _MathematicsSubmittedScreenState extends State<MathematicsSubmittedScreen> {

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
