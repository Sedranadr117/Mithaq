

import 'package:complaint_app/core/databases/api/end_points.dart';
import 'package:complaint_app/features/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity{
    AuthModel({
        required super.token,
        required super.email,
        required super.firstName,
        required super.lastName,
        required super.isActive,
    });

    factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        token: json[ApiKeys.token],
        email: json[ApiKeys.email],
        firstName: json[ApiKeys.firstName],
        lastName: json[ApiKeys.lastName],
        isActive: json[ApiKeys.isActive],
    );

    Map<String, dynamic> toJson() => {
        ApiKeys.token: token,
        ApiKeys.email: email,
       ApiKeys.firstName: firstName,
        ApiKeys.lastName: lastName,
        ApiKeys.isActive: isActive,
    };
}
