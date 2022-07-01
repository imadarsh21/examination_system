import 'package:examination_system/providers/admin_password.dart';
import 'package:examination_system/providers/auth.dart';
import 'package:examination_system/providers/get_name.dart';
import 'package:examination_system/providers/questions/biology_questions.dart';
import 'package:examination_system/providers/questions/chemistry_questions.dart';
import 'package:examination_system/providers/questions/mathematics_questions.dart';
import 'package:examination_system/providers/questions/physics_questions.dart';
import 'package:examination_system/providers/responses/biology_responses.dart';
import 'package:examination_system/providers/responses/chemistry_responses.dart';
import 'package:examination_system/providers/responses/mathematics_responses.dart';
import 'package:examination_system/providers/responses/physics_responses.dart';
import 'package:examination_system/screens/admin_question_screens/admin_biology_question_screen.dart';
import 'package:examination_system/screens/admin_question_screens/admin_chemistry_question_screen.dart';
import 'package:examination_system/screens/admin_question_screens/admin_mathematics_question_screen.dart';
import 'package:examination_system/screens/admin_password_screen.dart';
import 'package:examination_system/screens/admin_subjects_screen.dart';
import 'package:examination_system/screens/auth_screen.dart';
import 'package:examination_system/screens/edit_question_screens/edit_biology_question_screen.dart';
import 'package:examination_system/screens/edit_question_screens/edit_chemistry_question_screen.dart';
import 'package:examination_system/screens/edit_question_screens/edit_mathematics_question_screen.dart';
import 'package:examination_system/screens/edit_question_screens/edit_physics_question_screen.dart';
import 'package:examination_system/screens/examination_home_screen.dart';
import 'package:examination_system/screens/questions_screens/biology_questions_screen.dart';
import 'package:examination_system/screens/questions_screens/chemistry_questions_screen.dart';
import 'package:examination_system/screens/questions_screens/mathematics_questions_screen.dart';
import 'package:examination_system/screens/questions_screens/physics_questions_screen.dart';
import 'package:examination_system/screens/splash_screen.dart';
import 'package:examination_system/screens/submitted_screens/biology_submitted_screen.dart';
import 'package:examination_system/screens/submitted_screens/chemistry_submitted_screen.dart';
import 'package:examination_system/screens/submitted_screens/mathematics_submitted_screen.dart';
import 'package:examination_system/screens/submitted_screens/physics_submitted_screen.dart';
import 'package:examination_system/screens/admin_question_screens/admin_physics_question_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static Map<int, Color> color1 = {
    50: const Color.fromRGBO(220, 20, 60, .1),
    100: const Color.fromRGBO(220, 20, 60, .2),
    200: const Color.fromRGBO(220, 20, 60, .3),
    300: const Color.fromRGBO(220, 20, 60, .4),
    400: const Color.fromRGBO(220, 20, 60, .5),
    500: const Color.fromRGBO(220, 20, 60, .6),
    600: const Color.fromRGBO(220, 20, 60, .7),
    700: const Color.fromRGBO(220, 20, 60, .8),
    800: const Color.fromRGBO(220, 20, 60, .9),
    900: const Color.fromRGBO(220, 20, 60, 1),
  };

  static Map<int, Color> color2 = {
    50: const Color.fromRGBO(100, 149, 237, .1),
    100: const Color.fromRGBO(100, 149, 237, .2),
    200: const Color.fromRGBO(100, 149, 237, .3),
    300: const Color.fromRGBO(100, 149, 237, 0.4),
    400: const Color.fromRGBO(100, 149, 237, .5),
    500: const Color.fromRGBO(100, 149, 237, .6),
    600: const Color.fromRGBO(100, 149, 237, .7),
    700: const Color.fromRGBO(100, 149, 237, 0.8),
    800: const Color.fromRGBO(100, 149, 237, .9),
    900: const Color.fromRGBO(100, 149, 237, 1),
  };

  static MaterialColor colorCustom1 = MaterialColor(0xFFDC143C, color1);
  static MaterialColor colorCustom2 = MaterialColor(0xFF6495ED, color2);
  static MaterialColor colorCustom3 = MaterialColor(0xFF0000, color2);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //MultiProviders gives us option to include multiple providers at our root level
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProvider(create: (ctx) => GetName()),
          ChangeNotifierProxyProvider<Auth, PhysicsQuestions>(
            create: (ctx) => PhysicsQuestions("", "", []),
            update: (ctx, auth, previousQuestions) => PhysicsQuestions(
                auth.token ?? "",
                auth.userId ?? "",
                previousQuestions == null ? [] : previousQuestions.items),
          ),
          ChangeNotifierProxyProvider<Auth, ChemistryQuestions>(
            create: (ctx) => ChemistryQuestions("", "", []),
            update: (ctx, auth, previousQuestions) => ChemistryQuestions(
                auth.token ?? "",
                auth.userId ?? "",
                previousQuestions == null ? [] : previousQuestions.items),
          ),
          ChangeNotifierProxyProvider<Auth, BiologyQuestions>(
            create: (ctx) => BiologyQuestions("", "", []),
            update: (ctx, auth, previousQuestions) => BiologyQuestions(
                auth.token ?? "",
                auth.userId ?? "",
                previousQuestions == null ? [] : previousQuestions.items),
          ),
          ChangeNotifierProxyProvider<Auth, MathematicsQuestions>(
            create: (ctx) => MathematicsQuestions("", "", []),
            update: (ctx, auth, previousQuestions) => MathematicsQuestions(
                auth.token ?? "",
                auth.userId ?? "",
                previousQuestions == null ? [] : previousQuestions.items),
          ),
          ChangeNotifierProxyProvider<Auth, AdminPassword>(
              create: (ctx) => AdminPassword(""),
              update: (ctx, auth, previous) => AdminPassword(
                    auth.token ?? "",
                  )),
          ChangeNotifierProxyProvider<Auth, PhysicsResponses>(
              create: (ctx) => PhysicsResponses("", "", []),
              update: (ctx, auth, previousScore) => PhysicsResponses(
                  auth.token,
                  auth.userId,
                  previousScore == null ? [] : previousScore.items)),
          ChangeNotifierProxyProvider<Auth, ChemistryResponses>(
              create: (ctx) => ChemistryResponses("", "", []),
              update: (ctx, auth, previousScore) => ChemistryResponses(
                  auth.token,
                  auth.userId,
                  previousScore == null ? [] : previousScore.items)),
          ChangeNotifierProxyProvider<Auth, BiologyResponses>(
              create: (ctx) => BiologyResponses("", "", []),
              update: (ctx, auth, previousScore) => BiologyResponses(
                  auth.token,
                  auth.userId,
                  previousScore == null ? [] : previousScore.items)),
          ChangeNotifierProxyProvider<Auth, MathematicsResponses>(
              create: (ctx) => MathematicsResponses("", "", []),
              update: (ctx, auth, previousScore) => MathematicsResponses(
                  auth.token,
                  auth.userId,
                  previousScore == null ? [] : previousScore.items)),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, child) => MaterialApp(
            title: 'Examination',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: "Georama",
              colorScheme: ColorScheme.fromSwatch(primarySwatch: colorCustom2)
                  .copyWith(secondary: colorCustom1),
              appBarTheme: AppBarTheme(
                  backgroundColor: colorCustom3,
                  iconTheme: const IconThemeData(color: Colors.black87),
                  titleTextStyle:
                      const TextStyle(color: Colors.black87, fontSize: 19)),
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.black54,
                selectionColor: Colors.black54,
                selectionHandleColor: Colors.black54,
              ),
            ),
            home: auth.isAuth
                ? const ExaminationHomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? const SplashScreen()
                            : const AuthScreen(),
                  ),
            //: authResultSnapshot.data == true? ProductsOverviewScreen()
            //it a Map<String, Widget Function(BuildContext context)> type.
            routes: {
              AdminPasswordScreen.namedRoute: (ctx) =>
                  const AdminPasswordScreen(),
              PhysicsQuestionsScreen.namedRoute: (ctx) =>
                  const PhysicsQuestionsScreen(),
              ChemistryQuestionsScreen.namedRoute: (ctx) =>
                  const ChemistryQuestionsScreen(),
              BiologyQuestionsScreen.namedRoute: (ctx) =>
                  const BiologyQuestionsScreen(),
              MathematicsQuestionsScreen.namedRoute: (ctx) =>
                  const MathematicsQuestionsScreen(),
              AdminPhysicsQuestionScreen.namedRoute: (ctx) =>
                  const AdminPhysicsQuestionScreen(),
              AdminChemistryQuestionScreen.namedRoute: (ctx) =>
                  const AdminChemistryQuestionScreen(),
              AdminBiologyQuestionScreen.namedRoute: (ctx) =>
                  const AdminBiologyQuestionScreen(),
              AdminMathematicsQuestionScreen.namedRoute: (ctx) =>
                  const AdminMathematicsQuestionScreen(),
              EditPhysicsQuestionScreen.namedRoute: (ctx) =>
                  const EditPhysicsQuestionScreen(),
              EditChemistryQuestionScreen.namedRoute: (ctx) =>
                  const EditChemistryQuestionScreen(),
              EditBiologyQuestionScreen.namedRoute: (ctx) =>
                  const EditBiologyQuestionScreen(),
              EditMathematicsQuestionScreen.namedRoute: (ctx) =>
                  const EditMathematicsQuestionScreen(),
              PhysicsSubmittedScreen.namedRoute: (ctx) =>
                  const PhysicsSubmittedScreen(),
              ChemistrySubmittedScreen.namedRoute: (ctx) =>
                  const ChemistrySubmittedScreen(),
              BiologySubmittedScreen.namedRoute: (ctx) =>
                  const BiologySubmittedScreen(),
              MathematicsSubmittedScreen.namedRoute: (ctx) =>
                  const MathematicsSubmittedScreen(),
              AdminSubjectsScreen.namedRoute: (ctx) =>
                  const AdminSubjectsScreen(),
            },
          ),
        ));
  }
}
