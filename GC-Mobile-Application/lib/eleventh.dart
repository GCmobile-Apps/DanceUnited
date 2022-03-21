import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_app/explore.dart';
import 'model/loading.dart';
import 'model/user.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypt/crypt.dart';

class EleventhPage extends StatefulWidget {
  final User newUser;
  EleventhPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return EleventhPageState(newUser);
  }
}

class EleventhPageState extends State<EleventhPage> {
  User newUser;
  EleventhPageState(this.newUser);

  PickedFile pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  final storage = new FlutterSecureStorage();
  bool circularProgress = false;
  var imageResponse;

  void takePhoto(ImageSource source) async {
    final picked = await imagePicker.getImage(source: source);
    setState(() {
      pickedFile = picked;
    });
    setState(() {
      circularProgress = true;
    });
    if (pickedFile != null) {
      imageResponse = patchImage("addImage", pickedFile.path, newUser.UserID, "uploads");
      imageResponse.then((result) {
        newUser.profilePictureLink = result;
        setState(() {
          circularProgress = false;
        });
      });
    }
  }

  userSignUp() async {
    newUser.username = "username";
    newUser.LastName = "lastname";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', newUser.Email);
    prefs.setString('password', newUser.password);

    newUser.password = Crypt.sha256(newUser.password).toString();

    var result = await createNewUser("createNewUser", {"user": newUser.toJson()});
    if (result.data['status'] == true) {
      await storage.write(key: "token", value: result.data['token']);
      await storage.write(key: "preference1", value: 'Kizomba');
      await storage.write(key: "preference2", value: 'Salsa');
      await storage.write(key: "preference3", value: 'Bachata');

      newUser.UserID = result.data['data']['UserID'];
      newUser.FirstName = result.data['data']['FirstName'];
      newUser.LastName = result.data['data']['LastName'];
      newUser.username = result.data['data']['username'];
      newUser.password = result.data['data']['password'];
      newUser.StreetAddress = result.data['data']['StreetAddress'];
      newUser.City = result.data['data']['City'];
      newUser.Country = result.data['data']['Country'];
      newUser.ZipCode = result.data['data']['Zipcode'];
      newUser.ContactNumber = result.data['data']['ContactNumber'];
      newUser.Email = result.data['data']['Email'];
      newUser.profilePictureLink = result.data['data']['profilePictureLink'];
      newUser.Preference1 = result.data['data']['Preference1'];
      newUser.Preference2 = result.data['data']['Preference2'];
      newUser.Preference3 = result.data['data']['Preference3'];

      prefs.setString('token', result.data['token']);

//      Navigator.push(
//          context,
//          PageRouteBuilder(
//              pageBuilder: (_, __, ___) => Explore(newUser: newUser), transitionDuration: Duration(seconds: 0)));
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => Explore(newUser: newUser), transitionDuration: Duration(seconds: 0)),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration:
                BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/BackGroundSignUp.png"), fit: BoxFit.cover)),
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
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(3),
                              child: Container(
                                height: 7,
                                width: 7,
                                decoration: BoxDecoration(
                                    color: Colors.red, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),

//                  RaisedButton(
//                    child: Text("back"),
//                    color: Colors.amber,
//                    elevation: 10,
//                    onPressed: () {
//                      Navigator.push(
//                          context,
//                          PageRouteBuilder(
//                              pageBuilder: (_, __, ___) => TenthPage(newUser: newUser),
//                              transitionDuration: Duration(seconds: 0)));
//                    },
//                    shape: RoundedRectangleBorder(
//                        borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
//                    padding: EdgeInsets.all(8.0),
//                  ),

                    ],
                  ),
                  Center(
                      child: Text("Upload a profile picture",
                          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.bold))),
                  SizedBox(height: 30),
                  Stack(
                    alignment: Alignment.center,
                      children: [
                    CircleAvatar(
                      backgroundColor: Color(0xfff9df82),
                      radius: 120,
                      backgroundImage: pickedFile == null
                          ? AssetImage("assets/images/ProfilePicPlaceHolder.jpg")
                          : FileImage(File(pickedFile.path)),
                    ),
                    Center(
                      child: Container(
                        height: 240,
                        width: 240,
                        child: Center(
                            child: circularProgress
                                ? Loading2()
                                : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Select"),
                                IconButton(
                                    icon: Icon(Icons.camera_alt),
                                    onPressed: () {
                                      takePhoto(ImageSource.gallery);
                                    })
                              ],
                            )),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xffffc135).withOpacity(0),
                              const Color(0xffffc135).withOpacity(0.3),
                              const Color(0xffffc135).withOpacity(0.9),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                        child: Text("next"),
                        color: Colors.white,
                        elevation: 10,
                        onPressed: circularProgress
                            ? null
                            : () {
                          if (newUser.profilePictureLink == null) {
                            Fluttertoast.showToast(
                                msg: "Profile Picture Required",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.black);
                          } else {
                            userSignUp();
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.white)),
                        padding: EdgeInsets.all(8.0),
                      ),
                    ],
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
