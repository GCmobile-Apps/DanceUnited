import 'package:flutter/material.dart';
import 'package:united_app/fourth.dart';
import 'package:united_app/sixth.dart';

import 'model/user.dart';

class FifthPage extends StatefulWidget{
  final User newUser;
  FifthPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return FifthPageState(newUser);
  }
}

class FifthPageState extends State<FifthPage>{
  User newUser;
  FifthPageState(this.newUser);

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
                  const Color(0xff000000).withOpacity(0.2),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: height * 0.2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text("With Dance United you can find your next dance event", style: TextStyle(
                      color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                SizedBox(height: height * 0.05,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text("Where ever your passion leads you.", style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
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
                                      pageBuilder: (_, __, ___) => FourthPage(newUser: newUser),
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
                                      pageBuilder: (_, __, ___) => SixthPage(newUser: newUser),
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