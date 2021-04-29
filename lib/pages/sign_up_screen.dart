import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/Tools/auth_helper.dart';

class AuthSignUpScreen extends StatefulWidget {
  @override
  _AuthSignUpScreenState createState() => _AuthSignUpScreenState();
}

class _AuthSignUpScreenState extends State<AuthSignUpScreen> {
  double alto;
  double ancho;
  FirebaseAuth auth;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  AuthHelper authHelper;

  bool chequearSignIn() {
    try {
      auth.authStateChanges().listen((User user) {
        if (user == null) {
          print('User is currently signed out!');
          return false;
        } else {
          print('User is signed in!');
          return true;
        }
      });
    } catch (e) {
      print('Algo salio mal -> $e');
    }
    return false;
  }

  @override
  void initState() {
    auth = FirebaseAuth.instance;
    authHelper = AuthHelper(context: context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ancho = MediaQuery.of(context).size.width;
    alto = MediaQuery.of(context).size.height;
    return chequearSignIn()
        ? Container(
            color: Colors.red,
          )
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: Theme.of(context).backgroundColor,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: Column(
                        children: [
                          Container(
                            height: alto * 0.25,
                            child: Image.asset(
                              'assets/sign_up_vector.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          SizedBox(
                            height: alto * 0.025,
                          ),
                          Text(
                            'ToDoApp',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 40,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: alto * 0.05,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 0),
                            child: Column(
                              children: [
                                TextField(
                                  controller: emailController,
                                  cursorColor: Theme.of(context).accentColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    hintText: 'Email',
                                  ),
                                ),
                                SizedBox(
                                  height: alto * 0.05,
                                ),
                                TextField(
                                  controller: nameController,
                                  cursorColor: Theme.of(context).accentColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    hintText: 'Usuario',
                                  ),
                                ),
                                SizedBox(
                                  height: alto * 0.05,
                                ),
                                TextField(
                                  controller: passwController,
                                  obscureText: true,
                                  cursorColor: Theme.of(context).accentColor,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ),
                                    hintText: 'Contraseña',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: alto * 0.05,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              authHelper.registerNewUser(
                                email: emailController.text,
                                password: passwController.text,
                                userName: nameController.text,
                              );
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.pressed))
                                    return Theme.of(context).cardColor;
                                  return Theme.of(context)
                                      .accentColor; // Use the component's default.
                                },
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Text(
                                'Registrarme!',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      )),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
