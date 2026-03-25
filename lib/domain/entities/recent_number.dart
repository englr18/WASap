import 'package:intl/intl.dart';

/// Recent number entity representing a phone number in the user's history.
///
/// Stores the phone number and when it was last used.
class RecentNumber {
  /// The normalized phone number value
  final String phoneNumber;

  /// Timestamp when this number was last used
  final DateTime lastUsed;

  const RecentNumber({required this.phoneNumber, required this.lastUsed});

  /// Creates a RecentNumber from a phone number (uses current time).
  factory RecentNumber.create(String phoneNumber) {
    return RecentNumber(phoneNumber: phoneNumber, lastUsed: DateTime.now());
  }

  /// Creates a RecentNumber from JSON map.
  factory RecentNumber.fromJson(Map<String, dynamic> json) {
    return RecentNumber(
      phoneNumber: json['phoneNumber'] as String,
      lastUsed: DateTime.parse(json['lastUsed'] as String),
    );
  }

  /// Converts this RecentNumber to a JSON map.
  Map<String, dynamic> toJson() {
    return {'phoneNumber': phoneNumber, 'lastUsed': lastUsed.toIso8601String()};
  }

  /// Returns a formatted display string for the phone number.
  /// Example: "628123456789" -> "+62 812 345 6789"
  String get displayString {
    if (phoneNumber.length < 10) return phoneNumber;

    final buffer = StringBuffer('+');
    buffer.write(phoneNumber.substring(0, 2));
    buffer.write(' ');
    buffer.write(phoneNumber.substring(2, 4));
    buffer.write(' ');
    buffer.write(phoneNumber.substring(4, 7));
    buffer.write(' ');
    buffer.write(phoneNumber.substring(7));

    return buffer.toString();
  }

  /// Returns true if this recent number is the same as another.
  bool isSameAs(String otherNumber) {
    return phoneNumber == otherNumber;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecentNumber &&
        other.phoneNumber == phoneNumber &&
        other.lastUsed == lastUsed;
  }

  @override
  int get hashCode => Object.hash(phoneNumber, lastUsed);

  @override
  String toString() =>
      'RecentNumber($phoneNumber, ${DateFormat.yMd().add_jm().format(lastUsed)})';
}
