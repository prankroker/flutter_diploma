class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> map) {
    return QuizQuestion(
      question: map['question'],
      options: List<String>.from(map['options']),
      correctIndex: map['correctIndex'],
    );
  }
}

class Mistake {
  final String question;
  final String selectedAnswer;
  final String correctAnswer;

  Mistake({
    required this.question,
    required this.selectedAnswer,
    required this.correctAnswer,
  });

  Map<String, String> toMessageFormat() => {
    "question": question,
    "selectedAnswer": selectedAnswer,
    "correctAnswer": correctAnswer,
  };
}