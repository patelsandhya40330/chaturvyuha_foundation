enum EventStatus { upcoming, live, completed, cancelled }

class EventItem {
  final String title;
  final String description;
  final DateTime date;
  final String time;
  final String location;
  final EventStatus status;
  final List<String> galleryImages;

  EventItem({
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    required this.location,
    required this.status,
    required this.galleryImages,
  });
}
