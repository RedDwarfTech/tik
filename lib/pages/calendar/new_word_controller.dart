import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewWordController extends GetxController {
  var isLoading = true.obs;
  var searchWord = "".obs;

  List<Card> _wordWidget = List.empty(growable: true);

  List<Card> get getCurrentRender => _wordWidget;

  @override
  void onInit() {
    super.onInit();
  }


  void updateWords(String word) async {
    searchWord(word);
  }

  void fetchSearchResult() async {

  }

  void addLearningWord(String word) async {
    isLoading(true);
    try {
     
    } finally {
      isLoading(false);
    }
  }
}
