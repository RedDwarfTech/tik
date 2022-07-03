import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../includes.dart';

class OcrEngineChooserPage extends StatefulWidget {

  const OcrEngineChooserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _OcrEngineChooserPageState();
}

class _OcrEngineChooserPageState extends State<OcrEngineChooserPage> {
  String? _identifier;

  String t(String key, {required List<String> args}) {
    return 'page_ocr_engine_chooser.$key'.tr(args: args);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  void _handleClickOk() async {


    Navigator.of(context).pop();
  }



  Widget _build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: Text(t('title', args: [])),
        actions: [
          CustomAppBarActionItem(
            text: 'ok'.tr(),
            onPressed: _handleClickOk,
          ),
        ],
      ),
      body: null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}
