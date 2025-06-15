import 'dart:convert';

class User {
  final String id;
  final String name;
  final String email;
  final String password;
  final String address;
  final String type;
  final String token;
  List<dynamic> cart;

  User({
    required this.email,
    required this.id,
    required this.name,
    required this.password,
    required this.address,
    required this.type,
    required this.token,
    required this.cart,
  });

  Map<String, dynamic> toMap() {
    return {
      '_id': id, // Changed to match MongoDB format
      'name': name,
      'email': email,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'cart': cart,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      // Fixed to use '_id' instead of 'id' to match MongoDB's format
      id: map['_id'] ?? map['id'] ?? '', // Try both formats for compatibility
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      // Make sure we're properly checking the type
      type: map['type']?.toLowerCase().trim() ?? 'user',
      token: map['token'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        (map['cart'] ?? []).map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  factory User.empty() => User(
        email: '',
        id: '',
        name: '',
        password: '',
        address: '',
        type: '',
        token: '',
        cart: [],
      );

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  // Fixed the address field in copyWith which was using password instead
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    String? token,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address:
          address ?? this.address, // Fixed from this.password to this.address
      type: type ?? this.type,
      token: token ?? this.token,
      cart: cart ?? this.cart,
    );
  }
}
