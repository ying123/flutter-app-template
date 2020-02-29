import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/ApplicationListTile.dart';
import 'package:canknow_flutter_ui/config/ComponentSize.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:flutter_app/models/LanguageModel.dart';
import 'package:flutter_app/store/index.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/LocalStorage.dart';
import 'package:flutter_app/store/localization.dart';

class LanguagesPage extends StatefulWidget {
  @override
  _LanguagesPageState createState() => _LanguagesPageState();
}

class _LanguagesPageState extends State<LanguagesPage> {
  @override
  void initState() {
    super.initState();
  }

  _updateData(){
    var localizationStore = Store.value<LocalizationStore>(context);
    String countryCode = localizationStore.currentLanguageModel.countryCode;
    for (int i = 0, length = localizationStore.items.length; i < length; i++) {
      localizationStore.items[i].isSelected = (localizationStore.items[i].countryCode == countryCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateData();
    var localizationStore = Store.value<LocalizationStore>(context);
    return new Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
        brightness: Brightness.light,
        centerTitle: true,
        title: new Text(ApplicationLocalizations.of(context).text("languagesSetting"),),
      ),
      body: ListView.builder(
          itemCount: localizationStore.items.length,
          itemBuilder: (BuildContext context, int index) {
            LanguageModel item = localizationStore.items[index];
            return new ApplicationListTile(
              ApplicationLocalizations.of(context).text(item.name),
              trailing: new Radio(
                  value: true,
                  groupValue: item.isSelected == true,
                  activeColor: Colors.indigoAccent,
                  onChanged: (value) {
                    setState(() {
                      localizationStore.setLanguageModel(item);
                      _updateData();
                      LocalStorage.setObject("currentLanguage", item.toJson());
                    });
                  }),
            );
          }),
    );
  }
}
