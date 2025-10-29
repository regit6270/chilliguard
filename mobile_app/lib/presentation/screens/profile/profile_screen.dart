import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/language/language_bloc.dart'; // ignore: unused_import
import '../../widgets/common/bottom_navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'प्रोफ़ाइल' : 'Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/profile/settings'),
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! AuthAuthenticated) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Header
                _buildProfileHeader(context, authState, isHindi),

                const SizedBox(height: 30),

                // Stats Section
                _buildStatsSection(context, isHindi),

                const SizedBox(height: 20),

                // Menu Items
                _buildMenuItem(
                  context,
                  icon: Icons.agriculture,
                  title: isHindi ? 'मेरे खेत' : 'My Fields',
                  subtitle: isHindi ? 'खेत प्रबंधित करें' : 'Manage fields',
                  onTap: () => context.push('/profile/field-management'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  title: isHindi ? 'फसल इतिहास' : 'Crop History',
                  subtitle: isHindi ? 'पिछली फसलें देखें' : 'View past crops',
                  onTap: () => context.push('/crop-management'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.assessment,
                  title: isHindi ? 'रिपोर्ट' : 'Reports',
                  subtitle: isHindi ? 'विश्लेषण देखें' : 'View analytics',
                  onTap: () => context.push('/reports'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.library_books,
                  title: isHindi ? 'ज्ञान केंद्र' : 'Knowledge Base',
                  subtitle: isHindi ? 'खेती सीखें' : 'Learn farming',
                  onTap: () => context.push('/knowledge-base'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.help_outline,
                  title: isHindi ? 'सहायता' : 'Help & Support',
                  subtitle: isHindi ? 'सहायता प्राप्त करें' : 'Get assistance',
                  onTap: () {
                    // TODO: Open help center
                  },
                ),

                const Divider(),

                // Logout
                _buildMenuItem(
                  context,
                  icon: Icons.logout,
                  title: isHindi ? 'लॉग आउट' : 'Logout',
                  subtitle:
                      isHindi ? 'खाते से बाहर निकलें' : 'Sign out of account',
                  onTap: () => _showLogoutDialog(context, isHindi),
                  iconColor: Colors.red,
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          const ChilliGuardBottomNavigationBar(currentIndex: 4),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    AuthAuthenticated authState,
    bool isHindi,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(
              authState.userName.isNotEmpty
                  ? authState.userName[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 15),

          // Name
          Text(
            authState.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),

          // Email
          Text(
            authState.userEmail,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 15),

          // Edit Profile Button
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to edit profile
            },
            icon: const Icon(Icons.edit, size: 18),
            label: Text(isHindi ? 'प्रोफ़ाइल संपादित करें' : 'Edit Profile'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context, bool isHindi) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            context,
            value: '3',
            label: isHindi ? 'खेत' : 'Fields',
            icon: Icons.terrain,
          ),
          _buildStatItem(
            context,
            value: '12',
            label: isHindi ? 'फसलें' : 'Crops',
            icon: Icons.agriculture,
          ),
          _buildStatItem(
            context,
            value: '45',
            label: isHindi ? 'स्कैन' : 'Scans',
            icon: Icons.camera_alt,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String value,
    required String label,
    required IconData icon,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: (iconColor ?? Theme.of(context).colorScheme.primary)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: iconColor ?? Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isHindi ? 'लॉग आउट करें?' : 'Logout?'),
        content: Text(
          isHindi
              ? 'क्या आप वाकई लॉग आउट करना चाहते हैं?'
              : 'Are you sure you want to logout?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthBloc>().add(LogoutRequested());
              context.go('/login');
            },
            child: Text(
              isHindi ? 'लॉग आउट' : 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
