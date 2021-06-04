import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebay_clone/Config/AppConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

AppConfig _appConfig = new AppConfig();

class AuthService{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async{
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    final signInResult = await _firebaseAuth.signInWithCredential(credential);
    await FirebaseFirestore.instance.collection(_appConfig.userCollection)
      .doc(signInResult.user.uid)
      .set({
      _appConfig.userName: signInResult.user.displayName,
      _appConfig.userEmail: signInResult.user.email,
    });
    return signInResult.user.uid;
  }

  signOut() async{
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }
}