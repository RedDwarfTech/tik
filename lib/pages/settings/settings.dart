import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wheel/wheel.dart';
import '../../../includes.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onDismiss;

  const SettingsPage({Key? key, this.onDismiss}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _inputSetting = kInputSettingSubmitWithEnter;

  String t(String key, {List<String>? args}) {
    return 'page_settings.$key'.tr(args: args);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
    });
  }


  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
        leading: widget.onDismiss != null
            ? CustomAppBarCloseButton(
                onPressed: widget.onDismiss!,
              )
            : null,
      ),
      body:null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
