import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'eleventh.dart';
import 'model/user.dart';
import 'ninth.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TenthPage extends StatefulWidget {
  final User newUser;
  TenthPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return TenthPageState(newUser);
  }
}

class TenthPageState extends State<TenthPage> {
  User newUser;
  TenthPageState(this.newUser);
  TextEditingController homeTownController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                                    color: Colors.red, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
//                      RaisedButton(
//                        child: Text("back"),
//                        color: Colors.amber,
//                        elevation: 10,
//                        onPressed: () {
//                          Navigator.push(
//                              context,
//                              PageRouteBuilder(
//                                  pageBuilder: (_, __, ___) => NinthPage(newUser: newUser),
//                                  transitionDuration: Duration(seconds: 0)));
//                        },
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
//                        padding: EdgeInsets.all(8.0),
//                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Pick your dance community",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      RaisedButton(
                        color: Colors.white,
                        elevation: 10,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              final kInitialPosition = LatLng(60.12816100000001, 18.643501);
                              return PlacePicker(
                                apiKey: "AIzaSyBG9rhs1LqFSbtMeYdWwhEZZtkaFIwKvnM", // Put YOUR OWN KEY here.
                                onPlacePicked: (result) {
                                  setState(() {
                                    var length2 = result.addressComponents.length;
                                    newUser.City = null;
                                    for (int i = 0; i < length2; i++) {
                                      if (result.addressComponents[i].types[0] == 'country') {
                                        newUser.Country = result.addressComponents[i].longName;
                                      }

                                      if (result.addressComponents[i].types[0] == 'locality' && newUser.City == null) {
                                        newUser.City = result.addressComponents[i].longName;
                                      } else if (result.addressComponents[i].types[0] == 'administrative_area_level_3' &&
                                          newUser.City == null) {
                                        newUser.City = result.addressComponents[i].longName;
                                      } else if (result.addressComponents[i].types[0] == 'administrative_area_level_2' &&
                                          newUser.City == null) {
                                        newUser.City = result.addressComponents[i].longName;
                                      } else if (result.addressComponents[i].types[0] == 'administrative_area_level_1' &&
                                          newUser.City == null) {
                                        newUser.City = result.addressComponents[i].longName;
                                      }
                                    }
                                  });
                                  Navigator.of(context).pop();
                                },
                                initialPosition: kInitialPosition,
                                useCurrentLocation: false,
                              );
                            }),
                          );
                        },
                        child: newUser.City == null && newUser.Country == null
                            ? RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  children: [
                                    TextSpan(text: 'Pick Location', style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyText2,
                                  children: [
                                    TextSpan(text: newUser.City + ", " + newUser.Country, style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                    WidgetSpan(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                        child: Icon(Icons.edit),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        shape:
                            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.amber)),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 0.9),
                        child: RaisedButton(
                          child: Text("next"),
                          color: Colors.white,
                          elevation: 10,
                          onPressed: () {
                            if (newUser.Country == null) {
                              Fluttertoast.showToast(
                                  msg: "We need a Location to show you events nearby",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.black);
                            } else {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => EleventhPage(newUser: newUser),
                                      transitionDuration: Duration(seconds: 0)));
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.white)),
                          padding: EdgeInsets.all(8.0),
                        ),
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
