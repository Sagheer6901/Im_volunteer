import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:i_am_volunteer/ui/auth/password_body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: Colors.black),
      //   backgroundColor: Colors.white, systemOverlayStyle: SystemUiOverlayStyle.dark,
      // ),
      body: Body(),
    );
  }
}