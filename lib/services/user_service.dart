import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class UserService {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users => _db.collection('users');

  Future<void> ensureUserDoc({
    required String uid,
    required String email,
  }) async {
    final ref = _users.doc(uid);
    final snap = await ref.get();

    if (!snap.exists) {
      await ref.set({
        'email': email,
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
      return;
    }

    // dopuni email ako nedostaje
    final data = snap.data() ?? {};
    if ((data['email'] ?? '').toString().isEmpty) {
      await ref.update({'email': email});
    }
  }

  Stream<AppUser?> watchUser(String uid) {
    return _users.doc(uid).snapshots().map((doc) {
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.id, doc.data() ?? {});
    });
  }

  Stream<List<AppUser>> watchAllUsers() {
    return _users
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => AppUser.fromMap(d.id, d.data())).toList());
  }

  Future<void> setRole({
    required String uid,
    required String role,
  }) async {
    await _users.doc(uid).update({'role': role});
  }

  Future<void> deleteUserDoc(String uid) async {
    await _users.doc(uid).delete();
  }
}
