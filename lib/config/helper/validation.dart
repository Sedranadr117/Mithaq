class FormValidators {
static String? userNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "الحقل مطلوب";
  }
  return null;
}


static String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "الحقل مطلوب";
  }

  if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(value)) {
    return "ادخل بريد إلكتروني صالح";
  }

  return null;
}


static String? strongPasswordValidator(String? value) {
  if (value == null || value.isEmpty) {
    return "الحقل مطلوب";
  }

  // length check
  if (value.length < 8 || value.length > 16) {
    return "كلمة السر يجب أن تكون بين 8 و 16 حرف";
  }

  // no whitespace
  if (value.contains(' ')) {
    return "كلمة السر لا يجب أن تحتوي على فراغات";
  }

  // at least one uppercase
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "يجب أن تحتوي على حرف كبير واحد على الأقل";
  }

  // at least one lowercase
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return "يجب أن تحتوي على حرف صغير واحد على الأقل";
  }

  // at least one number
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return "يجب أن تحتوي على رقم واحد على الأقل";
  }

  // at least one special character
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>_\-\\/]').hasMatch(value)) {
    return "يجب أن تحتوي على رمز واحد على الأقل";
  }

  // reject 5-letter alphabetical sequence
  if (RegExp(r'(abcde|bcdef|cdefg|defgh|efghi|fghij|ghijk|hijkl|ijklm|jklmn|klmno|lmnop|mnopq|nopqr|opqrs|pqrst|qrstu|rstuv|stuvw|tuvwx|uvwxy|vwxyz)').hasMatch(value.toLowerCase())) {
    return "كلمة السر لا يجب أن تحتوي على تسلسل أبجدي مثل abcde";
  }

  // reject 5-number sequence
  if (RegExp(r'(01234|12345|23456|34567|45678|56789)').hasMatch(value)) {
    return "كلمة السر لا يجب أن تحتوي على تسلسل أرقام مثل 12345";
  }

  return null;
}

static String? validateSingleOtpDigit(String? value) {
    if (value == null || value.isEmpty) {
      // 💡 رسالة تظهر أسفل الحقل الفارغ
      return ''; 
    }
    // لا نحتاج للتحقق من الطول لأنه محدد بـ maxLength: 1
    // لا نحتاج للتحقق من الأرقام لأننا نستخدم FilteringTextInputFormatter.digitsOnly
    return null;
  }

}
