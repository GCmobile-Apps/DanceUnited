import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/explore.dart';
import 'package:united_app/model/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:united_app/second.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypt/crypt.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homescreen.dart';
import 'model/loading.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

import 'professional/professional.dart';
import 'third.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  final storage = new FlutterSecureStorage();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  User user = new User();
  Map userProfile;
  bool _isLoggedIn = false;
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool loading=false;
  bool iosPlatform=false;
  User newUser = new User();


  loginWithFb() async {
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        print(graphResponse.body);
        final profile = JSON.jsonDecode(graphResponse.body);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });


        if (_isLoggedIn) {
          if(userProfile['email']){
            Fluttertoast.showToast(
                msg: "A problem occured accessing your account.Please allow dance united to access from facebook",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black);
          }
          else{
            userSignIn(userProfile['email'], "nil");
          }
        }

        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  loginWithGoogle() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedIn = true;
      });
      if (_isLoggedIn) {
        userSignIn(_googleSignIn.currentUser.email, "nil");
      }
    } catch (err) {
    }
  }



  appleLogIn() async {
    if(await AppleSignIn.isAvailable()) {
      //Check if Apple SignIn isn available for the device or not
    }else{
      print('Apple SignIn is not available for your device');
    }

    if(await AppleSignIn.isAvailable()) {
      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print(result.credential);

          var all_users_result = await getAllUsersForAppleSignin("allUsersForAppleSignin");


          for (int i=0; i<=all_users_result.data.length; i++){
            var Email = all_users_result.data['data'][i]['Email'];


            var result1 = await userLogin("userLogin", {"email": Email});

            if(result1.data['message'] != "Some error occurred.") {

              try{
                final h = Crypt(result1.data['data'][0]['password']);

                if (h.match(result.credential.user)){
                  print("Matched");
                  userSignIn(Email, result.credential.user);
                  break;//All the required credentials
                }
                else{
                  print("Not Matched - please try again");
                }
              } finally {
                continue;
              }

            }
          }
          break;//All the required credentials
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }

  userSignIn(email, password) async {
    var result = await userLogin("userLogin", {"email": email});

    if(result.data['message'] != "Some error occurred.") {
      final h = Crypt(result.data['data'][0]['password']);

      if (h.match(password)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('token', result.data['token']);

        if (result.data['status'] == true) {
          await storage.write(key: "token", value: result.data['token']);
          await storage.write(key: "preference1", value: 'Kizomba');
          await storage.write(key: "preference2", value: 'Salsa');
          await storage.write(key: "preference3", value: 'Bachata');
          user.UserID = result.data['data'][0]['UserID'];
          user.FirstName = result.data['data'][0]['FirstName'];
          user.LastName = result.data['data'][0]['LastName'];
          user.username = result.data['data'][0]['username'];
          user.password = result.data['data'][0]['password'];
          user.StreetAddress = result.data['data'][0]['StreetAddress'];
          user.City = result.data['data'][0]['City'];
          user.Country = result.data['data'][0]['Country'];
          user.ZipCode = result.data['data'][0]['Zipcode'];
          user.ContactNumber = result.data['data'][0]['ContactNumber'];
          user.Email = result.data['data'][0]['Email'];
          user.profilePictureLink = result.data['data'][0]['profilePictureLink'];
          user.Preference1 = result.data['data'][0]['Preference1'];
          user.Preference2 = result.data['data'][0]['Preference2'];
          user.Preference3 = result.data['data'][0]['Preference3'];
          setState(() => loading = false);
          Navigator.push(
              context,
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) => Explore(newUser: user), transitionDuration: Duration(seconds: 0)));
          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Explore(newUser: user)), (route) => false);
        }
      } else {
        setState(() => loading = false);
        Fluttertoast.showToast(
            msg: "Incorrect Password",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black);
      }
    }else{
      setState(() => loading = false);
      Fluttertoast.showToast(
          msg: "Account does not exists",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
    }
  }

  signInPopUp(BuildContext context) {
    return loading ? Loading() :showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Sign In"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(hintText: "Password"),
                  ),
                  SizedBox(height: 20),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: RaisedButton.icon(
                  //         icon: Icon(FontAwesomeIcons.google),
                  //         label: Expanded(
                  //             child:
                  //             Text("Continue with Google", style: TextStyle(color: Colors.black), textAlign: TextAlign.left)),
                  //         color: Colors.white,
                  //         onPressed: () {
                  //           loginWithGoogle();
                  //         },
                  //         padding: EdgeInsets.all(8.0),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // iosPlatform
                  //     ?Row(
                  //   children: [
                  //     AppleSignInButton(
                  //       type: ButtonType.continueButton,
                  //       onPressed: appleLogIn,
                  //     ),
                  //   ],
                  // ):Container()
                ],
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                child: Text("Sign In"),
                color: Colors.amber,
                onPressed: () {
                  setState(() => loading = true);
                  userSignIn(emailController.text, passwordController.text);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                padding: EdgeInsets.all(8.0),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if(Platform.isIOS){
      iosPlatform=true;//check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xfffede71),
                const Color(0xffffc135),
                const Color(0xffffa901),
                const Color(0xffff7829),
                const Color(0xffff3f58),
              ], // red to yellow
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 120),
              Text("Welcome", style: TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("to Dance United and our \n growing Dance Community",
                style: TextStyle(color: Colors.white, fontSize: 20), textAlign: TextAlign.center,),
              SizedBox(height: 50),
              RaisedButton(
                child: Text("join for free", style: TextStyle(color: Colors.white)),
                color: Color(0xff215BF0),
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ThirdPage(newUser: newUser), transitionDuration: Duration(seconds: 0)));
                },
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35.0), side: BorderSide(color: Color(0xff215BF0))),
                padding: EdgeInsets.symmetric(horizontal: 35.0, vertical: 15),
              ),
              SizedBox(height: 5),
              RaisedButton(
                child: Text(
                  "sign in",
                  style: TextStyle(color: Colors.white),
                ),
                color: Color(0xff215BF0),
                onPressed: () {
                  return loading ? Loading() :signInPopUp(context);
                },
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Color(0xff215BF0))),
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15),
              ),
              SizedBox(height: 5),
              RaisedButton(
                child: Text(
                  "Backstage PRO",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => Professional(), transitionDuration: Duration(seconds: 0)));
                },
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0), side: BorderSide(color: Colors.black)),
                padding: EdgeInsets.symmetric(horizontal: 50.0, vertical: 15),
              ),
              //SizedBox(height: height/2.5),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  //width: width * 0.7,
                  child: MaterialButton(
                    onPressed: () => {},
                    child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            children: <TextSpan>[
                              TextSpan(text: "By registering, you agree to our"),
                              TextSpan(text: " Terms of Service and our Privacy Policy", style: TextStyle(
                                  decoration: TextDecoration.underline, color: Colors.white),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => launch('')),
                            ]
                        )),
                  ),
                ),
              ),
              SizedBox(height:10),

            ],
          ),
        ),
      ),
    );
  }

}