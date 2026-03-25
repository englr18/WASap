/// Phone number entity representing a normalized Indonesian phone number.
///
/// This entity follows the canonical output format: 62XXXXXXXXX
/// - No leading +
/// - No spaces
/// - Digits only
class PhoneNumber {
  /// The normalized phone number in canonical format (62XXXXXXXXX)
  final String value;

  const PhoneNumber(this.value);

  /// Returns true if the phone number is valid.
  /// A valid Indonesian phone number must:
  /// - Have at least 10 digits
  /// - Start with 62
  bool get isValid {
    if (value.length < 10) return false;
    return value.startsWith('62');
  }

  /// Returns the WhatsApp URL for this phone number.
  String toWhatsAppUrl({String? message}) {
    final baseUrl = 'https://wa.me/$value';
    if (message != null && message.isNotEmpty) {
      return '$baseUrl?text=${Uri.encodeComponent(message)}';
    }
    return baseUrl;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PhoneNumber && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'PhoneNumber($value)';
}
