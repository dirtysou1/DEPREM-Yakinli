

import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:homescreen/GvendeBildirim.dart';
import 'package:homescreen/plugins_utils/DeviceInfo.dart';
import 'package:homescreen/plugins_utils/Location.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_watcher/volume_watcher.dart';
import 'package:battery/battery.dart';
import 'YardmBildirim.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:telephony/telephony.dart';
import 'main.dart';

import 'package:url_launcher/url_launcher.dart';


class Butonlar extends StatefulWidget {
  @override
  _ButonlarState createState() => _ButonlarState();
}

class _ButonlarState extends State<Butonlar> {


  String token1;

  @override
  void initState() {
    super.initState();
    initPlayer();
    initPlatformState();
  }




  ////////////////////////////////

  Duration _duration = new Duration();
  Duration _position = new Duration();
  AudioPlayer advancedPlayer;

  AudioCache audioCache;



  void initPlayer() {
    advancedPlayer = new AudioPlayer();

    audioCache =
    new AudioCache(fixedPlayer: advancedPlayer, respectSilence: false);

    advancedPlayer.durationHandler = (d) => setState(() {
      _duration = d;
    });


    advancedPlayer.positionHandler = (p) => setState(() {
      _position = p;
    });
  }

  String _platformVersion = 'Unknown';
  double currentVolume = 0;
  double initVolume = 0;
  double maxVolume = 0;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      VolumeWatcher.hideVolumeView = true;
      platformVersion = await VolumeWatcher.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    double initVolume;
    double maxVolume;
    try {
      initVolume = await VolumeWatcher.getCurrentVolume;
      maxVolume = await VolumeWatcher.getMaxVolume;
    } on PlatformException {
      platformVersion = 'Failed to get volume.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      this.initVolume = initVolume;
      this.maxVolume = maxVolume;
    });
  }

  final Battery _battery = Battery();
  LocationService loca1 = new LocationService();
  UserLocation Loca = new UserLocation();
  bool yardim;
  Future yardimSil() async{
    var url = 'https://www.easyrescuer.com/YardimSil.php';
    var response = await http.post(Uri.parse(url),
        body: {
          "yardim_tel": finaltel.toString().trim(),


        }
    );
    return jsonDecode(response.body);

  }



  void NumaraCek() async{

    var url = 'https://www.easyrescuer.com/NumaraCekme.php';
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final LOCA = (await loca1.location.getLocation()).toString();
    sharedPreferences.setString('Location', LOCA);
    var konum = await sharedPreferences.getString('Location');
    final SharedPreferences numara = await SharedPreferences.getInstance();
    final Telephony telephony = Telephony.instance;
    var response = await http.post(Uri.parse(url),


        body: {
          "userid": finalID.toString().trim(),
        }
    );

    List text = jsonDecode(response.body);
    text.forEach((element) {

      var a = element.toString();
      dynamic intValue = int.parse(a.replaceAll(RegExp('[^0-9]'), ''));
      print(intValue);





      String guvende = "Merhaba, sizi yak??n?? olarak ekleyen ${finalisim.toUpperCase()} ${finalsoyisim.toUpperCase()} g??vende oldu??unu belirtti. Kordinatlar??: $konum";
      String yardimmesaj  = "Sizi yak??n?? olarak ekleyen ${finalisim.toUpperCase()} ${finalsoyisim.toUpperCase()} TEHL??KEDE oldu??unu belirtti. Kordinatlar??: $konum";
      telephony.sendSms(
            to: "+90$intValue",

            message:yardim ? yardimmesaj:guvende
        );
      }
      //print(element.toString());

    );
  }






  var urlTehlike = "https://www.easyrescuer.com/yardim.php";
  void addData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var isim = await sharedPreferences.getString('isim');
    var tel = await sharedPreferences.getString('tel');
    var dogumyili = await sharedPreferences.getString('dogumyili');
    var soyisim = await sharedPreferences.getString('soyisim');
    var konum = await sharedPreferences.getString('Location');
    var model = await sharedPreferences.getString('model');
    var battery = await sharedPreferences.getString('battery');
    var response = await http.post(Uri.parse(urlTehlike),
        body: {
          "yardim_isim":isim.trim() ,
          "yardim_soyisim": soyisim.trim(),
          "yardim_DogumYili": dogumyili.trim(),
          "yardim_tel": tel.trim(),
          "yardim_TelBatarya": battery.trim(),
          "yardim_TelefonModel": model.trim(),
          "yardim_konum": konum.trim(),
        }
    );
    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];



    if(jsonString=='Yard??m ??a??r??n??z al??nm????t??r.'){

      var mesaj =myToast(jsonString).toString();



      //You can route to your desire page here

    }else{
      myToast(jsonString);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff000000),
      body: Stack(
        children: <Widget>[
          Pinned.fromSize(
            bounds: Rect.fromLTWH(0.0, 0.0, 375.0, 667.0),
            size: Size(375.0, 667.0),
            pinLeft: true,
            pinRight: true,
            pinTop: true,
            pinBottom: true,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/butonbg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.37), BlendMode.dstIn),
                ),
                border: Border.all(width: 1.0, color: const Color(0x00000000)),
              ),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(267.6, 445.9, 98.9, 105.9),
            size: Size(375.0, 667.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 0.0, 98.9, 105.9),
                  size: Size(98.9, 105.9),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                      color: const Color(0xff950404),
                      border: Border.all(
                          width: 1.0, color: const Color(0xffffffff)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(280.1, 464.8, 69.0, 66.0),
            size: Size(375.0, 667.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/sos.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(width: 1.0, color: const Color(0x00000000)),
              ),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(256.9, 178.2, 97.6, 93.6),
            size: Size(375.0, 667.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: SvgPicture.string(
              _svg_ncv7d4,
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(274.6, 197.1, 69.7, 55.7),
            size: Size(375.0, 667.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/images/iyi.png'),
                  fit: BoxFit.cover,
                ),
                border: Border.all(width: 1.0, color: const Color(0x00000000)),
              ),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(17.5, 152.8, 224.8, 166.0),
            size: Size(375.0, 667.0),
            pinLeft: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 0.0, 224.8, 166.0),
                  size: Size(224.8, 166.0),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child: Stack(
                    children: <Widget>[
                      Pinned.fromSize(
                        bounds: Rect.fromLTWH(0.0, 0.0, 224.8, 166.0),
                        size: Size(224.8, 166.0),
                        pinLeft: true,
                        pinRight: true,
                        pinTop: true,
                        pinBottom: true,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            color: const Color(0x40ffffff),
                            border: Border.all(
                                width: 1.0, color: const Color(0x40707070)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(10.0, 9.8, 200.8, 144.4),
                  size: Size(224.8, 166.0),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child: SingleChildScrollView(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            color: const Color(0xffffffff),
                            letterSpacing: 1.7000000000000002,
                          ),
                          children: [
                            TextSpan(
                              text: '      ',
                            ),
                            TextSpan(
                              text: 'G??VENDEY??M\n',
                              style: TextStyle(
                                fontSize: 20,
                                color: const Color(0xff62c539),
                                letterSpacing: 2,
                              ),
                            ),
                            TextSpan(
                              text: '\n',
                            ),
                            TextSpan(
                              text:
                              'Sistemde kay??tl?? yak??nlar??n??za g??vende oldu??unuz bilgisi g??nderilir ve sizi en yak??n g??venli b??lgeye y??nlendirir.\n',
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 1.3,
                              ),
                            ),
                          ],
                        ),
                        textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )),
                ),
              ],
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(14.9, 404.6, 247.1, 196.9),
            size: Size(375.0, 667.0),
            pinLeft: true,
            pinBottom: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Stack(
              children: <Widget>[
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(10.9, 4.6, 230.1, 187.6),
                  size: Size(260.1, 196.9),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child:
                  // Adobe XD layer: '  G??VENDE DE????L??M  ???' (text)
                  SingleChildScrollView(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 17,
                            color: const Color(0xffffffff),
                            letterSpacing: 1.7000000000000002,
                          ),
                          children: [
                            TextSpan(
                              text: '  ',
                            ),
                            TextSpan(
                              text: 'G??VENDE DE????L??M\n',
                              style: TextStyle(
                                fontSize: 20,
                                color: const Color(0xffec4949),
                                letterSpacing: 2,
                              ),
                            ),
                            TextSpan(
                              text: '\n',
                            ),
                            TextSpan(
                              text:
                              '  Sahadaki yard??m ekiplerine ve yak??nlar??n??za tehlikede oldu??unuz bilgisi ve konumunuz g??nderilir. Bir ik??z sesi g??vende oldu??unuzu belirtene kadar ??alacakt??r.',
                              style: TextStyle(
                                fontSize: 13,
                                letterSpacing: 1.3,
                              ),
                            ),

                          ],
                        ),
                        textHeightBehavior:
                        TextHeightBehavior(applyHeightToFirstAscent: false),
                        textAlign: TextAlign.left,
                      )),
                ),
                Pinned.fromSize(
                  bounds: Rect.fromLTWH(0.0, 0.0, 247.1, 196.9),
                  size: Size(247.1, 196.9),
                  pinLeft: true,
                  pinRight: true,
                  pinTop: true,
                  pinBottom: true,
                  child: Stack(
                    children: <Widget>[
                      Pinned.fromSize(
                        bounds: Rect.fromLTWH(0.0, 0.0, 247.1, 196.9),
                        size: Size(260.1, 196.9),
                        pinLeft: true,
                        pinRight: true,
                        pinTop: true,
                        pinBottom: true,
                        child: SvgPicture.string(
                          _svg_ngabl0,
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(242.0, 178.0, 133.0, 107.0),
            size: Size(375.0, 667.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 1.0, color: Colors.transparent),
              ),
              child: FlatButton(
                onPressed: () async {
                  yardim= false;
                  NumaraCek();

                  yardimSil();

                  advancedPlayer.stop();
                  advancedPlayer.dispose();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => GvendeBildirim()));
                },
                child: Text(''),
              ),
            ),
          ),
          Pinned.fromSize(
            bounds: Rect.fromLTWH(262.0, 446.0, 113.0, 113.0),
            size: Size(375.0, 667.0),
            pinRight: true,
            fixedWidth: true,
            fixedHeight: true,
            child: Container(
              child: FlatButton(
                onPressed: () async {
                  yardim= true;
                  //NumaraCek();


                  // VolumeWatcher.setVolume(maxVolume); //sesi maximuma ????kar??r
                  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

                  //batarya bilgisini al??r
                  final int batteryLevel = await _battery.batteryLevel;
                  String batterylevel = batteryLevel.toString();

                  sharedPreferences.setString('battery', batterylevel);

                  print("Battery level is: $batterylevel");

                  //telefonun modelini ????renir
                  final String model = await DeviceInfo.getAndroidDeviceInfo();
                  print(model);
                  sharedPreferences.setString('model', model);


                  //konumu al??r
                  // ignore: non_constant_identifier_names
                  final LOC = (await loca1.location.getLocation()).toString();
                  sharedPreferences.setString('Location', LOC);

                  print(LOC);

                  //popup mesaj??n?? ekranda g??sterir

                  //alarm?? ??alar
                  audioCache.loop(
                    "alarm.mp3",
                    stayAwake: true,
                  );

                  //addData();
                  NumaraCek();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => YardmBildirim()));
                },
                child: Text(''),
              ),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 1.0, color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }





}

myToast(String toast){
  return Fluttertoast.showToast(
      msg: toast,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white
  );
}
const String _svg_ncv7d4 =
    '<svg viewBox="256.9 178.2 97.6 93.6" ><path transform="translate(256.92, 178.17)" d="M 48.79222106933594 0 C 75.73941040039063 0 97.58444213867188 20.94243621826172 97.58444213867188 46.7762336730957 C 97.58444213867188 72.61003112792969 75.73941040039063 93.55246734619141 48.79222106933594 93.55246734619141 C 21.84502220153809 93.55246734619141 -3.814697322468419e-07 72.61003112792969 -3.814697322468419e-07 46.7762336730957 C -3.814697322468419e-07 20.94243621826172 21.84502220153809 0 48.79222106933594 0 Z" fill="#058745" stroke="#ffffff" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_ngabl0 =
    '<svg viewBox="-9.0 247.0 247.1 196.9" ><path transform="translate(-9.0, 247.0)" d="M 21.67238616943359 0 L 74.31249237060547 0 L 225.392822265625 0 C 237.3621673583984 0 247.0652008056641 18.89200401306152 247.0652008056641 42.19646835327148 L 247.0652008056641 154.7203979492188 C 247.0652008056641 178.0248718261719 237.3621673583984 196.9168395996094 225.392822265625 196.9168395996094 L 182.3333587646484 196.9168395996094 L 21.67238616943359 196.9168395996094 C 9.703059196472168 196.9168395996094 0 178.0248718261719 0 154.7203979492188 L 0 42.19646835327148 C 0 18.89200401306152 9.703059196472168 0 21.67238616943359 0 Z" fill="#ffffff" fill-opacity="0.25" stroke="#707070" stroke-width="1" stroke-opacity="0.25" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
