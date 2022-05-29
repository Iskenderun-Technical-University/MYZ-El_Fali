import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:myz_el_fali_version_1_1/varaible/varaible.dart';

//import '../screens/register.dart'; kayıt sayfası

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//giriş
  Future<User?> signIn(String email, String pass) async {
    try {
      var user =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return user.user;
    } catch (e) {
      errl = "Hata";
    }
    return null;
  }

//çıkış
  signOut() async {
    return await _auth.signOut();
  }

//kayıt
  Future<User?> createPerson(String email, String pass) async {
    try {
      var user = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      await _firestore
          .collection("Person")
          .doc(user.user!.uid)
          .set({'email': email, 'password': pass});
      return user.user;
    } catch (e) {
      errl = "Hata";
    }
    return null;
  }
}
