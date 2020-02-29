import 'package:flutter/cupertino.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';

class LanguageModel {
  String name;
  String languageCode;
  String countryCode;
  bool isSelected;

  Locale get locale {
    if (!TextUtil.isEmpty(languageCode)) {
      return Locale(languageCode);
    }
    return null;
  }

  LanguageModel(this.name, this.languageCode, this.countryCode, {this.isSelected: false});

  LanguageModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        languageCode = json['languageCode'],
        countryCode = json['countryCode'],
        isSelected = json['isSelected'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'languageCode': languageCode,
    'countryCode': countryCode,
    'isSelected': isSelected,
  };
}