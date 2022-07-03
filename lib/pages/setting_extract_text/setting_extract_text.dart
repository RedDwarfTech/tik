import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../includes.dart';

class SettingExtractTextPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingExtractTextPageState();
}

class _SettingExtractTextPageState
    extends State<SettingExtractTextPage> {
  bool _useLocalOcrEngine = false;

  String t(String key, {List<String>? args}) {
    return 'page_setting_extract_text.$key'.tr(args: args);
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
