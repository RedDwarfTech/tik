
class TranslationResultRecord {
  String id;
  String translationTargetId;
  String translationEngineId;


  TranslationResultRecord({
    required this.id,
    required this.translationTargetId,
    required this.translationEngineId,

  });

  factory TranslationResultRecord.fromJson(Map<String, dynamic> json) {
    return TranslationResultRecord(
      id: json['id'],
      translationTargetId: json['translationTargetId'],
      translationEngineId: json['translationEngineId'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'translationTargetId': translationTargetId,
      'translationEngineId': translationEngineId,
    }..removeWhere((key, value) => value == null);
  }
}
