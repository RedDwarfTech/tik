import './translation_target.dart';

class TranslationResult {
  String id;
  TranslationTarget translationTarget;
  List<String> unsupportedEngineIdList;

  TranslationResult({
    required this.id,
    required this.translationTarget,
    required this.unsupportedEngineIdList,
  });

  factory TranslationResult.fromJson(Map<String, dynamic> json) {

    if (json['translationResultRecordList'] != null) {

    }

    return TranslationResult(
      id: json['id'],
      translationTarget: TranslationTarget.fromJson(json['translationTarget']),
      unsupportedEngineIdList: List<String>.from(
        json['unsupportedEngineIdList'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translationTarget': translationTarget,
      'unsupportedEngineIdList': unsupportedEngineIdList,
    };
  }
}
