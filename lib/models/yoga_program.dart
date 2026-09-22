enum ProgramType { yoga, meditation }

class YogaProgram {
  final String title;
  final String description;
  final String instructor;
  final String schedule;
  final ProgramType type;

  YogaProgram({
    required this.title,
    required this.description,
    required this.instructor,
    required this.schedule,
    required this.type,
  });
}
