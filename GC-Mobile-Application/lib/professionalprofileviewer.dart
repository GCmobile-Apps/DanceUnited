import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/professionaleventdetailed.dart';
import 'package:united_app/shared/SharedMethods.dart';

import 'ServerRequests/http.dart';
import 'model/event.dart';
import 'model/loading.dart';

class ProfessionalProfileViewer extends StatefulWidget {
  final ProfessionalUser professionalUser;
  ProfessionalProfileViewer({this.professionalUser});

  @override
  State<StatefulWidget> createState() {
    return ProfessionalProfileViewerState(professionalUser);
  }
}

class ProfessionalProfileViewerState extends State<ProfessionalProfileViewer> {
  ProfessionalUser professionalUser;
  List<String> secondaryPreferencesList = new List();
  List<Preferences> preferencesList = new List();
  final storage = new FlutterSecureStorage();
  Future future;
  List<Event> dbEvents = new List();
  SharedMethods sh = new SharedMethods();
  bool mainOptions = true;
  bool upcomingEvents = true;
  bool about = false;


  ProfessionalProfileViewerState(this.professionalUser);

  @override
  void initState() {
    future = getUserSpecificEvents(dbEvents);
    print("These are my events");
    print(dbEvents);
    super.initState();
  }

  getUserSpecificEvents(dbEvents) async {
    String token = await storage.read(key: "token");
    var result = await getProEventsFromServer("proevents", token, {"userID": professionalUser.UserID});
    DateTime currentDate = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day);

//    if (result.data['status'] == true) {
    List<Event> dbEvents = new List();
    if (result.data != null) {
      for (int i = 0; i < result.data.length; i++) {
        DateTime eventStartDate = new DateFormat("yyyy-MM-dd").parse(result.data[i]['StartDate']);
        if (eventStartDate.isAfter(currentDate)) {
          Event event = new Event();
          event.EventID = result.data[i]['EventID'];
          event.Title = result.data[i]['Title'];
          event.Description = result.data[i]['Description'];
          event.StartDate = result.data[i]['StartDate'];
          event.EndDate = result.data[i]['EndDate'];
          event.Location = result.data[i]['Location'];
          event.Prize = result.data[i]['Prize'];
          event.Type = result.data[i]['Type'];
          event.ImageUrl = result.data[i]['ImageUrl'];
          event.Tags = result.data[i]['Tags'];
          event.notRepeat = result.data[i]['notRepeat'];
          event.startTime = result.data[i]['startTime'];
          event.endTime = result.data[i]['endTime'];
          event.viewCounter = result.data[i]['viewCounter'];
          print("This is the event adding");
          print(event.EventID + " " + event.Title);
          dbEvents.add(event);
        }
      }
//      }

      if(dbEvents.length != 0){
        return dbEvents;
      }else if(dbEvents.length == 0){
        return null;
      }
    }
    else if (result.data['status'] == false) {
      Fluttertoast.showToast(
          msg: "Ooops something is wrong,please try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
      child: Column(children: <Widget>[
        SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 25, 20),
          child: Stack(
            children: [
              Center(
                  child: Stack(children: [
                CircleAvatar(radius: 120, backgroundImage: NetworkImage(professionalUser.profilePictureLink)),
                    Container(
                      height: 240,
                      width: 240,
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
                  ])),
                  Padding(
                      padding: const EdgeInsets.only(top: 190),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Stack(
                              overflow: Overflow.visible,
                              children: [
                                Container(
                                    height: height * 0.15,
                                    width: height * 0.15,
                                    child: Image.network(professionalUser.secondaryProfilePictureLink)),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            Center(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(professionalUser.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Event Organizer'),
                  ],
                ),
                professionalUser.calenderViewLink != null
                    ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(professionalUser.calenderViewLink),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ) : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            mainOptions = true;
                            upcomingEvents = true;
                            about = false;
                          });
                        },
                        child: Text("Upcoming Events",
                            style: TextStyle(fontSize: 20, color: mainOptions ? Color(0xffFFA901) : Colors.black))),
                    FlatButton(
                        onPressed: () {
                          setState(() {
                            mainOptions = false;
                            upcomingEvents = false;
                            about = true;
                          });
                        },
                        child: Text("About",
                            style: TextStyle(fontSize: 20, color: !mainOptions ? Color(0xffFFA901) : Colors.black)))
                  ],
                ),
                mainOptions ?
                FutureBuilder(
                    future: future,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return ProfessionalEventDetailed(
                                            event: snapshot.data[index], proUser: professionalUser);
                                      }));
                                    },
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              foregroundDecoration: BoxDecoration(
                                                // color: Colors.black.withOpacity(0.4),
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              height: height * 0.2,
                                              width: width,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                                child: FadeInImage(
                                                    image: NetworkImage(snapshot.data[index].ImageUrl),
                                                    placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );

                      } else if (snapshot.data == null) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 140,
                              width: 500,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/soempty.png"), fit: BoxFit.cover)),
                            ));
                      } else {
                        return Align(child: Loading2());
                      }
                    })
                    : Container(),
                SizedBox(height: 10),
                about ?
                Column(
                  children:<Widget> [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text("Location", style: TextStyle(color: Color(0xffFFA800), fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          child: Text(professionalUser.StreetAddress),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Divider(
                        color: Color(0xfff4aa3c),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Description",
                            style: TextStyle(color: Color(0xffFFA800), fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 240,
                          width: 350,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              professionalUser.description,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]
                ):Container(),
              ],
            ),

            ),
          ]
          )
      ),
      )
    );
  }
}
