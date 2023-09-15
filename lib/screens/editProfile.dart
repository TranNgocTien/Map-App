import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileUI extends StatefulWidget {
  @override
  State<EditProfileUI> createState() => _EditProfileUIState();
}

class _EditProfileUIState extends State<EditProfileUI> {
  TextEditingController email = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  TextEditingController newpassword = TextEditingController();
  bool isObscurePassword = true;
  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  changePassword({email, oldpassword, newpassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldpassword);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      print('Error: ${error.toString()}');
    });
  }

  @override
  void dispose() {
    email.dispose();
    oldpassword.dispose();
    newpassword.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        // leading: IconButton(
        //     onPressed: () {},
        //     icon: Icon(Icons.arrow_back, color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                // Center(
                //   child: Stack(
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width * 0.3,
                //         height: MediaQuery.of(context).size.height * 0.3,
                //         decoration: BoxDecoration(
                //           border: Border.all(width: 4, color: Colors.white),
                //           boxShadow: [
                //             BoxShadow(
                //               spreadRadius: 2,
                //               blurRadius: 10,
                //               color: Colors.black.withOpacity(0.1),
                //             ),
                //           ],
                //           shape: BoxShape.circle,
                //           // image:DecorationImage(
                //           //   fit:BoxFit.cover,
                //           //   image: NetworkImage()
                //           // ),
                //         ),
                //       ),
                //       Positioned(
                //         bottom: 0,
                //         right: 0,
                //         child: Container(
                //           height: MediaQuery.of(context).size.height * 0.1,
                //           width: MediaQuery.of(context).size.width * 0.1,
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             border: Border.all(width: 4, color: Colors.white),
                //             color: Colors.blue,
                //           ),
                //           child: Icon(
                //             Icons.edit,
                //             color: Colors.white,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 30),
                buildTextField('Email', 'Email', false, email),
                buildTextField('Password', 'Password', true, oldpassword),
                buildTextField('Password', 'New Password', true, newpassword),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            fontSize: 15,
                            letterSpacing: 2,
                            color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await changePassword(
                          email: email.text,
                          oldpassword: oldpassword.text,
                          newpassword: newpassword.text,
                        );
                        Fluttertoast.showToast(
                          msg: 'Password changed',
                          textColor: Colors.green,
                          fontSize: 25,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        "SAVE",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      bool isPasswordTextField, TextEditingController text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        controller: text,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    },
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            )),
      ),
    );
  }
}
