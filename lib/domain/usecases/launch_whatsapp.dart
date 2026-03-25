import '../entities/phone_number.dart';
import '../repositories/whatsapp_repository.dart';

/// Use case for launching WhatsApp with a pre-filled phone number.
///
/// This use case encapsulates the business logic for launching WhatsApp,
/// including validation and URL generation.
class LaunchWhatsApp {
  /// The WhatsApp repository for launching
  final WhatsAppRepository _repository;

  /// Creates a new LaunchWhatsApp use case.
  LaunchWhatsApp(this._repository);

  /// Launches WhatsApp with the given normalized phone number.
  ///
  /// Returns [LaunchSuccess] if successful, [LaunchFailure] on error.
  /// The [phoneNumber] must already be normalized using [NormalizePhoneNumber].
  Future<LaunchResult> call(PhoneNumber phoneNumber, {String? message}) {
    if (!phoneNumber.isValid) {
      return Future.value(const LaunchFailure('Invalid phone number'));
    }

    return _repository.launchWhatsApp(phoneNumber.value, message: message);
  }

  /// Checks if WhatsApp is installed on the device.
  Future<bool> isWhatsAppInstalled() {
    return _repository.isWhatsAppInstalled();
  }
}
