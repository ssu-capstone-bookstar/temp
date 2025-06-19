import 'package:freezed_annotation/freezed_annotation.dart';

enum Role {
  @JsonValue('USER')
  user,
  @JsonValue('ADMIN')
  admin,
} 