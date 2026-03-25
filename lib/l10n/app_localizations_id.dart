// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'WASap';

  @override
  String get appSubtitle => 'Sapa Lebih Mudah';

  @override
  String get phoneNumberLabel => 'Nomor Telepon';

  @override
  String get recentNumbers => 'Nomor Terbaru';

  @override
  String get clearAll => 'Hapus Semua';

  @override
  String get openWhatsApp => 'Buka WhatsApp';

  @override
  String get howItWorks => 'Cara Kerja';

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Terang';

  @override
  String get darkTheme => 'Gelap';

  @override
  String get invalidPhoneNumber => 'Nomor telepon tidak valid';

  @override
  String get whatsAppNotInstalled => 'WhatsApp tidak terinstal';

  @override
  String get noRecentNumbers => 'Tidak ada nomor terbaru';

  @override
  String get pasteFromClipboard => 'Tempel dari clipboard';

  @override
  String get clearInput => 'Hapus input';

  @override
  String normalizedPreview(String number) {
    return 'Dinormalisasi: $number';
  }

  @override
  String get exampleFormat1 => '0812 345 6789';

  @override
  String get exampleFormat2 => '+62 812 345 6789';

  @override
  String get exampleFormat3 => '812 345 6789';

  @override
  String get english => 'Inggris';

  @override
  String get indonesian => 'Indonesia';
}
