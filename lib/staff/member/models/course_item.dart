class CourseItem {
  final String title;
  final String description;
  final String duration;
  final String schedule;
  final String instructor;
  final List<String> resources;
  final List<String> topics;

  CourseItem({
    required this.title,
    required this.description,
    required this.duration,
    required this.schedule,
    required this.instructor,
    required this.resources,
    required this.topics,
  });
}
