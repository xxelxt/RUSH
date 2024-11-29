import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rush/core/domain/entities/account/account.dart';
import 'package:rush/core/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth auth;
  final CollectionReference collectionReference;
  AuthRepositoryImpl({required this.auth, required this.collectionReference});

  @override
  Future<void> login({required String email, required String password}) async {
    await auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> register({required String email, required String password, required String fullName, required String phoneNumber, required int role}) async {
    await auth.createUserWithEmailAndPassword(email: email, password: password);

    Account data = Account(
      accountId: auth.currentUser!.uid,
      fullName: fullName,
      emailAddress: email,
      phoneNumber: phoneNumber,
      role: role,
      banStatus: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      photoProfileUrl: '',
    );

    await collectionReference.doc(data.accountId).set(data.toJson(), SetOptions(merge: true));
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
