import  'package:examination_system/providers/questions/biology_questions.dart';
import 'package:examination_system/screens/edit_question_screens/edit_biology_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class AdminBiologyQuestionItem extends StatelessWidget {
  const AdminBiologyQuestionItem({Key? key, required this.question, required this.id}) : super(key: key);
  final String? id;
  final String question;

  @override
  Widget build(BuildContext context) {
    var showSnackBar = ScaffoldMessenger.of(context);
    return SizedBox(
      height: 78,
      child: Column(
        children: [
          const Divider(),
          ListTile(
            title: Text(question, style: const TextStyle(fontSize: 17)),
            trailing: SizedBox(
              width: 100,
              child: Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context).pushNamed(EditBiologyQuestionScreen.namedRoute, arguments: id);
                  }, icon: const Icon(Icons.edit, color: Colors.black54,)),
                  IconButton(onPressed: () async{
                    try{
                      await Provider.of<BiologyQuestions>(context, listen: false).removeQuestion(id!);
                    }catch(error){
                      showSnackBar.showSnackBar(const SnackBar(content: Text("Deletion failed")));
                    }
                  }, icon: Icon(Icons.delete, color: Theme.of(context).errorColor,))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
