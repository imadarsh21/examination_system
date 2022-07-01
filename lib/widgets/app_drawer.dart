import 'package:examination_system/screens/admin_password_screen.dart';
import 'package:flutter/material.dart';
// import 'package:shop_app/screens/admin_physics_question_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text("Hello!"),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black87,),
            title: const Text("Home", style: TextStyle(fontSize: 17),),
            onTap: (){
              // await Provider.of<Auth>(context, listen: false).getName();
              Navigator.of(context).pushReplacementNamed("/"); //predefined to go to the home page
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.black87),
            title: const Text("Admin Panel", style: TextStyle(fontSize: 17)),
            onTap: (){
              Navigator.of(context).pushNamed(AdminPasswordScreen.namedRoute);
            },
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.black87),
            title: const Text("Logout", style: TextStyle(fontSize: 17)),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed("/");
              Provider.of<Auth>(context, listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
