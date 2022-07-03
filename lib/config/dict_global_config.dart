import 'dart:async';

import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wheel/wheel.dart' show AppLogHandler, GlobalConfig, ConfigType;

import '../includes.dart';

final pageStorageBucket = PageStorageBucket();

class DictGlobalConfig {

  static final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static void loadApp(ConfigType configType) async {
    void _handleError(Object obj, StackTrace stack) {
      AppLogHandler.restLoggerException("global error", stack, obj);
    }

    runZonedGuarded(() async {
      GlobalConfig.init(configType);
      await initEnv('stable');
      await EasyLocalization.ensureInitialized();
      FlutterError.onError = (FlutterErrorDetails errorDetails) {
        AppLogHandler.logFlutterErrorDetails(errorDetails);
      };
      runApp(EasyLocalization(
        supportedLocales: [
          Locale(kLanguageEN),
          // Locale(kLanguageJA),
          // Locale(kLanguageKO),
          // Locale(kLanguageRU),
          Locale(kLanguageZH),
        ],
        path: 'assets/translations',
        assetLoader: YamlAssetLoader(),
        fallbackLocale: Locale(kLanguageEN),
        child: AppNavigator(),
      ));
    }, (Object error, StackTrace stackTrace) {
      _handleError(error, stackTrace);
    });
  }
}
