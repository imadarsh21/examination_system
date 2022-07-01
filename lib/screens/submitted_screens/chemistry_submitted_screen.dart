
import 'package:flutter/material.dart';


class ChemistrySubmittedScreen extends StatefulWidget {
  const ChemistrySubmittedScreen({Key? key}) : super(key: key);
  static String namedRoute = "/chemistry-submitted-screen";

  @override
  _ChemistrySubmittedScreenState createState() => _ChemistrySubmittedScreenState();
}

class _ChemistrySubmittedScreenState extends State<ChemistrySubmittedScreen> {

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
