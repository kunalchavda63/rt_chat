import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    String? uid,
    required String email,
    required String password,
    String? displayName,
    String? phone,
    String? photoUrl,
    String? role,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return UserModel.fromJson({...json, 'uid': docId});
  }
  factory UserModel.fromMap(Map<String, dynamic> map) =>
      UserModel.fromJson(map); // 👈 optional alias

}
