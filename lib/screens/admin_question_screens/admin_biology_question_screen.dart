import 'package:examination_system/providers/questions/biology_questions.dart';
import 'package:examination_system/screens/edit_question_screens/edit_biology_question_screen.dart';
import 'package:examination_system/widgets/admin_question_items/admin_biology_question_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_drawer.dart';


class AdminBiologyQuestionScreen extends StatelessWidget {
  const AdminBiologyQuestionScreen({Key? key}) : super(key: key);
  static String namedRoute = "/admin-biology-question";

  // Future<void> _refreshProducts(BuildContext context) async {
  //   await Provider.of<Questions>(context, listen: false)
  //       .fetchAndSetQuestions();
  // }

  @override
  Widget build(BuildContext context) {
    // debugPrint("rebuilding");
    // final productData = Provider.of<Products>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Questions"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditBiologyQuestionScreen.namedRoute);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          // future: _refreshProducts(context),
          builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Consumer<BiologyQuestions>(
            builder: (ctx, productData, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: productData.items.length,
                    itemBuilder: (context, i) {
                      return AdminBiologyQuestionItem(
                        question: productData.items[i].question,
                        id: productData.items[i].id,
                      );
                    }),
              ),
            ),
          ),
        ));
  }
}
