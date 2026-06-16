import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import 'package:veloura_ai/app/theme/app_decorations.dart';
import 'package:veloura_ai/app/theme/app_text_styles.dart';
import 'package:veloura_ai/features/auth/presentation/provider/auth_provider.dart';
import 'package:veloura_ai/features/auth/presentation/pages/login_page.dart';
import 'package:veloura_ai/core/providers/language_provider.dart';
import 'package:veloura_ai/core/constants/app_config.dart';
import 'package:veloura_ai/core/services/permission_service.dart';
import '../widgets/settings_tile.dart';
import '../widgets/settings_section.dart';
import 'change_password_page.dart';
import 'legal_document_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _showLanguageBottomSheet(BuildContext context, LanguageProvider lp) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text(
                lp.translate('language'),
                style: AppTextStyles.h3,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Text("🇺🇸", style: TextStyle(fontSize: 24)),
                title: Text(
                  lp.translate('english'),
                  style: TextStyle(
                    fontWeight: lp.locale == 'en' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: lp.locale == 'en' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  lp.setLocale('en');
                  Navigator.pop(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Text("🇹🇷", style: TextStyle(fontSize: 24)),
                title: Text(
                  lp.translate('turkish'),
                  style: TextStyle(
                    fontWeight: lp.locale == 'tr' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: lp.locale == 'tr' ? const Icon(Icons.check, color: AppColors.primary) : null,
                onTap: () {
                  lp.setLocale('tr');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showNotificationSettingsDialog(BuildContext context, LanguageProvider lp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            lp.translate('notifications_dialog_title'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(lp.translate('notifications_dialog_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lp.translate('cancel'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await PermissionService.instance.requestCameraPermission(context); // Triggers permission handler open settings internally if denied
              },
              child: Text(
                lp.translate('open_settings'),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context, AuthProvider authProvider, LanguageProvider lp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            lp.translate('confirm_delete_title'),
            style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error),
          ),
          content: Text(lp.translate('confirm_delete_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lp.translate('cancel'),
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final success = await authProvider.deleteAccount();
                if (!success && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(authProvider.error ?? 'Account deletion failed.'),
                      backgroundColor: AppColors.error,
                    ),
                  );
                }
              },
              child: Text(
                lp.translate('delete_account_confirm'),
                style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAboutDialog(BuildContext context, LanguageProvider lp) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            lp.translate('about_title'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(lp.translate('about_message')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                lp.translate('ok'),
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final lp = context.watch<LanguageProvider>();
    final email = authProvider.user?.email ?? "fashionista@veloura.ai";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: AppDecorations.card,
                child: Column(
                  children: [
                    Container(
                      height: 80,
                      width: 80,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffE8B4B8),
                            Color(0xffF3D7D9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          email.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      email,
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        lp.translate('free_tier').toUpperCase(),
                        style: AppTextStyles.label.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Prepared Future Features Card (Streaks, Badges, Favorites, Premium Upgrade)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.accent.withOpacity(0.2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Icon(Icons.local_fire_department_rounded, color: Colors.orangeAccent),
                            const SizedBox(height: 4),
                            Text(
                              lp.translate('streaks'),
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.favorite_rounded, color: AppColors.primary),
                            const SizedBox(height: 4),
                            Text(
                              lp.translate('favorites'),
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          children: [
                            const Icon(Icons.emoji_events_rounded, color: Colors.amber),
                            const SizedBox(height: 4),
                            Text(
                              lp.translate('badges'),
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const Text("0", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 24, thickness: 0.5),
                    Text(
                      lp.translate('future_features'),
                      style: AppTextStyles.bodySmall.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Settings Sections
              SettingsSection(
                title: lp.translate('account'),
                children: [
                  SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: lp.translate('change_password'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.logout_rounded,
                    title: lp.translate('sign_out'),
                    iconColor: AppColors.error,
                    onTap: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                  SettingsTile(
                    icon: Icons.delete_forever_rounded,
                    title: lp.translate('delete_account'),
                    iconColor: AppColors.error,
                    onTap: () => _showDeleteAccountDialog(context, authProvider, lp),
                  ),
                ],
              ),

              SettingsSection(
                title: lp.translate('app'),
                children: [
                  SettingsTile(
                    icon: Icons.language_rounded,
                    title: lp.translate('language'),
                    subtitle: lp.locale == 'en' ? 'English' : 'Türkçe',
                    onTap: () => _showLanguageBottomSheet(context, lp),
                  ),
                  SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: lp.translate('notifications'),
                    onTap: () => _showNotificationSettingsDialog(context, lp),
                  ),
                ],
              ),

              SettingsSection(
                title: lp.translate('legal'),
                children: [
                  SettingsTile(
                    icon: Icons.gavel_rounded,
                    title: lp.translate('terms_of_service'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LegalDocumentPage(
                            title: lp.translate('terms_of_service'),
                            centralUrl: AppConfig.termsOfServiceUrl,
                            documentText: "Welcome to Veloura AI!\n\nThese terms of service govern your usage of the Veloura AI application. By creating an account and uploading content, you agree to comply with all copyright and styling guidelines. We reserve the right to ban accounts violating guidelines or hosting malicious materials.\n\nUsage limits and features are subject to change.",
                          ),
                        ),
                      );
                    },
                  ),
                  SettingsTile(
                    icon: Icons.privacy_tip_outlined,
                    title: lp.translate('privacy_policy'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LegalDocumentPage(
                            title: lp.translate('privacy_policy'),
                            centralUrl: AppConfig.privacyPolicyUrl,
                            documentText: "Privacy Policy of Veloura AI\n\nYour privacy is important to us. We securely store wardrobe photographs, metadata, styling prompts, and outfit history in encrypted Supabase storage instances. We do not sell or share wardrobe assets to third-party advertizers. You retain full ownership of the digital representations of your clothes.",
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              SettingsSection(
                title: lp.translate('other'),
                children: [
                  SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: lp.translate('about'),
                    onTap: () => _showAboutDialog(context, lp),
                  ),
                  SettingsTile(
                    icon: Icons.phone_android_rounded,
                    title: lp.translate('app_version'),
                    trailing: Text(
                      "${lp.translate('profile')} App v${AppConfig.appVersion}",
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 80), // extra margin to avoid overlap with bottom navigation bar
            ],
          ),
        ),
      ),
    );
  }
}
