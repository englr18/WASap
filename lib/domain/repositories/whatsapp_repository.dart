/// Result of a WhatsApp launch operation.
abstract class LaunchResult {
  const LaunchResult();
}

/// Successful WhatsApp launch result.
class LaunchSuccess extends LaunchResult {
  const LaunchSuccess();
}

/// Failed WhatsApp launch result.
class LaunchFailure extends LaunchResult {
  /// The error message describing why the launch failed.
  final String message;

  const LaunchFailure(this.message);
}

/// Repository interface for WhatsApp launching operations.
///
/// This abstraction allows for different implementations (e.g., url_launcher,
/// custom platform channels) without affecting the domain layer.
abstract class WhatsAppRepository {
  /// Launches WhatsApp with the given normalized phone number.
  ///
  /// Returns [LaunchSuccess] if WhatsApp was successfully opened,
  /// or [LaunchFailure] if the launch failed (e.g., WhatsApp not installed).
  Future<LaunchResult> launchWhatsApp(
    String normalizedNumber, {
    String? message,
  });

  /// Checks if WhatsApp is installed on the device.
  Future<bool> isWhatsAppInstalled();
}
