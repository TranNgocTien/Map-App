import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_app/screens/home.dart';
import './forgotPassScreen.dart';

import './signUpScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isObscurePassword = true;

    // Future login() async {
    //   // var url = '';
    //   // var response = await http.post(url, body: {
    //   //   "username": user.text,
    //   //   "password": pass.text,
    //   // });

    //   // var data = json.decode(response.body);
    //   // if (user.text == 'admin' && pass.text == '123456') {
    //   //   Fluttertoast.showToast(
    //   //     msg: 'Login Successful',
    //   //     textColor: Colors.green,
    //   //     fontSize: 25,
    //   //   );
    //   //   Navigator.push(
    //   //     context,
    //   //     MaterialPageRoute(
    //   //       builder: (context) => Home(),
    //   //     ),
    //   //   );
    //   // } else {
    //   //   Fluttertoast.showToast(
    //   //     msg: 'Username and password invalid',
    //   //     textColor: Colors.red,
    //   //     fontSize: 25,
    //   //   );
    //   // }
    // }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                width: double.infinity,
                child: Image.asset('assets/image/FCE-Site-logo.png'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 40, 0, 20),
              child: Text(
                "LOGIN",
                style: TextStyle(
                    fontFamily: "RobotoCondensed",
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue,
                    fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: TextField(
                controller: user,
                style: const TextStyle(fontSize: 18, color: Colors.black),
                decoration: const InputDecoration(
                    labelText: "User name",
                    labelStyle:
                        TextStyle(color: Color(0xff888888), fontSize: 15)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Container(
                alignment: AlignmentDirectional.centerEnd,
                child: TextField(
                  obscureText: isObscurePassword = true,
                  obscuringCharacter: '*',
                  controller: pass,
                  decoration: const InputDecoration(
                    // suffixIcon: IconButton(
                    //   icon: Icon(
                    //     Icons.remove_red_eye,
                    //     color: Colors.grey,
                    //   ),
                    //   onPressed: () {
                    //     setState(() {
                    //       isObscurePassword = !isObscurePassword;
                    //     });
                    //   },
                    // ),
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                // TextField(
                //   style: TextStyle(fontSize: 18, color: Colors.black),
                //   obscureText: isObscurePassword ? isObscurePassword : false,
                //   controller: pass,
                //   decoration: InputDecoration(
                //       suffixIcon: IconButton(
                //         icon: Icon(
                //           Icons.remove_red_eye,
                //           color: Colors.grey,
                //         ),
                //         onPressed: () {
                //           setState(() {
                //             isObscurePassword = !isObscurePassword;
                //           });
                //         },
                //       ),
                //       contentPadding: EdgeInsets.only(bottom: 5),
                //       floatingLabelBehavior: FloatingLabelBehavior.always,
                //       labelText: "Password",
                //       hintText: '*************',
                //       hintStyle: TextStyle(
                //         fontSize: 16,
                //         fontWeight: FontWeight.bold,
                //         color: Colors.grey,
                //       ),
                //       labelStyle:
                //           TextStyle(color: Color(0xff888888), fontSize: 15)),
                // ),
                // Text(
                //   "SHOW",
                //   style: TextStyle(
                //       color: Colors.blue,
                //       fontSize: 13,
                //       fontWeight: FontWeight.bold),
                // ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 56, //56
              child: ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: user.text, password: pass.text)
                      .then((value) {
                    Fluttertoast.showToast(
                      msg: 'Login Successful',
                      textColor: Colors.green,
                      fontSize: 25,
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyHomePage(),
                        )).onError((error, stackTrace) {
                      print("Error ${error.toString()}");
                      Fluttertoast.showToast(
                        msg: 'Username and password invalid',
                        textColor: Colors.red,
                        fontSize: 25,
                      );
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
                child: const Text(
                  "SIGN IN",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            Container(
              height: 130,
              width: double.infinity,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text(
                        'SIGN UP',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()));
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('Login'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                      },
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text(
                        'FORGOT PASSWORD',
                      ),
                    ),
                    // TextButton(
                    //   "SIGN UP",
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Color(0xff888888),
                    //   ),
                    // ),
                    // Text(
                    //   "FORGOT PASSWORD?",
                    //   style: TextStyle(fontSize: 15),
                    // ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
