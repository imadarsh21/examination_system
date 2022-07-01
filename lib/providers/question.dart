class Question {
  final String? id;
  final String question;
  final String option1;
  final String option2;
  final String option3;
  final String option4;
  String correctOption;

  Question({
    required this.id,
    required this.question,
    required this.option1,
    required this.option2,
    required this.option3,
    required this.option4,
    this.correctOption = "",
  });
}
