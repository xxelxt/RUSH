abstract class AuthRepository {
  Future<void> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required int role,
  });

  Future<void> logout();
}
