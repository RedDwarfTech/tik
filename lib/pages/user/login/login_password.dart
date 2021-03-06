import 'package:Tik/pages/user/login/stretch_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:wheel/wheel.dart';

import '../profile/profile.dart';

class LoginPassword extends StatelessWidget {
  const LoginPassword({Key? key, required this.phone}) : super(key: key);

  final String phone;

  @override
  Widget build(BuildContext context) {
    final _inputController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('手机号登录')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                controller: _inputController,
                obscureText: true,
                keyboardType: TextInputType.url,
                decoration: const InputDecoration(hintText: '请输入密码'),
              ),
            ),
            StretchButton(
              text: '登录',
              primary: false,
              onTap: () async {
                final password = _inputController.text;
                if (password.isEmpty) {
                  toast('请输入密码');
                  return;
                }
                final AppLoginRequest loginRequest = AppLoginRequest(
                  loginType: LoginType.PHONE,
                  username: phone,
                  password: password,
                );
                AuthResult result = await Auth.appLogin(appLoginRequest: loginRequest);
                if(result.result.index == Result.ok.index){
                  var user = await Auth.currentUser();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Profile(user:user),
                    ),
                  );
                }else{
                  toast('Login Failed');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
