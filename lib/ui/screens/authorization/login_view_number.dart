// ignore_for_file: unused_import, lines_longer_than_80_chars, prefer_final_locals, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'login_page.dart';

class LoginPhoneNumberView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          title: const Text('Phone Login'),
        ),
        body: PhoneAuthView(),
      ),
    );
  }
}

class PhoneAuthView extends StatefulWidget {
  @override
  _PhoneAuthViewState createState() => _PhoneAuthViewState();
}

class _PhoneAuthViewState extends State<PhoneAuthView> {
  late bool isPhoneNumberSubmitted;
  late bool isCodeVerified;
  late String verificationCode;
  var logger = Logger();
  late TextEditingController _countryCodeController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _codeNumberController;

  @override
  void initState() {
    super.initState();
    isPhoneNumberSubmitted = false;
    isCodeVerified = false;
    _countryCodeController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _codeNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return !isPhoneNumberSubmitted ? phoneNumberSubmitWidget() : codeVerificationWidget();
  }

  Widget phoneNumberSubmitWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 80,
              child: TextField(
                controller: _countryCodeController,
                maxLength: 3,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '+',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 250,
              child: TextField(
                controller: _phoneNumberController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: _verifyPhoneNumber,
          child: const Text('Submit'),
        )
      ],
    );
  }

  Widget codeVerificationWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _codeNumberController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              hintText: 'Enter Code sent on phone',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        OutlinedButton(
          onPressed: _verifySMS,
          child: const Text('verify'),
        )
      ],
    );
  }

  Future<void> _verifyPhoneNumber() async {
    final phoneNumber = ('\+' + _countryCodeController.text + _phoneNumberController.text);
    print(phoneNumber);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: _verificationCompleted,
      verificationFailed: _verficationFailed,
      codeSent: _codeSent,
      codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
    );
    setState(() {
      isPhoneNumberSubmitted = true;
    });
  }

  Future<void> _verifySMS() async {
    setState(() {
      isCodeVerified = true;
    });
    await _signInWithPhoneNumber();
  }

  //* Setting some callback for firebase phone auth

  //If on android it will work
  Future<void> _verificationCompleted(PhoneAuthCredential credential) async {
    print('Verfication completed is called ');
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    print('user have singed with ${userCredential.user!.uid}');
  }

  Future<void> _verficationFailed(FirebaseException exception) async {
    print('Verificatiaon failed is called ${exception.toString()}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error occured ${exception.toString()}')),
    );
    setState(() {
      isPhoneNumberSubmitted = false;
    });
  }

  Future<void> _codeSent(String verificationId, int? resendToken) async {
  print('Code sent is called with $verificationId and token $resendToken');
  setState(() {
    isPhoneNumberSubmitted = true;
    verificationCode = verificationId;
  });
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('OTP is sent to your mobile number')),
  );
}

  Future<void> _codeAutoRetrievalTimeout(String verificationId) async {
    print('Code auto retreival time out is called with verification id $verificationId');
  }

  //* For logging you in with phone number
  Future<void> _signInWithPhoneNumber() async {
    final code = _codeNumberController.text;

    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationCode,
      smsCode: (code == null || code.trim().isEmpty) ? '123456' : code,
    );

    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    //logger.d(userCredential.user.refreshToken);
    //logger.d(userCredential);

/*    await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));*/
     var token = await userCredential.user!.getIdToken(true);
     var tokenResult = await userCredential.user!.getIdTokenResult(true);
    print('Token value --------- $token');
    print('TokenResult value ----- $tokenResult');

   /* final tokenResult = await FirebaseAuth.instance.currentUser;
    final idToken = await tokenResult.getIdToken();
    final tokenValue = idToken.token;*/



   /* try {
      await FirebaseAuth.instance
          .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: (code == null || code.trim().length == 0) ? '123456' : code,))
          .then((value) async {
        logger.d(value);
        if (value.user != null) {
         //logger.d(value.user);
        }

      });
    }
    on FirebaseAuthException catch(error){
      logger.d(error.message);
      logger.d(error.credential);
      logger.d(error);
    }
*/


  }
}
