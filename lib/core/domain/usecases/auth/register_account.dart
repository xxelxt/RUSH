import 'package:rush/core/domain/repositories/auth_repository.dart';

class RegisterAccount {
  final AuthRepository _repository;

  RegisterAccount(this._repository);

  Future<void> execute({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required int role,
  }) async {
    await _repository.register(
      email: email,
      password: password,
      fullName: fullName,
      phoneNumber: phoneNumber,
      role: role,
    );
  }
}
