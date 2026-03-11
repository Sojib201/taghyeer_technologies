import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../../domain/entities/user_entity.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          final UserEntity? user =
              authState is AuthAuthenticated ? authState.user : null;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: colorScheme.primary.withOpacity(0.15),
                        child: user?.image != null
                            ? ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: user!.image!,
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.cover,
                                  errorWidget: (_, __, ___) => Icon(
                                    Icons.person,
                                    size: 44,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.person,
                                size: 44,
                                color: colorScheme.primary,
                              ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user?.fullName ?? 'User',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${user?.username ?? ''}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.palette_outlined),
                      title: Text('Appearance'),
                      subtitle: Text('Customize the app look'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    BlocBuilder<ThemeCubit, ThemeMode>(
                      builder: (context, themeMode) {
                        return SwitchListTile(
                          secondary: Icon(
                            themeMode == ThemeMode.dark
                                ? Icons.dark_mode
                                : Icons.light_mode,
                          ),
                          title: const Text('Dark Mode'),
                          subtitle: Text(
                            themeMode == ThemeMode.dark
                                ? 'Currently dark'
                                : 'Currently light',
                          ),
                          value: themeMode == ThemeMode.dark,
                          onChanged: (_) =>
                              context.read<ThemeCubit>().toggleTheme(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('App Info'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    const ListTile(
                      leading: Icon(Icons.code_outlined),
                      title: Text('Version'),
                      trailing: Text('1.0.0'),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.business_outlined),
                      title: const Text('Developer'),
                      trailing: Text(
                        'Taghyeer Technologies',
                        style: TextStyle(
                          color: colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Card(
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Sign out from your account'),
                  onTap: () => _showLogoutDialog(context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
