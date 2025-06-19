import 'package:flutter_application_1/data/models/member/provider_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_dto.freezed.dart';
part 'member_dto.g.dart';

@freezed
class MemberDto with _$MemberDto {
  const factory MemberDto({
    String? createdDate,
    String? updatedDate,
    required int id,
    required String nickName,
    String? profileImage,
    String? email,
    String? birthYear,
    String? providerId,
    required ProviderType providerType,
    String? introduction,
  }) = _MemberDto;

  factory MemberDto.fromJson(Map<String, dynamic> json) =>
      _$MemberDtoFromJson(json);
}
