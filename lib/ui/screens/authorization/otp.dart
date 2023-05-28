// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/services/cargo_service.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';
// import 'package:pinput/pin_put/pin_put.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen(this.user);

  final UserModel user;

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  // ignore: lines_longer_than_80_chars
  final GlobalKey<ScaffoldMessengerState> _scaffoldkey =
      GlobalKey<ScaffoldMessengerState>();
  late String _verificationCode;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Pinput PinPut = const Pinput();
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: Helpers.blueLightColor,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: Helpers.blueColor),
  );

  @override
  void initState() {
    super.initState();
    logger.d(widget.user.phoneNumber);
    _verifyPhone();
    _auth.setLanguageCode('ru-Ru');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 40.0),
              Text('Введите код подтверждения', style: Helpers.titleTextStyle),
              const SizedBox(height: 30.0),
              // PinPut(
              //   fieldsCount: 6,
              //   textStyle: const TextStyle(
              //     fontSize: 25.0,
              //     color: Helpers.blueColor,
              //   ),
              //   eachFieldWidth: 40.0,
              //   eachFieldHeight: 55.0,
              //   focusNode: _pinPutFocusNode,
              //   controller: _pinPutController,
              //   submittedFieldDecoration: pinPutDecoration,
              //   selectedFieldDecoration: pinPutDecoration,
              //   followingFieldDecoration: pinPutDecoration,
              //   pinAnimationType: PinAnimationType.fade,
              //   onSubmit: (pin) async {
              //     try {
              //       await FirebaseAuth.instance
              //           .signInWithCredential(PhoneAuthProvider.credential(
              //               verificationId: _verificationCode, smsCode: pin))
              //           .then((value) async {
              //         final token = await value.user.getIdToken(true);
              //         Navigator.pop(context, token);
              //       });
              //     } catch (e) {
              //       FocusScope.of(context).unfocus();
              //       logger.d('Error $e');
              //       _scaffoldkey.currentState.showSnackBar(const SnackBar(
              //         content: Text('invalid OTP'),
              //       ));
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.user.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          logger.d(credential.token);
          logger.d(credential.verificationId);
          logger.d(credential.signInMethod);
        },
        verificationFailed: (FirebaseAuthException e) {
          logger.d('verificationFailed ${e.message}');
        },
        codeSent: (String verficationID, int? resendToken) {
          logger.d('CodeSent $verficationID');
          logger.d('CodeSent $resendToken');
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          logger.d('CodeSent $verificationID');

          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: const Duration(seconds: 120));
  }

  Future<void> navToAttachList(context, idToken) async => Navigator.pop(
        context,
        idToken,
      );
}
