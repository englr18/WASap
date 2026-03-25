import 'package:url_launcher/url_launcher.dart';

import '../../domain/repositories/whatsapp_repository.dart';

/// Service for launching WhatsApp with a pre-filled phone number.
///
/// Uses the wa.me URL format as specified in the requirements.
class WhatsAppLauncherService implements WhatsAppRepository {
  /// The base URL for WhatsApp Web
  static const String _whatsAppBaseUrl = 'https://wa.me/';

  @override
  Future<LaunchResult> launchWhatsApp(
    String normalizedNumber, {
    String? message,
  }) async {
    try {
      final uri = _buildUri(normalizedNumber, message);

      final canLaunch = await canLaunchUrl(uri);
      if (!canLaunch) {
        return const LaunchFailure('WhatsApp is not installed');
      }

      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        return const LaunchSuccess();
      } else {
        return const LaunchFailure('Failed to launch WhatsApp');
      }
    } catch (e) {
      return LaunchFailure('Error launching WhatsApp: ${e.toString()}');
    }
  }

  @override
  Future<bool> isWhatsAppInstalled() async {
    try {
      // Try to check if we can launch a WhatsApp URL
      final testUri = Uri.parse('${_whatsAppBaseUrl}628123456789');
      return await canLaunchUrl(testUri);
    } catch (e) {
      return false;
    }
  }

  /// Builds the WhatsApp URL with the given normalized number.
  Uri _buildUri(String normalizedNumber, String? message) {
    final baseUrl = '$_whatsAppBaseUrl$normalizedNumber';

    if (message != null && message.isNotEmpty) {
      final uri = Uri.parse('$baseUrl?text=${Uri.encodeComponent(message)}');
      return uri;
    }

    return Uri.parse(baseUrl);
  }
}
