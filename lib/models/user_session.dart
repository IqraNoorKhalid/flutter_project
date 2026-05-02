// lib/models/user_session.dart
import 'package:flutter/foundation.dart';

@immutable
class UserSession {
  const UserSession({
    required this.email,
    required this.displayName,
  });

  final String email;
  final String displayName;
}
