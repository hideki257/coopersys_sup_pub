import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../services/auth_service.dart';

class AuthCheckWidget extends ConsumerWidget {
  const AuthCheckWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    return authService.isAuthenticated ? const HomePage() : const LoginPage();
  }
}
