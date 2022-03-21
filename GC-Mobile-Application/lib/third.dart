import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:united_app/fourth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:fluttertoast/fluttertoast.dart';

import 'ServerRequests/http.dart';
import 'model/loading.dart';
import 'model/user.dart';
import 'package:apple_sign_in/apple_sign_in.dart';

class ThirdPage extends StatefulWidget {
  final User newUser;
  ThirdPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return ThirdPageState(newUser);
  }
}

class ThirdPageState extends State<ThirdPage> {
  User newUser;
  ThirdPageState(this.newUser);

  bool obscureText = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  Map userProfile;
  bool _isLoggedIn = false;
  final facebookLogin = FacebookLogin();
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  bool validateForm = false;
  bool loading = false;
  bool iosPlatform = false;



  void DefaultSignUpSetStateFalseDuplicate(setState){
    setState(() {
      loading = false;
    });
    Fluttertoast.showToast(
        msg: "An account with this email already exists.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black);
  }

  void DefaultSignUpSetStateFalseNotValidated(setState){
    setState(() {
      loading = false;
    });
    Fluttertoast.showToast(
        msg: "Please enter the correct details",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.black);
  }

  void DefaultSignUpSetStateFalse(setState) {
    setState(() {
      loading = false;
    });
    Navigator.push(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => FourthPage(newUser: newUser),
            transitionDuration: Duration(seconds: 0)));
  }
  void DefaultSignUpSetStateTrue(setState) {
    setState(() {
      loading = true;
    });  }



  signUpDetails() {
    return showDialog(
        context: context,
        builder: (context) {
          final node = FocusScope.of(context);
          return SingleChildScrollView(
            child: AlertDialog(
              title: Text('Join with email'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Name required";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(hintText: "Name"),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Email required";
                            } else if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(value)) {
                              return "Enter a valid email address";
                            } else {
                              return null;
                            }
                          },
                          controller: emailController,
                          onEditingComplete: () => node.nextFocus(),
                          decoration: InputDecoration(hintText: "Email"),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value.length <= 3) {
                              return "Password should be more than 3 characters";
                            } else {
                              return null;
                            }
                          },
                          obscureText: obscureText,
                          controller: passwordController,
                          onEditingComplete: () => node.unfocus(),
                          decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(Icons.remove_red_eye),
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text("Next"),
                  color: Colors.amber,
                  elevation: 10,
                  onPressed: () {
                    Navigator.pop(context);
                    validateFormAndSave();
                    setState(() => loading = true);
                    var data = validateEmail(emailController.text);
                    data.then((value) {
                      if (value == 0) {
                        newUser.FirstName = nameController.text;
                        newUser.Email = emailController.text;
                        newUser.password = passwordController.text;
                        if (validateForm) {
                          DefaultSignUpSetStateFalse(setState);
                        } else {
                          DefaultSignUpSetStateFalseNotValidated(setState);
                        }
                      } else {
                        DefaultSignUpSetStateFalseDuplicate(setState);
                      }
                    });
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            ),
          );
        });
  }


  loginWithFb() async {
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse =
        await http.get('https://graph.facebook.com/v2.12/me?fields=name,email,picture&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print("got profile");
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        if (_isLoggedIn) {
          newUser.FirstName = profile['name'];
          newUser.Email = profile['email'];
          //newUser.Email="ghulammustafa19092003@gmail.com";
          newUser.password = "nil";
          print(newUser.Email);
          if (newUser.Email == null) {
            Fluttertoast.showToast(
                msg: "A problem occured accessing your account.Please allow dance united to access from facebook",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black);
          } else {
            var data = validateEmail(newUser.Email);
            print(data);
            data.then((value) {
              if (value == 0) {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => FourthPage(newUser: newUser), transitionDuration: Duration(seconds: 0)));
              } else {
                Fluttertoast.showToast(
                    msg: "An account with this email already exists.",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.black);
              }
            });
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
        newUser.FirstName = _googleSignIn.currentUser.displayName;
        newUser.Email = _googleSignIn.currentUser.email;
        newUser.password = "nil";
        print(_googleSignIn.currentUser.email);
        var data = validateEmail(newUser.Email);
        data.then((value) {
          if (value == 0) {
            Navigator.push(
                context,
                PageRouteBuilder(
                    pageBuilder: (_, __, ___) => FourthPage(newUser: newUser), transitionDuration: Duration(seconds: 0)));
          } else {
            Fluttertoast.showToast(
                msg: "An account with this email already exists.",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.black);
          }
        });
      }
    } catch (err) {
      print(err);
    }
  }

  appleLogIn() async {
    if (await AppleSignIn.isAvailable()) {
      print("Apple SignIn is available for your device"); //Check if Apple SignIn isn available for the device or not
    } else {
      print('Apple SignIn is not available for your device');
    }

    if (await AppleSignIn.isAvailable()) {
      print("Is this avalaible");
      print(AppleSignIn.isAvailable());

      // final credential = await SignInWithApple.getAppleIDCredential(
      //   scopes: [
      //     AppleIDAuthorizationScopes.email,
      //     AppleIDAuthorizationScopes.fullName,
      //   ],
      // );
      //
      // print("This is my credentilas");
      // print(credential);

      final AuthorizationResult result = await AppleSignIn.performRequests([
        AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
      ]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          print("These are my credentials");
          print(result.credential);
          setState(() {
            _isLoggedIn = true;
          });
          if (_isLoggedIn) {
            newUser.FirstName = result.credential.fullName.familyName;
            newUser.Email = result.credential.email;
            newUser.password = result.credential.user;
            var data = validateEmail(result.credential.email);

            data.then((value) {
              if (value == 0) {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => FourthPage(newUser: newUser), transitionDuration: Duration(seconds: 0)));
              } else {
                Fluttertoast.showToast(
                    msg: "An account with this email already exists.",
                    toastLength: Toast.LENGTH_SHORT,
                    backgroundColor: Colors.black);
              }
            });
          }
          break; //All the required credentials
        case AuthorizationStatus.error:
          print("Sign in failed: ${result.error.localizedDescription}");
          break;
        case AuthorizationStatus.cancelled:
          print('User cancelled');
          break;
      }
    }
  }

  validateFormAndSave() async {
    print(formKey.currentState);
    //if(formKey.currentState!=null){
    if (formKey.currentState.validate()) {
      setState(() {
        validateForm = true;
      });
    } else {
      validateForm = false;
    }
    //}
  }

  Future<int> validateEmail(email) async {
    var result = await validateEmailFromServer("validateEmail", {"email": email});
    if (result.data['data'].length == 0) {
      return 0;
    } else {
      return 1;
    }
  }

  @override
  void initState() {
    nameController.text = newUser.FirstName;
    emailController.text = newUser.Email;
    passwordController.text = newUser.password;
    super.initState();
    if (Platform.isIOS) {
      iosPlatform = true; //check for ios if developing for both android & ios
      AppleSignIn.onCredentialRevoked.listen((_) {
        print("Credentials revoked");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return loading
        ? Loading()
        : Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/images/BackGroundSignUp.png"), fit: BoxFit.cover)),
          ),
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Color(0xff000000).withOpacity(0.2),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 100),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // RaisedButton.icon(
                        //   icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
                        //   label: Text(
                        //     "Continue With Facebook",
                        //     style: TextStyle(fontSize: 15, color: Colors.white),
                        //     textAlign: TextAlign.left,
                        //   ),
                        //   color: Color(0xff215BF0),
                        //   onPressed: () {
                        //     loginWithFb();
                        //   },
                        //   padding: EdgeInsets.fromLTRB(width * 0.05, width * 0.025, width * 0.05, width * 0.025),
                        // ),
                        // SizedBox(
                        //   width: width * 0.68,
                        //   child: RaisedButton.icon(
                        //     icon: Icon(FontAwesomeIcons.google),
                        //     label: Text(
                        //       "Continue With Google",
                        //       style: TextStyle(fontSize: 15, color: Colors.black),
                        //       textAlign: TextAlign.left,
                        //     ),
                        //     color: Colors.white,
                        //     onPressed: () {
                        //       loginWithGoogle();
                        //     },
                        //     padding: EdgeInsets.fromLTRB(width * 0.05, width * 0.025, width * 0.1, width * 0.025),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.amber)),
                        //   ),
                        // ),
                        SizedBox(height: 10),
                        SizedBox(
                          width: width * 0.68,
                          child: RaisedButton.icon(
                            icon: Icon(Icons.email),
                            label: Text(
                              "Continue With Email",
                              style: TextStyle(fontSize: 15, color: Colors.black),
                              textAlign: TextAlign.left,
                            ),
                            color: Colors.white,
                            onPressed: () {
                              signUpDetails();
                            },
                            padding: EdgeInsets.fromLTRB(width * 0.05, width * 0.025, width * 0.1, width * 0.025),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.amber)),
                          ),
                        ),
                        // iosPlatform
                        //     ? SizedBox(
                        //   width: width * 0.68,
                        //   height: 50,
                        //   child: AppleSignInButton(
                        //     type: ButtonType.continueButton,
                        //     onPressed: appleLogIn,
                        //   ),
                        // )
                        //     : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}