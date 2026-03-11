import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_technologies/presentation/pages/auth/login_page.dart';
import 'package:taghyeer_technologies/presentation/pages/home/home_page.dart';

import 'blocs/auth/auth_bloc.dart';


class AppRouter extends StatefulWidget {
  const AppRouter({super.key});

  @override
  State<AppRouter> createState() => _AppRouterState();
}

class _AppRouterState extends State<AppRouter> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(const AuthCheckCachedUser());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_rounded,
                      size: 80, color: Color(0xFF6C63FF)),
                  SizedBox(height: 24),
                  Text(
                    'Taghyeer',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C63FF),
                    ),
                  ),
                  SizedBox(height: 32),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        if (state is AuthAuthenticated) {
          return const HomePage();
        }

        return const LoginPage();
      },
    );
  }
}
