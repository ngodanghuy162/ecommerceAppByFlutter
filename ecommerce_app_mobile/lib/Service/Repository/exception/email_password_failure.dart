class EmailAndPasswordFailure {
  final String message;

  const EmailAndPasswordFailure([
    this.message = "An Unknow error occurred",
  ]);

  factory EmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-credential':
        return const EmailAndPasswordFailure(
            'Tài khoản và mật khẩu không hợp lệ.');
      case 'email-already-in-use':
        return const EmailAndPasswordFailure('Email đã tồn tại trên hệ thống.');
      case 'invalid-email':
        return const EmailAndPasswordFailure(
            'Email có định dạng không hợp lệ.');
      case 'weak-password':
        return const EmailAndPasswordFailure(
            'Please enter a stronger password.');
      case 'user-disabled':
        return const EmailAndPasswordFailure(
            'Tài khoản này đã bị vô hiệu hoá, vui lòng liên hệ admin để hỗ trợ.');
      case 'user-not-found':
        return const EmailAndPasswordFailure(
            'Không tìm thấy tài khoản, vui lòng tạo tài khoản mới.');
      case 'too-many-requests':
        return const EmailAndPasswordFailure(
            'Quá nhiều lần thử, vui lòng chờ.');
      case 'invalid-argument':
        return const EmailAndPasswordFailure(
            'An invalid argument was provided to an Authentication method.');
      case 'invalid-password':
        return const EmailAndPasswordFailure('Sai mật khẩu, vui lòng thử lại.');
      case 'invalid-phone-number':
        return const EmailAndPasswordFailure('Số điện thoại không hợp lệ.');
      case 'operation-not-allowed':
        return const EmailAndPasswordFailure(
            'The provided sign-in provider is disabled for your Firebase project.');
      case 'session-cookie-expired':
        return const EmailAndPasswordFailure(
            'The provided Firebase session cookie is expired.');
      case 'uid-already-exists':
        return const EmailAndPasswordFailure(
            'The provided vid is already in use by an existing user.');
      default:
        return const EmailAndPasswordFailure();
    }
  }
}
