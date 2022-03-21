import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:united_app/Custom%20Classes/Gradient_Border.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/eventname.dart';
import 'package:united_app/professional/neweventdetails.dart';
import 'package:async/async.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:united_app/shared/SharedMethods.dart';

class ProfessionalPreferences extends StatefulWidget {
  final ProfessionalUser proUser;
  final Event newEvent;
  ProfessionalPreferences({this.proUser, this.newEvent});

  @override
  State<StatefulWidget> createState() {
    return ProfessionalPreferencesState(proUser, newEvent);
  }
}

class ProfessionalPreferencesState extends State<ProfessionalPreferences> {
  ProfessionalUser proUser;
  Event newEvent;
  final storage = new FlutterSecureStorage();
  ProfessionalPreferencesState(this.proUser, this.newEvent);

  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<Preferences> preferencesList = new List();
  String color;
  SharedMethods sh= new SharedMethods();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xffffffff),
              const Color(0xffffffff),
              const Color(0xffffffff),
              const Color(0xffffffff),
              const Color(0xffffffff),
            ], // red to yellow
          ),
        ),
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text("Event main style", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                FutureBuilder(
                    future: sh.getPreferences(preferencesList),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.length,
                            gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(30),
                                child: GestureDetector(
                                  onTap: (){
                                    newEvent.Tags = snapshot.data[index].preferenceName;
                                    setState(() {
                                      color = snapshot.data[index].preferenceName;
                                    });
                                  },
                                  child: UnicornOutlineButton(
                                    strokeWidth: 2,
                                    radius: 100,
                                    gradient: snapshot.data[index].preferenceName == color ? LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]) :
                                    LinearGradient(
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.6),
                                        colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                    ),
                                    child: Text(snapshot.data[index].preferenceName),
                                  ),
                                  // child: Card(
                                  //   color: snapshot.data[index].preferenceName == color ? Color(0xfffdb602) : Color(0xfff1ead7),
                                  //   elevation: 10,
                                  //   child: Center(
                                  //       child: Text(
                                  //     snapshot.data[index].preferenceName,
                                  //     style: TextStyle(fontWeight: FontWeight.bold),
                                  //     textAlign: TextAlign.center,
                                  //   )),
                                  //   shape: RoundedRectangleBorder(
                                  //     side: BorderSide(color: Colors.white70, width: 1),
                                  //     borderRadius: BorderRadius.circular(100),
                                  //   ),
                                  // ),
                                ),
                              );
                            });
                      }
                      else {
                        return Align(child: Loading2());
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RaisedButton(
                child: Text("back"),
                color: Colors.amber,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                      EventName(newEvent: newEvent, proUser: proUser)), (route) => false);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                padding: EdgeInsets.all(8.0),
              ),
            ),
            RaisedButton(
              child: Text("Next"),
              color: Colors.amber,
              onPressed: () {
                if(newEvent.Tags != null) {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                      NewEventDetails(newEvent: newEvent, proUser: proUser)), (route) => false);
                }else{
                  Fluttertoast.showToast(
                      msg: "Select one option",
                      toastLength: Toast.LENGTH_SHORT,
                      backgroundColor: Colors.black);
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }
}
