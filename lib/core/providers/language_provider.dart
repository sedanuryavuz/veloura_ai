import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class LanguageProvider extends ChangeNotifier {
  String _locale = 'en';

  String get locale => _locale;

  LanguageProvider() {
    _loadLocale();
  }

  void _loadLocale() {
    _locale = PreferencesService.instance.getString('selected_locale', defaultValue: 'en');
  }

  Future<void> setLocale(String code) async {
    if (_locale == code) return;
    _locale = code;
    await PreferencesService.instance.setString('selected_locale', code);
    notifyListeners();
  }

  String translate(String key) {
    final translations = _translations[_locale] ?? _translations['en']!;
    return translations[key] ?? key;
  }

  static final Map<String, Map<String, String>> _translations = {
    'en': {
      'profile': 'Profile',
      'wardrobe': 'Wardrobe',
      'outfits': 'Outfits',
      'calendar': 'Calendar',
      'ai_chat': 'AI Chat',
      'account': 'Account',
      'app': 'App',
      'legal': 'Legal',
      'other': 'Other',
      'change_password': 'Change Password',
      'sign_out': 'Sign Out',
      'delete_account': 'Delete Account',
      'language': 'Language',
      'notifications': 'Notifications',
      'privacy_policy': 'Privacy Policy',
      'terms_of_service': 'Terms of Service',
      'about': 'About',
      'app_version': 'App Version',
      'membership': 'Membership',
      'free_tier': 'Free Plan',
      'streaks': 'Streaks',
      'favorites': 'Favorites',
      'badges': 'Badges',
      'active_since': 'Active Since',
      'save': 'Save',
      'cancel': 'Cancel',
      'coming_soon': 'Coming Soon',
      'confirm_delete_title': 'Delete Account',
      'confirm_delete_message': 'Are you sure you want to permanently delete your account? This action is irreversible.',
      'delete_account_confirm': 'Delete',
      'update_password': 'Update Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm New Password',
      'password_updated_success': 'Your password has been successfully updated.',
      'ok': 'OK',
      'open_settings': 'Open Settings',
      'notifications_dialog_title': 'Notification Settings',
      'notifications_dialog_message': 'You can manage your notification preferences in your device\'s app settings.',
      'about_title': 'About Veloura AI',
      'about_message': 'Veloura AI is your smart digital wardrobe assistant that helps you curate outfits, track your fashion calendar, and get styling suggestions powered by AI.',
      'turkish': 'Türkçe',
      'english': 'English',
      'active_days': 'days',
      'items_count': 'items',
      'badges_count': 'badges',
      'future_features': 'Coming Soon Options',
    },
    'tr': {
      'profile': 'Profil',
      'wardrobe': 'Gardırop',
      'outfits': 'Kombinler',
      'calendar': 'Takvim',
      'ai_chat': 'AI Sohbet',
      'account': 'Hesap',
      'app': 'Uygulama',
      'legal': 'Yasal',
      'other': 'Diğer',
      'change_password': 'Şifre Değiştir',
      'sign_out': 'Çıkış Yap',
      'delete_account': 'Hesabı Sil',
      'language': 'Dil',
      'notifications': 'Bildirimler',
      'privacy_policy': 'Gizlilik Politikası',
      'terms_of_service': 'Kullanım Koşulları',
      'about': 'Hakkında',
      'app_version': 'Uygulama Sürümü',
      'membership': 'Üyelik',
      'free_tier': 'Ücretsiz Plan',
      'streaks': 'Seriler',
      'favorites': 'Favoriler',
      'badges': 'Rozetler',
      'active_since': 'Şu Tarihten Beri Aktif',
      'save': 'Kaydet',
      'cancel': 'İptal',
      'coming_soon': 'Yakında',
      'confirm_delete_title': 'Hesabı Sil',
      'confirm_delete_message': 'Hesabınızı kalıcı olarak silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.',
      'delete_account_confirm': 'Sil',
      'update_password': 'Şifreyi Güncelle',
      'new_password': 'Yeni Şifre',
      'confirm_password': 'Şifreyi Onayla',
      'password_updated_success': 'Şifreniz başarıyla güncellendi.',
      'ok': 'Tamam',
      'open_settings': 'Ayarları Aç',
      'notifications_dialog_title': 'Bildirim Ayarları',
      'notifications_dialog_message': 'Bildirim tercihlerinizi cihazınızın uygulama ayarlarından yönetebilirsiniz.',
      'about_title': 'Veloura AI Hakkında',
      'about_message': 'Veloura AI, yapay zeka destekli akıllı dijital gardırop asistanınızdır. Kombinlerinizi planlamanıza, takviminizi takip etmenize ve stil önerileri almanıza yardımcı olur.',
      'turkish': 'Türkçe',
      'english': 'English',
      'active_days': 'gün',
      'items_count': 'ürün',
      'badges_count': 'rozet',
      'future_features': 'Yakında Eklenecek Özellikler',
    }
  };
}
