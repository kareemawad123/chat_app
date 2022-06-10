import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationServices{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future <String?> singnIn(String email, String password)async{
    try{
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed In";
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future <String?> singnUp(String email, String password)async{
    try{
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed Up";
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
  Future signOut() async {
    try {
      return _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}