import 'package:chilliguard/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/language/language_bloc.dart';
import '../../blocs/language/language_event.dart';
import '../../widgets/profile/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // ignore: unused_local_variable
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return Scaffold(
      appBar: AppBar(
        title: Text(isHindi ? 'सेटिंग्स' : 'Settings'),
      ),
      body: ListView(
        children: [
          // Language Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isHindi ? 'भाषा' : 'Language',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.language,
            title: isHindi ? 'ऐप भाषा' : 'App Language',
            subtitle: isHindi ? 'हिंदी' : 'English',
            onTap: () => _showLanguageDialog(context, isHindi),
          ),

          const Divider(),

          // Notifications Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isHindi ? 'सूचनाएं' : 'Notifications',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.notifications,
            title: isHindi ? 'पुश सूचनाएं' : 'Push Notifications',
            subtitle: isHindi ? 'सक्रिय' : 'Enabled',
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // TODO: Handle notification toggle
              },
            ),
          ),
          SettingsTile(
            icon: Icons.email,
            title: isHindi ? 'ईमेल सूचनाएं' : 'Email Notifications',
            subtitle: isHindi ? 'निष्क्रिय' : 'Disabled',
            trailing: Switch(
              value: false,
              onChanged: (value) {
                // TODO: Handle email notification toggle
              },
            ),
          ),

          const Divider(),

          // Data & Storage Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isHindi ? 'डेटा और स्टोरेज' : 'Data & Storage',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.cloud_download,
            title: isHindi ? 'ऑफ़लाइन डेटा सिंक' : 'Offline Data Sync',
            subtitle: isHindi ? 'Wi-Fi पर स्वचालित' : 'Auto on Wi-Fi',
            onTap: () {
              // TODO: Navigate to data sync settings
            },
          ),
          SettingsTile(
            icon: Icons.delete_outline,
            title: isHindi ? 'कैश साफ़ करें' : 'Clear Cache',
            subtitle: '45 MB',
            onTap: () => _showClearCacheDialog(context, isHindi),
          ),

          const Divider(),

          // About Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              isHindi ? 'अन्य' : 'About',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          SettingsTile(
            icon: Icons.info_outline,
            title: isHindi ? 'ऐप संस्करण' : 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          SettingsTile(
            icon: Icons.description,
            title: isHindi ? 'नियम और शर्तें' : 'Terms & Conditions',
            onTap: () {
              // TODO: Open terms
            },
          ),
          SettingsTile(
            icon: Icons.privacy_tip,
            title: isHindi ? 'गोपनीयता नीति' : 'Privacy Policy',
            onTap: () {
              // TODO: Open privacy policy
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isHindi ? 'भाषा चुनें' : 'Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: isHindi ? 'hi' : 'en',
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageBloc>().add(ChangeLanguage(value));
                  Navigator.pop(dialogContext);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('हिंदी'),
              value: 'hi',
              groupValue: isHindi ? 'hi' : 'en',
              onChanged: (value) {
                if (value != null) {
                  context.read<LanguageBloc>().add(ChangeLanguage(value));
                  Navigator.pop(dialogContext);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, bool isHindi) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(isHindi ? 'कैश साफ़ करें?' : 'Clear Cache?'),
        content: Text(
          isHindi
              ? 'यह सभी ऑफ़लाइन डेटा हटा देगा'
              : 'This will remove all offline data',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(isHindi ? 'रद्द करें' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isHindi ? 'कैश साफ़ हो गया' : 'Cache cleared'),
                ),
              );
            },
            child: Text(isHindi ? 'साफ़ करें' : 'Clear'),
          ),
        ],
      ),
    );
  }
}
