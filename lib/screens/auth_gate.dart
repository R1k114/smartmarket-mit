import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../core/app_routes.dart';
import '../services/user_service.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        if (authSnap.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnap.data;

        // GOST
        if (user == null) {
          Future.microtask(() {
            Navigator.pushReplacementNamed(context, AppRoutes.guest);
          });
          return const SizedBox.shrink();
        }

        // USER / ADMIN (čitamo role iz Firestore users/{uid})
        return StreamBuilder(
          stream: UserService().watchUser(user.uid),
          builder: (context, userSnap) {
            if (userSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final appUser = userSnap.data;

            // ako dokument još ne postoji, pusti na home (a Register će ga kreirati)
            final role = (appUser?.role ?? 'user');

            Future.microtask(() {
              if (role == 'admin') {
                Navigator.pushReplacementNamed(context, AppRoutes.admin);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            });

            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
