import 'dart:convert';
import 'package:flutter_session/flutter_session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:homescreen/AlSayfas.dart';
import 'package:homescreen/main.dart';
import 'package:homescreen/values/values.dart';
import 'package:homescreen/widgets/potbelly_button.dart';
import 'package:homescreen/widgets/spaces.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'SignUpScreen.dart';
import 'package:get/get.dart';

class User{
  final String isim;
  final String soyisim;
  final String il;
  final String dogumyili;

  User(this.isim, this.soyisim, this.il, this.dogumyili);


}

class UserData{
  getUserData() async{

  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var divWidth;
  bool _autoValidate = false;
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailTextController =
  new TextEditingController();
  final TextEditingController _passwordTextController =
  new TextEditingController();

  get password async {
    return _passwordTextController;
  }
  var kMarginPadding = 16.0;
  var kFontSize = 13.0;
  String errormsg;

  var url = "https://www.easyrescuer.com/girisflutter.php";
  String finalTel,finalisim,finalSoyisim,finaldogumyili,finalil,finalid;
  void addData() async{
    var response = await http.post(Uri.parse(url),
        body: {
          "email": _emailTextController.text.trim(),
          "password": _passwordTextController.text.trim(),

        }
    );
    var jsonData = jsonDecode(response.body);
    var jsonString = jsonData['message'];
    var jsonisim = jsonData['isim'];
    var jsonSoyisim = jsonData['soyisim'];
    var jsonDogumyili = jsonData['dogumyili'];
    var jsonTel = jsonData['tel'];
    var jsonil = jsonData['il'];
    var id = jsonData['id'];

    if(jsonString=='Ba??ar??yla giri?? yapt??n??z.'){
      myToast(jsonString);
      //await FlutterSession().set('token',_emailTextController.text.trim());


      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString('email', _emailTextController.text);
      var obtainEmail = sharedPreferences.getString('email');
      finalEmail = obtainEmail;

      sharedPreferences.setString('id', id);
      var obtainId = sharedPreferences.getString('id');
      finalid =obtainId ;


      sharedPreferences.setString('isim', jsonisim);
      var obtainIsim = sharedPreferences.getString('isim');
      finalisim = obtainIsim;

      sharedPreferences.setString('soyisim', jsonSoyisim);
      var obtainsoyisim = sharedPreferences.getString('soyisim');
      finalSoyisim =obtainsoyisim;

      sharedPreferences.setString('dogumyili', jsonDogumyili);
      var obtaindogumyili = sharedPreferences.getString('dogumyili');
      finaldogumyili = obtaindogumyili;

      sharedPreferences.setString('tel', jsonTel);
      var obtaintel = sharedPreferences.getString('tel');
      finalTel =obtaintel;

      sharedPreferences.setString('il', jsonil);
      var obtainil = sharedPreferences.getString('il');
      finalil =obtainil;

      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => AlSayfas()));


      print('ba??ar??l??');
      print('$obtainId $obtainIsim  $obtainsoyisim $obtaintel $obtaindogumyili ');
    }else{
      myToast(jsonString);
      print('ba??ar??s??z');
    }
  }



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    divWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/backg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Column(
                    children: <Widget>[_buildEmailSignUpForm()],
                  )),
            ),
          ),
        ));
  }

  Widget _buildEmailSignUpForm() {
    //Form 1
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: 50.0,
          width: 145.0,
          child: Icon(
            Icons.account_box,
            size: 100.0,
          ),
        ),
        new Container(
          margin: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
          padding: EdgeInsets.only(bottom: 45),
          child: new Text(
            "Giri?? Yap",style: Styles.titleTextStyleWithSecondaryTextColor,
            maxLines: 1,
          ),
        ),
        new Container(

          height: 65,
          width: 250,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.only(
            left: 10,
            right: 50,
          ),
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new TextFormField(
              style: Styles.normalTextStyle,
              controller: _emailTextController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(prefixIcon: Icon(Icons.email_outlined),
                //labelText: " ",
                hintText: "E-posta adresinizi giriniz",
                hintStyle: Styles.customNormalTextStyle(fontSize: 13,color: Colors.white),
                labelStyle: Styles.customNormalTextStyle(fontSize: 16),)),
        ),
        SpaceH16(),
        new Container( height: 65,
          width: 250,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.only(
            left: 10,
            right: 50,
          ),
          margin: EdgeInsets.only(left: 10.0, right: 10.0),
          child: new TextFormField(
              style: Styles.customNormalTextStyle(fontSize: 16),
              obscureText: true,
              validator: (String value) {
                if (value.isEmpty) {
                  return "L??tfen ??ifrenizi girin";
                } else {
                  return null;
                }
              },
              controller: _passwordTextController,
              decoration: InputDecoration(prefixIcon: Icon(Icons.lock),
                //  labelText: "",
                hintText: "??ifrenizi girin",hintStyle: Styles.customNormalTextStyle(fontSize: 13),
                labelStyle: Styles.customNormalTextStyle(fontSize: 16),)),
        ),
        SpaceH30(),
        new PotbellyButton(
          StringConst.LOGIN,
          onTap: () {
            _loginButtonTapped();



          },
        ),
        //onPressed: () { _loginButtonTapped();},

        new FlatButton(
            onPressed: () {},
            child: new Text(
              '??ifrenizi mi unuttunuz?',style: Styles.normalTextStyle,
            )),
        new Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SignUpScreen()));
            },
            child: new Text(
              'Hesab??n??z yok mu?',
              style: Styles.customNormalTextStyle(fontSize: 17),
            ),
          ),
        ),
      ],
    );
  }

  String _validateEmail(String email) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(email))
      return null;
    else
      return "L??tfen do??ru bir e-posta adresi girin.";
  }

  _loginButtonTapped() {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_formKey.currentState.validate()) {

      addData();

    }
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