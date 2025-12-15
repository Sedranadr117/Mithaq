import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/features/auth/data/models/auth_model.dart';
import '../../../../../core/databases/api/api_consumer.dart';
import '../../../../../core/databases/api/end_points.dart';

class AuthRemoteDataSource {
  final ApiConsumer api;

  AuthRemoteDataSource({required this.api});
  Future<AuthModel> logIn(SignInParams params) async {
    final response = await api.post(EndPoints.logIn, data: params.toJson());
    return AuthModel.fromJson(response);
  }

  Future<void> register(SignUpParams params) async {
    await api.post(EndPoints.register, data: params.toJson());
  }

  Future<void> verifyOtp(VerifyOtpParams params) async {
    await api.post(EndPoints.verifyOtp, data: params.toJson());
  }

  Future<void> reSendOtp(ReSendOtpParams params) async {
    await api.post(EndPoints.reSendOtp, data: params.toJson());
  }

  Future<void> logout() async {
    await api.post(EndPoints.logout, data: {});
  }
}
