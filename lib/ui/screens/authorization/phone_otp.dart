// ignore_for_file: unused_local_variable, avoid_redundant_argument_values, omit_local_variable_types, unnecessary_cast, lines_longer_than_80_chars

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';


class PhoneOtp extends StatefulWidget {
  @override
  _PhoneOtpState createState() => _PhoneOtpState();
}

class _PhoneOtpState extends State<PhoneOtp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  late String _verificationId;
  var logger = Logger();

  void showSnackbar(String message) {
    _scaffoldKey.currentState!.showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _auth.setLanguageCode('ru-Ru');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone number (+xx xxx-xxx-xxxx)',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async => {
                 //   _phoneNumberController.text = await _autoFill.hint,
                  },
                  child: const Text('Get current number'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await verifyPhoneNumber();
                  },
                  child: const Text('Verify Number'),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  child: const Text('SignOut'),
                ),
              ),
              TextFormField(
                controller: _smsController,
                decoration: const InputDecoration(
                  labelText: 'Verification code',
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                    onPressed: () async {
                      final result = await registerToFb(
                        '+201096918673',
                        context,
                      );
                      logger.d(result);
                      // signInWithPhoneNumber();
                    },
                    child: const Text('Sign in')),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signInWithPhoneNumber() async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      /* final user = (await _auth.signInWithCredential(credential)).user;
      logger.d(user.refreshToken);
      logger.d(user.getIdToken(true));*/

      logger.d(_verificationId);
      logger.d(_smsController.text);
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      ))
          .then((value) async {
        value.credential!.token;

        logger.d(value.credential);
        logger.d(value.user);
        logger.d(value.additionalUserInfo);
        // admin.auth().getUser(decodedIdToken.sub).

        if (value.user != null) {
          logger.d(value.credential!.token);
          logger.d(value.user);
          //logger.d(value.credential);


          //   sl<LoginManager>().inCreateFirebase.add(_verifyNumber);

          /*   await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) =>
                            HomeScreen(),),
                            (route) => false);*/
        }
      });

      //   sl<LoginManager>().inCreateFirebase.add(_verifyNumber);

      showSnackbar('Successfully signed in UID: }');
    } catch (e) {
      showSnackbar('Failed to sign in: ' + e.toString());
    }
  }

  Future<String> registerToFb(String phoneNumber, BuildContext context) {
    final completer = Completer<String>();

    _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (PhoneAuthCredential credential) async {
        final authresult = await _auth.signInWithCredential(credential);

        final user = authresult.user;
        _getUserFromFirebase(user!);
        completer.complete('signedUp');
      },
      verificationFailed: (FirebaseAuthException e) {
        final error = e.code == 'invalid-phone-number'
            ? 'Invalid number. Enter again.'
            : 'Can Not Login Now. Please try again.';
        completer.complete(error);
      },
      codeSent: (String verificationId, int? resendToken) {
        completer.complete('verified');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        completer.complete('timeout');
      },
    );

    return completer.future;
  }

  Future<void> verifyPhoneNumber() async {
    //Callback for when the user has already
    // previously signed in with this phone number on this device
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      final result = await _auth.signInWithCredential(phoneAuthCredential);

      logger.d(result.user!.refreshToken);
      logger.d(result.credential!.token);
      logger.d(result.additionalUserInfo);
      showSnackbar(
        'Phone number automatically verified and user signed in: '
        '${_auth.currentUser!.uid} ${phoneAuthCredential.verificationId}',
      );
    };

    //Listens for errors with verification, such as too many attempts
    final PhoneVerificationFailed verificationFailed = (
      FirebaseAuthException authException,
    ) {
      showSnackbar('Phone number verification failed. Code: '
          '${authException.code}. Message: ${authException.message}');
    };
    //Callback for when the code is sent
    final PhoneCodeSent codeSent = (
      String verificationId, [
      int? forceResendingToken,
    ]) async {
      showSnackbar('Please check your phone for the verification code.');
      //_verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    } as PhoneCodeSent;
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (
      String verificationId,
    ) {
      showSnackbar('verification code: ' + verificationId);
      // _verificationId = verificationId;
      // _verifyNumber.sessionInfo = _verificationId;
      setState(() {
        _verificationId = verificationId;
      });
      logger.d(verificationId);
      //_verifyNumber.code =  _smsController.text;

      /*  logger.d(_verifyNumber.sessionInfo);
      logger.d(_verifyNumber.code);

      sl<LoginManager>().inCreateFirebase.add(_verifyNumber);
*/
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar('Failed to Verify Phone Number: $e');
    }
  }

  void _getUserFromFirebase(User user) {}
}
