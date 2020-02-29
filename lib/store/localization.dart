import 'package:flutter/material.dart';
import 'package:flutter_app/models/LanguageModel.dart';
import 'package:canknow_flutter_ui/utils/LocalStorage.dart';

class LocalizationStore with ChangeNotifier{
  LanguageModel currentLanguageModel;
  List<LanguageModel> items = new List();

  LocalizationStore(){
    items.add(LanguageModel("language.Auto", '', ''));
    items.add(LanguageModel("language.ZH", 'zh', 'CH'));
    items.add(LanguageModel("language.EN", 'en', 'US'));

    var json = LocalStorage.getObject("currentLanguage");
    if (json!=null) {
      currentLanguageModel = LanguageModel.fromJson(json);
    }
    else {
      currentLanguageModel = items[0];
    }
  }

  setLanguageModel(LanguageModel languageModel) {
    this.currentLanguageModel = languageModel;
    this.notifyListeners();
  }
}