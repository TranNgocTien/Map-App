import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController email = TextEditingController();

  @override
  void dispose() {
    user.dispose();
    pass.dispose();
    email.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
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
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: user,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: "User name",
                        labelStyle:
                            TextStyle(color: Color(0xff888888), fontSize: 15)),
                  ),
                  TextField(
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
                      labelStyle:
                          TextStyle(color: Color(0xff888888), fontSize: 15),
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                  ),
                  TextField(
                    controller: email,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                    decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle:
                            TextStyle(color: Color(0xff888888), fontSize: 15)),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 56, //56
                    child: ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email.text, password: pass.text)
                            .then((value) {
                          Navigator.of(context).pop();
                        }).onError((error, stackTrace) {
                          print("Error ${error.toString()}");
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
                        "SIGN UP",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
