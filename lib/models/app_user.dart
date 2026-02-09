class AppUser {
  final String uid;
  final String email;
  final String role; // 'user' | 'admin'

  AppUser({
    required this.uid,
    required this.email,
    required this.role,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> data) {
    return AppUser(
      uid: uid,
      email: (data['email'] ?? '').toString(),
      role: (data['role'] ?? 'user').toString(),
    );
  }

  Map<String, dynamic> toMap() => {
        'email': email,
        'role': role,
      };
}
