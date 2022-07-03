import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../includes.dart';

class SettingShortcutsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingShortcutsPageState();
}

class _SettingShortcutsPageState extends State<SettingShortcutsPage> {

  String t(String key) {
    return 'page_setting_shortcuts.$key'.tr();
  }

  @override
  void initState() {
    ShortcutService.instance.stop();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _configListen() {
    setState(() {});
  }

  Future<void> _handleClickRegisterNewHotKey(
    BuildContext context, {
    String? shortcutKey,
  }) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return RecordHotKeyDialog(

        );
      },
    );
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
