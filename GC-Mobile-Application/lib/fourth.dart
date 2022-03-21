import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:united_app/model/user.dart';
import 'package:united_app/ninth.dart';

class FourthPage extends StatefulWidget{
  User newUser;
  FourthPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return FourthPageState(newUser);
  }
}

class FourthPageState extends State<FourthPage>{
  User newUser;
  FourthPageState(this.newUser);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(3),
                        child: Container(
                          height: 7,
                          width: 7,
                          decoration: BoxDecoration(
                              color: Colors.red,
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
                              color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Text("Let's create your profile",
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 40),
                  RaisedButton(
                    child: Text("follow", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold)),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => NinthPage(newUser: newUser),
                              transitionDuration: Duration(seconds: 0)));
                    },
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.amber)),
                  ),
                  SizedBox(height: 40),
                  RaisedButton(
                    child: Text("lead", style: TextStyle(fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => NinthPage(newUser: newUser),
                              transitionDuration: Duration(seconds: 0)));
                    },
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.amber)),
                  ),
                  SizedBox(height: 40),
                  RaisedButton(
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyText2,
                        children: [
                          TextSpan(text: "universal\n", style: TextStyle(fontSize: 25,
                              fontWeight: FontWeight.bold)),
                          TextSpan(text: "both follow and lead", style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => NinthPage(newUser: newUser),
                              transitionDuration: Duration(seconds: 0)));
                    },
                    padding: EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50), side: BorderSide(color: Colors.amber)),
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