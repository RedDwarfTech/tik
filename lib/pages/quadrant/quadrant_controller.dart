import 'package:Tik/networking/rest/list/todo_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuadrantController extends GetxController {
  var isLoading = true.obs;
  var searchWord = "".obs;

  List<Card> _wordWidget = List.empty(growable: true);

  QuadrantController(TabController _tabController) {
    _tabController.addListener(() {
      // https://stackoverflow.com/questions/60252355/tabcontroller-listener-called-multiple-times-how-does-indexischanging-work
      if (!_tabController.indexIsChanging) {
        switch (_tabController.index) {
          case 0:
            renderWordCards(_tabController.index);
            break;
          case 1:
            renderWordCards(_tabController.index);
            break;
          case 2:
            renderWordCards(_tabController.index);
            break;
        }
      }
    });
  }

  List<Card> get getCurrentRender => _wordWidget;

  @override
  void onInit() {
    renderWordCards(0);

    super.onInit();
  }

  Future<List<Card>> renderWordCards(int tabName) async {
    List<Card> cards = List.empty(growable: true);

    _wordWidget = cards;
    update();
    return Future.value(cards);
  }

  void getTodoTasks() {
    TodoListProvider.getTodos();
  }

  void updateWords(String word) async {
    searchWord(word);
  }

  void fetchSearchResult() async {
    isLoading(true);
    try {
      if (searchWord.value.isEmpty) {
        return;
      }
    } finally {
      isLoading(false);
    }
  }

  void addLearningWord(String word) async {
    isLoading(true);
  }
}
