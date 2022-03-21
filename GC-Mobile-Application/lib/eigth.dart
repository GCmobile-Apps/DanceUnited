import 'dart:async';

import 'package:flutter/material.dart';
import 'package:united_app/ninth.dart';
import 'package:united_app/seventh.dart';

import 'model/user.dart';

class EigthPage extends StatefulWidget{
  final User newUser;
  EigthPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return EigthPageState(newUser);
  }
}

class EigthPageState extends State<EigthPage>{
  User newUser;
  EigthPageState(this.newUser);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: <Widget>[
//          Container(
//            constraints: BoxConstraints.expand(),
//            decoration: BoxDecoration(
//                image: DecorationImage(
//                    image: AssetImage("assets/images/a_bg.jpeg"),
//                    fit: BoxFit.cover)
//            ),
//          ),
          Container(
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
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: height * 0.2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child:
                  Text("Get started", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                SizedBox(height: height * 0.05),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child:
                  Text("create my personal Dance United Event calendar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          RaisedButton(
                            child: Text("back"),
                            color: Colors.amber,
                            elevation: 10,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => SeventhPage(newUser: newUser),
                                      transitionDuration: Duration(seconds: 0)));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.amber)
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                          RaisedButton(
                            child: Text("Next"),
                            color: Colors.amber,
                            elevation: 10,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => NinthPage(newUser: newUser),
                                      transitionDuration: Duration(seconds: 0)));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.amber)
                            ),
                            padding: EdgeInsets.all(8.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


