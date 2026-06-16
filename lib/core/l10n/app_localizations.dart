import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @curateYourStyle.
  ///
  /// In en, this message translates to:
  /// **'Curate Your Style'**
  String get curateYourStyle;

  /// No description provided for @curateYourStyleDesc.
  ///
  /// In en, this message translates to:
  /// **'AI-powered wardrobe organization and style suggestions tailored just for you.'**
  String get curateYourStyleDesc;

  /// No description provided for @virtualCanvas.
  ///
  /// In en, this message translates to:
  /// **'Virtual Canvas'**
  String get virtualCanvas;

  /// No description provided for @virtualCanvasDesc.
  ///
  /// In en, this message translates to:
  /// **'Mix and match tops, bottoms, shoes, and accessories on our interactive canvas to create the perfect look.'**
  String get virtualCanvasDesc;

  /// No description provided for @weatherSmart.
  ///
  /// In en, this message translates to:
  /// **'Weather Smart'**
  String get weatherSmart;

  /// No description provided for @weatherSmartDesc.
  ///
  /// In en, this message translates to:
  /// **'Get real-time outfit suggestions matched specifically to the temperature and weather in your location.'**
  String get weatherSmartDesc;

  /// No description provided for @aiStylistChat.
  ///
  /// In en, this message translates to:
  /// **'AI Stylist Chat'**
  String get aiStylistChat;

  /// No description provided for @aiStylistChatDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask your virtual stylist anything! Get immediate styling advice, tips, and custom outfit combinations.'**
  String get aiStylistChatDesc;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @welcomeBackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access your digital wardrobe'**
  String get welcomeBackSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @passwordLengthError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordLengthError;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordLink;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginButton;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get a link to regain access to your account'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'SEND RESET LINK'**
  String get sendResetLink;

  /// No description provided for @checkInbox.
  ///
  /// In en, this message translates to:
  /// **'Check Your Inbox'**
  String get checkInbox;

  /// No description provided for @resetLinkSentMessage.
  ///
  /// In en, this message translates to:
  /// **'If an account exists for this email, a password reset link has been sent. Please check your inbox.'**
  String get resetLinkSentMessage;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @rememberedPassword.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password? '**
  String get rememberedPassword;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinVelouraSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Join Veloura AI to manage your style'**
  String get joinVelouraSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a secure new password for your account'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @pleaseEnterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'RESET PASSWORD'**
  String get resetPasswordButton;

  /// No description provided for @passwordUpdatedTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Updated'**
  String get passwordUpdatedTitle;

  /// No description provided for @passwordUpdatedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully reset. Please log in with your new password.'**
  String get passwordUpdatedMessage;

  /// No description provided for @goToLogin.
  ///
  /// In en, this message translates to:
  /// **'Go to Login'**
  String get goToLogin;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @connectionErrorDesc.
  ///
  /// In en, this message translates to:
  /// **'Veloura AI was unable to establish a secure connection to our styling servers. Please verify your internet connection and try again.'**
  String get connectionErrorDesc;

  /// No description provided for @retryConnection.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// No description provided for @outfitPlanner.
  ///
  /// In en, this message translates to:
  /// **'Outfit Planner'**
  String get outfitPlanner;

  /// No description provided for @deletePlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Plan?'**
  String get deletePlanTitle;

  /// No description provided for @deletePlanConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove this outfit from your calendar?'**
  String get deletePlanConfirm;

  /// No description provided for @emptyDay.
  ///
  /// In en, this message translates to:
  /// **'Empty Day'**
  String get emptyDay;

  /// No description provided for @planOutfitForDay.
  ///
  /// In en, this message translates to:
  /// **'Plan your perfect outfit for this day'**
  String get planOutfitForDay;

  /// No description provided for @velouraAiChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Veloura AI ✨'**
  String get velouraAiChatTitle;

  /// No description provided for @clearChatTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear chat'**
  String get clearChatTooltip;

  /// No description provided for @aiStylistTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Personal AI Stylist'**
  String get aiStylistTitle;

  /// No description provided for @aiStylistDesc.
  ///
  /// In en, this message translates to:
  /// **'Ask me anything! I will look through your wardrobe items and suggest visually harmonized outfits for the weather.'**
  String get aiStylistDesc;

  /// No description provided for @suggestionPicnic.
  ///
  /// In en, this message translates to:
  /// **'What should I wear for a sunny weekend picnic?'**
  String get suggestionPicnic;

  /// No description provided for @suggestionStreetwear.
  ///
  /// In en, this message translates to:
  /// **'Recommend a streetwear look from my clothes.'**
  String get suggestionStreetwear;

  /// No description provided for @suggestionDate.
  ///
  /// In en, this message translates to:
  /// **'Help me style a minimalist outfit for a date.'**
  String get suggestionDate;

  /// No description provided for @askOutfitSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Ask for an outfit suggestion...'**
  String get askOutfitSuggestion;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @wardrobe.
  ///
  /// In en, this message translates to:
  /// **'Wardrobe'**
  String get wardrobe;

  /// No description provided for @outfits.
  ///
  /// In en, this message translates to:
  /// **'Outfits'**
  String get outfits;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get membership;

  /// No description provided for @freeTier.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freeTier;

  /// No description provided for @streaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get streaks;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @activeSince.
  ///
  /// In en, this message translates to:
  /// **'Active Since'**
  String get activeSince;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete your account? This action is irreversible.'**
  String get confirmDeleteMessage;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAccountConfirm;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @passwordUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your password has been successfully updated.'**
  String get passwordUpdatedSuccess;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @notificationsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationsDialogTitle;

  /// No description provided for @notificationsDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You can manage your notification preferences in your device\'s app settings.'**
  String get notificationsDialogMessage;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About Veloura AI'**
  String get aboutTitle;

  /// No description provided for @aboutMessage.
  ///
  /// In en, this message translates to:
  /// **'Veloura AI is your smart digital wardrobe assistant that helps you curate outfits, track your fashion calendar, and get styling suggestions powered by AI.'**
  String get aboutMessage;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @activeDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get activeDays;

  /// No description provided for @itemsCount.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get itemsCount;

  /// No description provided for @badgesCount.
  ///
  /// In en, this message translates to:
  /// **'badges'**
  String get badgesCount;

  /// No description provided for @futureFeatures.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon Options'**
  String get futureFeatures;

  /// No description provided for @myWardrobe.
  ///
  /// In en, this message translates to:
  /// **'My Wardrobe'**
  String get myWardrobe;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Item?'**
  String get deleteItemTitle;

  /// No description provided for @deleteItemConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to permanently remove this item from your wardrobe?'**
  String get deleteItemConfirm;

  /// No description provided for @editClothing.
  ///
  /// In en, this message translates to:
  /// **'Edit Clothing'**
  String get editClothing;

  /// No description provided for @addClothing.
  ///
  /// In en, this message translates to:
  /// **'Add Clothing'**
  String get addClothing;

  /// No description provided for @aiAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI Analyzing...'**
  String get aiAnalyzing;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @aiAutoFill.
  ///
  /// In en, this message translates to:
  /// **'AI Auto-Fill'**
  String get aiAutoFill;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @updateClothing.
  ///
  /// In en, this message translates to:
  /// **'Update Clothing'**
  String get updateClothing;

  /// No description provided for @saveToWardrobe.
  ///
  /// In en, this message translates to:
  /// **'Save to Wardrobe'**
  String get saveToWardrobe;

  /// No description provided for @deleteItem.
  ///
  /// In en, this message translates to:
  /// **'Delete Item'**
  String get deleteItem;

  /// No description provided for @deleteItemGeneralConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to permanently remove this item?'**
  String get deleteItemGeneralConfirm;

  /// No description provided for @getBetterResults.
  ///
  /// In en, this message translates to:
  /// **'Get Better AI Results'**
  String get getBetterResults;

  /// No description provided for @getBetterResultsDesc.
  ///
  /// In en, this message translates to:
  /// **'For the most accurate clothing analysis, place your item on a clean, light-colored background.'**
  String get getBetterResultsDesc;

  /// No description provided for @goodLighting.
  ///
  /// In en, this message translates to:
  /// **'Good Lighting Matters'**
  String get goodLighting;

  /// No description provided for @goodLightingDesc.
  ///
  /// In en, this message translates to:
  /// **'Use natural light and avoid heavy shadows or dark environments.'**
  String get goodLightingDesc;

  /// No description provided for @letAiDoWork.
  ///
  /// In en, this message translates to:
  /// **'Let AI Do The Work'**
  String get letAiDoWork;

  /// No description provided for @letAiDoWorkDesc.
  ///
  /// In en, this message translates to:
  /// **'Veloura AI will automatically analyze colors, category, style, and details from your photo.'**
  String get letAiDoWorkDesc;

  /// No description provided for @gotItCamera.
  ///
  /// In en, this message translates to:
  /// **'Got It, Open Camera'**
  String get gotItCamera;

  /// No description provided for @poorLight.
  ///
  /// In en, this message translates to:
  /// **'Poor Light'**
  String get poorLight;

  /// No description provided for @brightLight.
  ///
  /// In en, this message translates to:
  /// **'Bright Light'**
  String get brightLight;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @minimalist.
  ///
  /// In en, this message translates to:
  /// **'Minimalist'**
  String get minimalist;

  /// No description provided for @editLook.
  ///
  /// In en, this message translates to:
  /// **'EDIT LOOK'**
  String get editLook;

  /// No description provided for @newLook.
  ///
  /// In en, this message translates to:
  /// **'NEW LOOK'**
  String get newLook;

  /// No description provided for @giveLookName.
  ///
  /// In en, this message translates to:
  /// **'Give this look a name...'**
  String get giveLookName;

  /// No description provided for @tabTops.
  ///
  /// In en, this message translates to:
  /// **'TOPS'**
  String get tabTops;

  /// No description provided for @tabBottoms.
  ///
  /// In en, this message translates to:
  /// **'BOTTOMS'**
  String get tabBottoms;

  /// No description provided for @tabShoes.
  ///
  /// In en, this message translates to:
  /// **'SHOES'**
  String get tabShoes;

  /// No description provided for @tabAccessories.
  ///
  /// In en, this message translates to:
  /// **'ACCESSORIES'**
  String get tabAccessories;

  /// No description provided for @signInToSaveOutfits.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to save outfits'**
  String get signInToSaveOutfits;

  /// No description provided for @myOutfitDefaultName.
  ///
  /// In en, this message translates to:
  /// **'My Outfit'**
  String get myOutfitDefaultName;

  /// No description provided for @outfitSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Outfit saved successfully!'**
  String get outfitSavedSuccess;

  /// No description provided for @saveOutfitButton.
  ///
  /// In en, this message translates to:
  /// **'SAVE OUTFIT'**
  String get saveOutfitButton;

  /// No description provided for @canvas.
  ///
  /// In en, this message translates to:
  /// **'CANVAS'**
  String get canvas;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @aiStylistHeading.
  ///
  /// In en, this message translates to:
  /// **'AI Stylist ✨'**
  String get aiStylistHeading;

  /// No description provided for @newLookDefault.
  ///
  /// In en, this message translates to:
  /// **'New Look'**
  String get newLookDefault;

  /// No description provided for @outfitSavedToast.
  ///
  /// In en, this message translates to:
  /// **'Outfit \'{name}\' saved!'**
  String outfitSavedToast(String name);

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {error}'**
  String failedToSave(String error);

  /// No description provided for @curatedLook.
  ///
  /// In en, this message translates to:
  /// **'CURATED LOOK'**
  String get curatedLook;

  /// No description provided for @stylistNote.
  ///
  /// In en, this message translates to:
  /// **'STYLIST NOTE'**
  String get stylistNote;

  /// No description provided for @generateNew.
  ///
  /// In en, this message translates to:
  /// **'Generate New'**
  String get generateNew;

  /// No description provided for @saveThis.
  ///
  /// In en, this message translates to:
  /// **'Save This'**
  String get saveThis;

  /// No description provided for @readyForFreshLook.
  ///
  /// In en, this message translates to:
  /// **'Ready for a fresh look?'**
  String get readyForFreshLook;

  /// No description provided for @emptyStateStylistDesc.
  ///
  /// In en, this message translates to:
  /// **'Tap the button below and let the AI stylist\ncurate a perfect outfit from your wardrobe.'**
  String get emptyStateStylistDesc;

  /// No description provided for @myOutfits.
  ///
  /// In en, this message translates to:
  /// **'My Outfits'**
  String get myOutfits;

  /// No description provided for @noOutfitsSaved.
  ///
  /// In en, this message translates to:
  /// **'No outfits saved yet.'**
  String get noOutfitsSaved;

  /// No description provided for @colorBlack.
  ///
  /// In en, this message translates to:
  /// **'Black'**
  String get colorBlack;

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'White'**
  String get colorWhite;

  /// No description provided for @colorGray.
  ///
  /// In en, this message translates to:
  /// **'Gray'**
  String get colorGray;

  /// No description provided for @colorBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get colorBlue;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get colorRed;

  /// No description provided for @colorGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get colorGreen;

  /// No description provided for @colorBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get colorBrown;

  /// No description provided for @colorBeige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get colorBeige;

  /// No description provided for @colorPink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get colorPink;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get colorYellow;

  /// No description provided for @categoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get categoryAll;

  /// No description provided for @categoryTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get categoryTop;

  /// No description provided for @categoryBottom.
  ///
  /// In en, this message translates to:
  /// **'Bottom'**
  String get categoryBottom;

  /// No description provided for @categoryShoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get categoryShoes;

  /// No description provided for @categoryAccessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessories;

  /// No description provided for @categoryTopDesc.
  ///
  /// In en, this message translates to:
  /// **'Upper body'**
  String get categoryTopDesc;

  /// No description provided for @categoryBottomDesc.
  ///
  /// In en, this message translates to:
  /// **'Lower body'**
  String get categoryBottomDesc;

  /// No description provided for @categoryShoesDesc.
  ///
  /// In en, this message translates to:
  /// **'Footwear'**
  String get categoryShoesDesc;

  /// No description provided for @categoryAccessoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get categoryAccessoriesDesc;

  /// No description provided for @deleteGeneralTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get deleteGeneralTitle;

  /// No description provided for @deleteGeneralConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. Do you really want to delete this item?'**
  String get deleteGeneralConfirm;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
