import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/professional2.dart';
import 'package:united_app/second.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../first.dart';

class Professional extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfessionalState();
  }
}

class ProfessionalState extends State<Professional> {
  TextEditingController backStageCodeController = new TextEditingController();
  final storage = new FlutterSecureStorage();
  bool backStageLogin = false;
  bool loading =false;

  getProfessionalUser() async {
    setState(() {
      backStageLogin = true;
    });
    var result = await getProfessionalUserFromServer("getProfessionalUser", backStageCodeController.text);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('backStageCode', backStageCodeController.text);
    prefs.setString('professionalToken', result.data['token']);

    if (result.data['status'] == true) {
      await storage.write(key: "professionalToken", value: result.data['token']);
      await storage.write(key: "preference1", value:'Kizomba');
      await storage.write(key: "preference2", value: 'Salsa');
      await storage.write(key: "preference3", value: 'Bachata');
      ProfessionalUser proUser = new ProfessionalUser();
      proUser.UserID = result.data['data'][0]['userID'];
      proUser.FirstName = result.data['data'][0]['firstName'];
      proUser.LastName = result.data['data'][0]['lastName'];
      proUser.title = result.data['data'][0]['title'];
      proUser.username = result.data['data'][0]['username'];
      proUser.password = result.data['data'][0]['password'];
      proUser.Email = result.data['data'][0]['email'];
      proUser.City = result.data['data'][0]['city'];
      proUser.StreetAddress = result.data['data'][0]['streetAddress'];
      proUser.Country = result.data['data'][0]['country'];
      proUser.profilePictureLink = result.data['data'][0]['profilePictureLink'];
      proUser.secondaryProfilePictureLink = result.data['data'][0]['secondaryProfilePictureLink'];
      proUser.calenderViewLink = result.data['data'][0]['calenderViewLink'];
      proUser.backStageCode = result.data['data'][0]['backStageCode'];
      proUser.description = result.data['data'][0]['description'];
      print(proUser.toString());
      setState(() => loading = false);
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => Professional2(proUser: proUser)), (route) => false);
    }
    else if(result.data['status'] == false){
      setState(() {
        backStageLogin = false;
      });
      setState(() => loading = false);
      Fluttertoast.showToast(
          msg: "Wrong backstage code",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading ? Loading() : Scaffold(
      body: Stack(
        children: [
          Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage("assets/images/BackGroundSignUp.png"), fit: BoxFit.cover)),
        ),
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Color(0xff000000).withOpacity(0.4),
            ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 80),
                Container(
                  width:width,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Dance United",
                        overflow: TextOverflow.visible,
                        style: TextStyle(backgroundColor: Colors.yellow, color: Colors.black, fontSize: 13, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center),
                  ),
                ),
                Container(
                  width:width,
                  child: Text("Welcome Backstage",
                      overflow: TextOverflow.visible,
                      style: TextStyle(color: Colors.white, fontSize: height * 0.065, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center),
                ),
                Container(
                  width:width,
                  child: Text("For artists, dance teachers and organisers",
                      overflow: TextOverflow.visible,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),
                      textAlign: TextAlign.center),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text("enter entry code",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),
                ),
                backStageLogin ? Center(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Loading2(),
                )) :
                SizedBox(height: 20),
                Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,

                        border: Border.all(color: Color(0xffFFBC00), width: 5)
                    ),
                      child: TextField(
                        cursorColor: Colors.white,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: ('Backstage Pro'),
                          border: InputBorder.none,
                        ),
                          controller: backStageCodeController,
                      ),
                  ),
                ),

                Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          child: Text("Get Code", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          color: Colors.transparent,
                          elevation: 10,
                          onPressed: () {
                            launch('https://danceunited.se/');
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.transparent)),
                          padding: EdgeInsets.all(8.0),
                        ),
                        RaisedButton(
                          child: Text("enter"),
                          color: Colors.amber,
                          elevation: 10,
                          onPressed: () {
                            setState(() => loading = true);
                            getProfessionalUser();
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
      ]
        ),
      );
  }
}
