// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:onoy_kg/managers/login_manager.dart';
import 'package:onoy_kg/models/user.dart';
import 'package:onoy_kg/ui/helpers/helpers.dart';

import '../../../service_locator.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();

  var loading = false;

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() => loading = true);

      print(_user.name);
      print(_user.surname);
      print(_user.userType);
      print(_user.id);
      sl<LoginManager>().setUser.add(_user);
    }
  }

  final _user = UserModel();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 38),
            Text(
              'Мои данные',
              style: Helpers.titleTextStyle,
            ),
            const SizedBox(height: 50),
            _info(context, _user),
            StreamBuilder<UserModel>(
              stream: sl<LoginManager>().userResponse$,
              builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot)
              {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Text('Select lot');
                  case ConnectionState.waiting:
                    return const Text('');
                  case ConnectionState.active:
                    return _info(context, snapshot.data!);
                  case ConnectionState.done:
                    return Text('${snapshot.data} (closed)');
                }
                return null; // unreachable
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2 - 30,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(10),
                    foregroundColor: Colors.white,
                    backgroundColor: Helpers.blueColor,
                  ),
                  onPressed: _trySubmit,
                  child: const Text(
                    'Сохранить изменения',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _info(BuildContext context, UserModel userModel) {
    _user.userType = userModel.userType;
    _user.id = userModel.id;
    _user.checked = userModel.checked;
    _user.phoneNumber = userModel.phoneNumber;
    _user.registered = userModel.registered;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
              onChanged: (value) {
                _user.name = value;
              },
              initialValue: userModel.name,
              decoration: InputDecoration(
                hintText: 'Имя',
                hintStyle: Helpers.hintStyle,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Введите ваше имя';
                }
                return null;
              },
              onSaved: (value) {
                _user.name = value;
              }),
          const SizedBox(height: 8),
          TextFormField(
              initialValue: userModel.surname,
              decoration: InputDecoration(
                  hintText: 'Фамилия',
                  hintStyle: Helpers.hintStyle,
                  border: const OutlineInputBorder()),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Введите ваше фамилия';
                }
                return null;
              },
              onSaved: (value) {
                _user.surname = value;
              }),
        ],
      ),
    );
  }
}
