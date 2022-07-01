import 'package:examination_system/providers/admin_password.dart';
import 'package:examination_system/screens/admin_subjects_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPasswordScreen extends StatelessWidget {
  const AdminPasswordScreen({Key? key}) : super(key: key);

  static String namedRoute = "/password-screen";

  @override
  Widget build(BuildContext context) {
    final TextEditingController adminPasswordController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(image: NetworkImage(
                  "https://images.unsplash.com/uploads/141103282695035fa1380/95cdfeef?ixid=MnwxMjA3fDB8"
                      "MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=974&q=80"),
                  fit: BoxFit.cover)
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 450.0, vertical: 180),
            child: Container(
              margin: const EdgeInsets.only(left: 150.0, top: 90.0),
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      controller: adminPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Enter Admin Password",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: ElevatedButton(onPressed: () async{
                        var data = Provider.of<AdminPassword>(context, listen: false);
                        await data.fetchPassword();
                        if(data.pass == int.parse(adminPasswordController.text)){
                          // Navigator.of(context).pushNamed(AdminQuestionScreen.namedRoute);
                          Navigator.of(context).pushNamed(AdminSubjectsScreen.namedRoute);
                        }else{
                          Navigator.of(context).pop();
                        }

                      }, child: const Text("Authenticate")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}
