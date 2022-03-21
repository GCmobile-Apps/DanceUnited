import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:united_app/first.dart';
import 'package:united_app/model/user.dart';
import 'package:united_app/professional/professional.dart';
import 'package:united_app/third.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ServerRequests/http.dart';
import 'model/loading.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SecondPageState();
  }
}

class SecondPageState extends State<SecondPage> {
  User newUser = new User();
  Future linksFuture;

  getLinks() async {
    var result = await getLinksFromServer("findAllLinks");
    return result.data['data'];
  }

  @override
  void initState() {
    //linksFuture = getLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100),
              FlatButton(
                child: Text("Dancer", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900)),
                color: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ThirdPage(newUser: newUser), transitionDuration: Duration(seconds: 0)));
                },
                padding: EdgeInsets.all(8.0),
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Text("Everyone who loves dancing", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900)),
                ],
              ),
              SizedBox(height: 100),
              FlatButton(
                child: Text("Professional", style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w900)),
                color: Colors.transparent,
                onPressed: () {
                  Navigator.push(context,
                      PageRouteBuilder(pageBuilder: (_, __, ___) => Professional(), transitionDuration: Duration(seconds: 0)));
                },
                padding: EdgeInsets.all(8.0),
              ),
              Row(
                children: <Widget>[
                  SizedBox(width: 10),
                  Expanded(child: Text("Artists, Dance Schools, Event Organisers", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900))),
                ],
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Container(
                              width: width * 0.7,
                              child: RichText(
                                  text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(text: "read more ", style: TextStyle(
                                            decoration: TextDecoration.underline, color: Colors.white),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => launch('')),
                                        TextSpan(text: "on which account to choose if you are unsure")
                                      ]
                                  )),
                            ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomLeft,
                  child: RaisedButton(
                    child: Text("back"),
                    color: Colors.amber,
                    elevation: 10,
                    onPressed: () {
                      Navigator.push(context,
                          PageRouteBuilder(pageBuilder: (_, __, ___) => MainPage(), transitionDuration: Duration(seconds: 0)));
                    },
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                    padding: EdgeInsets.all(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
