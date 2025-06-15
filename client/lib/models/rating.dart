import 'dart:convert';

class Ratings {
  final String userId;
  final double rating;

  Ratings({required this.userId, required this.rating});

  factory Ratings.fromMap(Map<String, dynamic> map) {
    // Handle different userId formats
    dynamic userIdValue = map['userId'];
    String userId;

    if (userIdValue is String) {
      userId = userIdValue;
    } else if (userIdValue is Map<String, dynamic>) {
      // Handle MongoDB ObjectId format: { "$oid": "64f8a1b2c3d4e5f6g7h8i9j0" }
      if (userIdValue.containsKey('\$oid')) {
        userId = userIdValue['\$oid'].toString();
      } else if (userIdValue.containsKey('_id')) {
        userId = userIdValue['_id'].toString();
      } else {
        // If it's a user object with an id field
        userId = userIdValue['id']?.toString() ?? userIdValue.toString();
      }
    } else {
      // Fallback: convert whatever it is to string
      userId = userIdValue.toString();
    }

    return Ratings(
      userId: userId,
      rating: _toDouble(map['rating']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'rating': rating,
    };
  }

  String toJson() => json.encode(toMap());

  factory Ratings.fromJson(String source) =>
      Ratings.fromMap(json.decode(source));

  @override
  String toString() => 'Ratings(userId: $userId, rating: $rating)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Ratings && other.userId == userId && other.rating == rating;
  }

  @override
  int get hashCode => userId.hashCode ^ rating.hashCode;
}
