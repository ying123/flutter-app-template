import 'package:canknow_flutter_ui/components/introduceSlider/IntroduceSlider.dart';
import 'package:canknow_flutter_ui/components/introduceSlider/Silde.dart';
import 'package:canknow_flutter_ui/utils/LocalStorage.dart';
import 'package:canknow_flutter_ui/utils/TimerUitl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/application/AuthorizationService.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:canknow_flutter_ui/utils/TextUtil.dart';
import 'package:flutter_app/application/JVerifyManage.dart';
import 'package:canknow_flutter_ui/utils/FileUtil.dart';
import 'package:flutter_app/config/globalConfig.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Splash extends StatefulWidget {
  Splash({Key key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool hadInit = false;
  bool firstBoot = true;
  List<Slide> slides = new List();
  static int duration = 3;
  int _count = duration;

  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  _initAsync() async {
    firstBoot = !LocalStorage.getBool('firstBooted');
    if (firstBoot) {
      this.getGuides();
      LocalStorage.setBool('firstBooted', true);
    }
    else {
      _doCountDown();
    }
    Future.delayed(Duration.zero, () {
      JVerifyManage().initialize(context);
    });
  }

  void _doCountDown() {
     TimerUtil timerUtil = TimerUtil(totalTime: duration * 1000);
     timerUtil.setOnTimerTickCallback((millisUntilFinished) {
       double _tick = millisUntilFinished / 1000;
       setState(() {
         _count = _tick.toInt();
       });
       if (_tick == 0) {
         next();
       }
     });
     timerUtil.startCountDown();
  }

  next(){
    if (GlobalConfig.mustAuthorize && !AuthorizationService.isAuthorized) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
    else {
      Navigator.of(context).pushReplacementNamed('/index');
    }
  }

  buildCountDown() {
    return Container(
      child: CircularPercentIndicator(
        radius: Variables.componentSizeLarge,
        lineWidth: 2,
        percent: (duration - _count) / duration,
        center: new Text(_count.toString()),
      ),
    );
  }

  buildScreen() {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(bottom: Variables.componentSpanLarge),
                    child: Center(
                      child: Image.asset(FileUtil.getImagePath('flash')),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: Variables.componentSpan),
                    child: Center(
                      child: Text('Welcome to canknow app', style: TextStyle(fontWeight: FontWeight.bold, fontSize: Variables.fontSizeLarge),),
                    ),
                  ),
                  Center(
                    child: Text('Welcome to canknow app', style: TextStyle(color: Variables.propertyColor, fontSize: Variables.fontSize),),
                  )
                ],
              ),
            ),
            Positioned(
              right: Variables.contentPaddingLarge,
              top: Variables.contentPaddingLarge,
              child: buildCountDown(),
            )
          ],
        ),
      ),
    );
  }

  getGuides () {
    slides.add(
      Slide(
        title: "ERASER",
        description: "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "assets/images/flash.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      Slide(
        title: "ERASER",
        description: "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "assets/images/flash.png",
        backgroundColor: Color(0xfff5a623),
      ),
    );
  }

  buildGuides() {
    return IntroduceSlider(
        slides: this.slides,
        onSkipPress: () {
          this.next();
        },
        onDonePress: (){
          this.next();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return firstBoot ? buildGuides() : buildScreen();
  }
}
