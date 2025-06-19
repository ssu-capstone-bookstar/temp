import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum Role {
  @JsonValue('USER')
  user,
  @JsonValue('ADMIN')
  admin;
}
