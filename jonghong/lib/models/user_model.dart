class User {
  final String id;
  final String email;
  final String name;
  final String profilePictureUrl; // URL of the profile picture

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.profilePictureUrl,
  });

  factory User.fromFirebase(Map<String, dynamic> data) {
    return User(
      id: data['uid'],
      email: data['email'],
      name: data['name'],
      profilePictureUrl: data['profilePictureUrl'] ?? '', 
    );
  }
}
