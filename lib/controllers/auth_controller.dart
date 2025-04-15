import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  static final AuthController instance = Get.find<AuthController>();

  final _auth = FirebaseAuth.instance;

  final Rx<User?> _user = Rx<User?>(null);
  User get user => _user.value!;

  Future<void> signIn({
    required String email, 
    required String password
  }) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user.value = userCredential.user;
      } catch (e) {
      Get.snackbar("Error signing in", e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _user.value = null;
    } catch (e) {
      Get.snackbar("Error signing out", e.toString());
    }
  }
}