
import 'package:flutter/material.dart';


class BiologySubmittedScreen extends StatefulWidget {
  const BiologySubmittedScreen({Key? key}) : super(key: key);
  static String namedRoute = "/biology-submitted-screen";

  @override
  _BiologySubmittedScreenState createState() => _BiologySubmittedScreenState();
}

class _BiologySubmittedScreenState extends State<BiologySubmittedScreen> {

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
