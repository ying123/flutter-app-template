import 'package:flutter/material.dart';
import 'package:canknow_flutter_ui/components/ApplicationIcon.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/components/toast/Toast.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/locale/ApplicationLocalizations.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/store/authorization.dart';
import 'package:flutter_app/apis/account.dart';

class PhoneLogin extends StatefulWidget {
  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  bool loading = false;
  TextEditingController phoneNumberController = TextEditingController();
  bool isSubmitButtonDisabled = true;
  String _phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          buildPhoneNumberField(),
          buildSubmitButton(context),
        ],
      ),
    );
  }

  buildPhoneNumberField() {
    return Container(
      margin: EdgeInsets.only(bottom: Variables.componentSpan),
      child: TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(11)
          ],
          decoration: InputDecoration(
              icon: ApplicationIcon('mobile', size: 24,),
              hintStyle: TextStyle(fontSize: Variables.fontSize, color: Variables.placeholderColor),
              hintText:  ApplicationLocalizations.of(context).text('pleaseInputPhoneNumber'),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Variables.primaryColor)),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Variables.borderColor))
          ),
          onChanged: (String value) {
            _phoneNumber = value;
            setState(() {
              isSubmitButtonDisabled = value == null || !value.isNotEmpty || value.length < 11;
            });
          }
      ),
    );
  }

  Function handleSubmit() {
    if (!isSubmitButtonDisabled) {
      return () {
        submit();
      };
    }
    return null;
  }

  submit() async {
    this.setState(() {
      this.loading = true;
    });
    Provider.of<AuthorizationStore>(context).setLoginPhoneNumber(_phoneNumber);
    try{
      var result = await AccountApi.sendLoginPhoneCaptcha({
        "phoneNumber": _phoneNumber
      });
      AuthorizationService.setToken(result['accessToken']);
      Navigator.pushNamed(context, '/capcha', arguments: _phoneNumber);
    }
    catch (e) {
      Toast.error(context, e.message);
    }
    finally{
      this.setState(() {
        this.loading = false;
      });
    }
  }

  buildSubmitButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: Variables.componentSizeLarge,
        width: double.infinity,
        child: TextButton(
            loading: loading,
            disabled: isSubmitButtonDisabled,
            text: ApplicationLocalizations.of(context).text('getVerifyCode'),
            scene: Scene.primary,
            onTap: handleSubmit()
        ),
      ),
    );
  }
}
