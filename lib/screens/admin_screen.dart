import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/app_user.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = UserService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async => AuthService().signOut(),
          ),
        ],
      ),
      body: StreamBuilder<List<AppUser>>(
        stream: users.watchAllUsers(),
        builder: (context, snap) {
          if (snap.hasError) return Center(child: Text('Greška: ${snap.error}'));
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());

          final list = snap.data!;
          if (list.isEmpty) return const Center(child: Text('Nema korisnika'));

          return ListView.separated(
            itemCount: list.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final u = list[i];
              return ListTile(
                title: Text(u.email.isEmpty ? u.uid : u.email),
                subtitle: Text('uid: ${u.uid} | role: ${u.role}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'make_admin') {
                      await users.setRole(uid: u.uid, role: 'admin');
                    } else if (v == 'make_user') {
                      await users.setRole(uid: u.uid, role: 'user');
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'make_admin', child: Text('Postavi ADMIN')),
                    PopupMenuItem(value: 'make_user', child: Text('Postavi USER')),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
