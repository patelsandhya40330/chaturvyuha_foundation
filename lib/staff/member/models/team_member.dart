class TeamMember {
  final String name;
  final String role;
  final String bio;
  final String? imagePath;

  TeamMember({
    required this.name,
    required this.role,
    required this.bio,
    this.imagePath,
  });
}
