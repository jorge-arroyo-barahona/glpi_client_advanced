import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  final String sessionToken;
  final String? userToken;
  final Map<String, dynamic>? sessionData;

  const SessionModel({
    required this.sessionToken,
    this.userToken,
    this.sessionData,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  bool get isValid => sessionToken.isNotEmpty;
  
  String? get userId => sessionData?['glpiID']?.toString();
  String? get userName => sessionData?['glpiname']?.toString();
  String? get activeProfile => sessionData?['glpiactiveprofile']?.toString();
  String? get activeEntity => sessionData?['glpiactive_entity']?.toString();
}