import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Tools/firestore_helper.dart';
import 'package:todo_app/pages/home_page.dart';
import 'package:todo_app/pages/auth_screen.dart';

class AuthHelper {
  AuthHelper({@required this.context});
  BuildContext context;

  dynamic registerNewUser(
      {@required String email,
      @required String password,
      @required String userName}) async {
    /*
    Registrar un nuevo usuario en Fauth con email y pwd. 
    Tambien agregar datos de usuario a firestore y crear su entrada de Todos.
    */

    try {
      if (userName.length >= 8) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('El nombre de usuario no debe tener mas de 7 caracteres!'),
          ),
        );
      } else {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.trim(), password: password);

        // agrego data de usuario a Firestore
        await FirestoreHelper.agregarUsuarioRegistrado(
            userID: userCredential.user.uid, userName: userName);
        await userCredential.user.updateProfile(displayName: userName);
        // una vez registrado, queremos ir directo a la HomePAge
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userName: userName,
              userCredential: userCredential,
              userID: userCredential.user.uid,
            ),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'La contraseña es muy debil. Intenta con 6 caracteres',
                textAlign: TextAlign.center),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email en uso!', textAlign: TextAlign.center),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  dynamic logInUser({@required email, @required password}) async {
    /*
    Loggear un nuevo usuario en Fauth con email y pwd
    */
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userName: userCredential.user.displayName,
            userCredential: userCredential,
            userID: userCredential.user.uid,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No se encontro un usuario con ese correo',
              textAlign: TextAlign.center,
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Contraseña incorrecta',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    }
  }

  Future<void> logOutUser() async {
    /*
    Logout de firebase
    */
    await FirebaseAuth.instance.signOut().then(
          (value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AuthScreen(),
            ),
          ),
        );
  }
}
