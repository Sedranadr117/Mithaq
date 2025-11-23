// ignore_for_file: public_member_api_docs, sort_constructors_first
class TemplateParams {
  final String id;
  TemplateParams({required this.id});
}

class SignUpParams {
  final String name;
  final String email;
  final String password;
  SignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}

class SignInParams {
  final String email;
  final String password;
  SignInParams({required this.email, required this.password});

   Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}

class VerifyOtpParams {
  final String email;
  final String otp;
  VerifyOtpParams({required this.email, required this.otp});

     Map<String, dynamic> toJson() {
    return {'email': email, 'otpCode': otp};
  }
}

class ReSendOtpParams {
  final String email;
  ReSendOtpParams({required this.email});
       Map<String, dynamic> toJson() {
    return {'email': email,};
  }
}
