import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../includes.dart';

class SettingInterfacePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingInterfacePageState();
}

class _SettingInterfacePageState extends State<SettingInterfacePage> {

  String t(String key, {List<String>? args}) {
    return 'page_setting_interface.$key'.tr(args: args);
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title')),
      ),
      body: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
