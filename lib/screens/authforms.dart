import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoapp/screens/authscreens.dart';
import 'package:todoapp/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = "";
  var _password = "";
  var _username = "";
  bool isLogin = true;

  startauthentication() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      submitForm(_email, _password, _username);
    }
  }

  submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;
    UserCredential authResult;

    try {
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String uid = authResult.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .set({'username': username, 'email': email, 'password': password});
        Fluttertoast.showToast(msg: "User Registered Successfully");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please Enter a Valid Email Address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      key: ValueKey('email'),
                      decoration: InputDecoration(
                          labelText: "Email",
                          hintText: "Enter Your Email",
                          labelStyle: GoogleFonts.roboto(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    if (!isLogin)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextFormField(
                          onSaved: (value) {
                            _username = value!;
                          },
                          key: const ValueKey('username'),
                          decoration: InputDecoration(
                              labelText: "Username",
                              hintText: "Enter Your Username",
                              labelStyle: GoogleFonts.roboto(),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'Please Enter a Valid Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      key: ValueKey('password'),
                      decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Enter Your Password",
                          labelStyle: GoogleFonts.roboto(),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10))),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                        ),
                        onPressed: () {
                          startauthentication();
                        },
                        child: Text(
                          isLogin ? 'Login' : 'Sign-Up',
                          style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin
                                ? 'Create an Account'
                                : 'Already Have an Account Log In',
                          )),
                    )
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
