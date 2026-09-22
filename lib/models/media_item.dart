enum MediaType { photo, video, audio, document }

class MediaItem {
  final String title;
  final String description;
  final String category;
  final MediaType type;
  final String assetPath;

  MediaItem({
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.assetPath,
  });
}
