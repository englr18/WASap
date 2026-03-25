// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WASap';

  @override
  String get appSubtitle => 'Sapa Lebih Mudah';

  @override
  String get phoneNumberLabel => 'Phone Number';

  @override
  String get recentNumbers => 'Recent Numbers';

  @override
  String get clearAll => 'Clear All';

  @override
  String get openWhatsApp => 'Open WhatsApp';

  @override
  String get howItWorks => 'How It Works';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get whatsAppNotInstalled => 'WhatsApp is not installed';

  @override
  String get noRecentNumbers => 'No recent numbers';

  @override
  String get pasteFromClipboard => 'Paste from clipboard';

  @override
  String get clearInput => 'Clear input';

  @override
  String normalizedPreview(String number) {
    return 'Normalized: $number';
  }

  @override
  String get exampleFormat1 => '0812 345 6789';

  @override
  String get exampleFormat2 => '+62 812 345 6789';

  @override
  String get exampleFormat3 => '812 345 6789';

  @override
  String get english => 'English';

  @override
  String get indonesian => 'Indonesian';
}
