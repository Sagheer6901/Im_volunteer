// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i_am_volunteer/utils/constants.dart';
import 'package:i_am_volunteer/widgets/green_btn.dart';



class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 100.0,horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      // fontSize: getProportionateScreenWidth(28),
                      color: Colors.black45,
                      //fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                      // fontSize: getProportionateScreenWidtheScreenWidth(28),
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Please enter your email and we will send \nyou a link to return to your account",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ForgotPassForm(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  TextEditingController editingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> errors = [];
  String? email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: editingController,
            validator: (value) {
              if (value!.isEmpty && !errors.contains(kEmailNullError)) {
                setState(() {
                  errors.add(kEmailNullError);
                });
              } else if (!emailValidatorRegExp.hasMatch(value) &&
                  !errors.contains(kInvalidEmailError)) {
                setState(() {
                  errors.add(kInvalidEmailError);
                });
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: "Email",

              hintText: "Enter your email",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              // suffixIcon: CustomIcon(svgIcon: "assets/icons/Mail.svg"),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          GreetButtonTwo(
            text: "Continue",
            press: () async{
              if (_formKey.currentState!.validate()) {
                // Do what you want to do
                try{
                  await auth.sendPasswordResetEmail(
                      email: editingController.text.trim());
                  Navigator.of(context).pop();
                } on FirebaseAuthException catch(e){
                  print(e);
                }

              }
            },
          ),
          // SizedBox(height: SizeConfig.screenHeight * 0.1),
          // NoAccountText(),
        ],
      ),
    );
  }
}
//df
