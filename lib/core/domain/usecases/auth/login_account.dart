import 'package:rush/core/domain/repositories/auth_repository.dart';

class LoginAccount {
  final AuthRepository _repository;

  LoginAccount(this._repository);

  Future<void> execute({required String email, required String password}) async {
    await _repository.login(email: email, password: password);
  }
}
