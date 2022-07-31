import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wheel/wheel.dart';

import '../../../includes.dart';
import '../user/login/login.dart';
import '../user/profile/profile.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onDismiss;

  const SettingsPage({Key? key, this.onDismiss}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {});
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: CustomAppBar(
        title: Text('我的'),
        leading: widget.onDismiss != null
            ? CustomAppBarCloseButton(
                onPressed: widget.onDismiss!,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 55, 0, 0),
          child: ListView(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(EvaIcons.person),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            title: Text("我的"),
                            onTap: () async {
                              bool isLoggedIn = await Auth.isLoggedIn();
                              if (isLoggedIn) {
                                var user = await Auth.currentUser();
                                Get.to(Profile(
                                  user: user,
                                ));
                              } else {
                                Get.to(Login());
                              }
                            },
                          )))),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
