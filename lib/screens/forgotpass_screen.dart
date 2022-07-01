import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final TextEditingController forgotPassController = TextEditingController();
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/uploads/141103282695035fa1380/95cdfeef?ixid=MnwxMjA3fDB8"
                        "MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=974&q=80"),
                fit: BoxFit.cover)),
        child: Container(
          margin: const EdgeInsets.only(left: 260.0, top: 90.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 300.0, vertical: 160),
            child: Column(
              children: [
                TextField(
                  controller: forgotPassController,
                  decoration: const InputDecoration(
                    labelText: "Enter your registered E-mail",
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ElevatedButton(
                      onPressed: () async{
                        if (forgotPassController.text.contains("@")) {
                          await auth.sendPasswordResetEmail(email: _email!.trim());
                          Navigator.of(context).pop();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Reset Password")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
