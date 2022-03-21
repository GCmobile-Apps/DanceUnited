import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/explore.dart';
import 'package:united_app/first.dart';
import 'package:united_app/homescreen.dart';
import 'package:united_app/model/cantakepart.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/user.dart';
import 'package:united_app/professionalprofileviewer.dart';
import 'package:united_app/shared/SharedMethods.dart';
import 'package:united_app/specialevents.dart';
import 'package:united_app/userjourney.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'model/loading.dart';
import 'model/professionalUser.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:math';

class EventDetailed extends StatefulWidget {
  final User newUser;
  final Event event;
  EventDetailed({this.event, this.newUser});

  @override
  State<StatefulWidget> createState() {
    return EventDetailedState(event, newUser);
  }
}

class EventDetailedState extends State<EventDetailed> {
  User newUser;
  Event event;
  EventDetailedState(this.event, this.newUser);

  String Going_Not_Going = 'Going';
  Future future;
  Future similarEventsFuture;
  Future futureWhoIsGoing;
  bool isDisabled = false;
  final storage = new FlutterSecureStorage();
  ProfessionalUser professionalUser = new ProfessionalUser();
  bool loading=false;
  SharedMethods sh= new SharedMethods();


  EventUngoing(CanTakePart canTakePart) async{

    print("I am sending data to http");
    print(canTakePart);
    String token = await storage.read(key: "token");
    var result = await UnGoingEvent("cannottakepart", token, {"cannottakepart": canTakePart.toJson()});

    print("this is the result");
    print(result);
    print(result.data);
    print(result.data['status']);

    if (result.data['status'] == true) {
      setState(() => loading = false);
      Fluttertoast.showToast(
          msg: "Event removed to Dance United calendar",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      checkRegisteredEvent();
    } else if (result.data['status'] == false) {
      setState(() => loading = false);
      Fluttertoast.showToast(
          msg: "Ooops something is wrong,please try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
    }

  }

  registerUserEvent(CanTakePart canTakePart) async {
    String token = await storage.read(key: "token");
    var result = await registerEvent("cantakepart", token, {"cantakepart": canTakePart.toJson()});

    if (result.data['status'] == true) {
      setState(() => loading = false);
      Fluttertoast.showToast(
          msg: "Event added to Dance United calendar",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black
      );
    } else if (result.data['status'] == false) {
      setState(() => loading = false);
        Fluttertoast.showToast(
            msg: "Ooops something is wrong,please try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
    }
  }

  checkRegisteredEvent() async {
    String token = await storage.read(key: "token");
    var result = await checkEvent("checkRegisteredEvent", token, {"userID": newUser.UserID, "eventID": event.EventID});

    if (result.data['status'] == true) {
      if (result.data['statusCode'] == 200) {
        setState(() {
          isDisabled = true;
          Going_Not_Going = 'Ungoing';
        });
      }
    } else if (result.data['status'] == false) {
        Fluttertoast.showToast(
            msg: "Ooops something is wrong,please try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
    }
  }

  getEventPublisher() async {
    var result = await getEventPublisherFromServer("professionalUser", {"eventID": event.EventID});

    print("Publisher data");
    print(result.data[0]);

    professionalUser.UserID = result.data[0]['userID'];
    professionalUser.FirstName = result.data[0]['firstName'];
    professionalUser.LastName = result.data[0]['lastName'];
    professionalUser.username = result.data[0]['username'];
    professionalUser.password = result.data[0]['password'];
    professionalUser.StreetAddress = result.data[0]['streetAddress'];
    professionalUser.Country = result.data[0]['country'];
    professionalUser.ZipCode = result.data[0]['zipCode'];
    professionalUser.ContactNumber = result.data[0]['contactNumber'];
    professionalUser.Email = result.data[0]['email'];
    professionalUser.title = result.data[0]['title'];
    professionalUser.profilePictureLink = result.data[0]['profilePictureLink'];
    professionalUser.secondaryProfilePictureLink = result.data[0]['secondaryProfilePictureLink'];
    professionalUser.calenderViewLink = result.data[0]['calenderViewLink'];
    professionalUser.description = result.data[0]['description'];
    return professionalUser;
  }

  getWhoIsGoing() async {
    String token = await storage.read(key: "token");
    var result = await whoIsGoing("whoisgoing", token, {"eventID": event.EventID});

    List<String> profilePictureLinks = new List();

    if (result.data['status'] == true) {
      for (int i = 0; i < result.data['data'].length; i++) {
        profilePictureLinks.add(result.data['data'][i]['profilePictureLink']);
      }
      return profilePictureLinks;
    } else if (result.data['status'] == false) {
        Fluttertoast.showToast(
            msg: "Ooops something is wrong,please try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
      return null;
    }
  }

  Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    http.Response response = await http.get(imageUrl);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  @override
  void initState() {
    futureWhoIsGoing = getWhoIsGoing();
    checkRegisteredEvent();
    future = getEventPublisher();
    similarEventsFuture = sh.getEvents(context,event);
    print("Printing in event detailed");
    print(event.StartDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(event.Title,
                              style: TextStyle(fontSize: 20, color: Color(0xffFFA800), fontWeight: FontWeight.bold)),
                          Text(event.Type),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.access_time, size: 30),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  DateFormat('dd').format(new DateFormat("yyyy-MM-dd").parse(event.StartDate)) + " " +
                                  new DateFormat.MMMM().format(new DateFormat("yyyy-MM-dd").parse(event.StartDate)) + " " +
                                  DateFormat('yyyy').format(new DateFormat("yyyy-MM-dd").parse(event.StartDate))
                              ),
                              Text("${event.startTime} - ${event.endTime}"),
                              event.notRepeat == null ? Container() :
                              Text(event.StartDate)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.location_on, size: 30),
                          ),
                          Container(
                              width: 150,
                              child:
                                  new GestureDetector(
                                    onTap: (){
                                      Clipboard.setData(ClipboardData(text: event.Location));
                                      Fluttertoast.showToast(
                                          msg: "Copied to clipboard",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIos: 1
                                      );
                                    },
                                    child: Text(event.Location),
                                  )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: FutureBuilder(
                      future: futureWhoIsGoing,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                          return snapshot.data.length < 3 ? Container() : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text("Who is going"),
                              ),
                              Container(
                                width: width * 0.8,
                                height: height * 0.1,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(snapshot.data[index]),
                                      );
                                    }),
                              ),
                            ],
                          );
                        }
                        else {
                          if (snapshot.data == null) {
                            return Container();
                          } else {
                            return Align(child: Loading2());
                          }
                        };
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: height * 0.2,
                              width: width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: FadeInImage(
                                    image: NetworkImage(event.ImageUrl),
                                    placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            // Positioned(
                            //   top: height * 0.05,
                            //   left: height * 0.02,
                            //   child: Text(event.Title,
                            //       style:
                            //           TextStyle(fontSize: height * 0.05, color: Color(0xffFFA800), fontWeight: FontWeight.bold)),
                            // ),
                            // Positioned(
                            //   top: height * 0.16,
                            //   left: height * 0.03,
                            //   child: Text(event.Location,
                            //       style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xffa06b08))),
                            // ),
                            // Positioned(
                            //   top: height * 0.03,
                            //   left: height * 0.08,
                            //   child: Text(event.startTime, style: TextStyle(fontSize: 15, color: Color(0xffa06b08))),
                            // ),
                          ],
                        ),
                        SizedBox(height: 10)
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    children: <Widget>[
                      FutureBuilder(
                          future: future,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                              return Row(
                                children: [
                                  InkWell(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        image: DecorationImage(
                                          image: NetworkImage(snapshot.data.secondaryProfilePictureLink),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return ProfessionalProfileViewer(professionalUser: professionalUser);
                                      }));
                                      },
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        FlatButton(
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                return ProfessionalProfileViewer(professionalUser: professionalUser);
                                              }));
                                            },
                                            child:
                                                Text(professionalUser.title, style: TextStyle(fontWeight: FontWeight.bold))),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 15),
                                          child: Text("Event Organizer"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                            else {
                              return Align(child: Loading2());
                            }
                          }),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      Text("Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffFFA800)))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(event.Description),
                ),
                FutureBuilder(
                    future: similarEventsFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return snapshot.data.length == 0 ? Container() :  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Similar Events",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffFFA800))),
                              Container(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return EventDetailed(event: snapshot.data[index], newUser: newUser);
                                          }));
                                        },
                                        child: Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Align(
                                                      alignment: Alignment.centerLeft, // Align however you like (i.e .centerRight, centerLeft)
                                                      child:
                                                      Container(
                                                          width: 200,
                                                          child: Text(snapshot.data[index].Title, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)))
                                                  ),
                                                  Align(
                                                      alignment: Alignment.centerRight, // Align however you like (i.e .centerRight, centerLeft)
                                                      child:
                                                      Text(snapshot.data[index].startTime, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                  ),
                                                ]
                                            ),
                                            Stack(
                                              children: [
                                                Container(
                                                  height: height * 0.2,
                                                  width: width,
                                                  foregroundDecoration: BoxDecoration(
                                                    //color: Colors.black.withOpacity(0.4),
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    child: FadeInImage(
                                                        image: NetworkImage(snapshot.data[index].ImageUrl),
                                                        placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                // Positioned(
                                                //   top: height * 0.05,
                                                //   left: height * 0.02,
                                                //   child: Text(snapshot.data[index].Title,
                                                //       maxLines: 1,
                                                //       overflow: TextOverflow.ellipsis,
                                                //       style: TextStyle(
                                                //           fontSize: height * 0.05,
                                                //           color: Color(0xffFFA800),
                                                //           fontWeight: FontWeight.bold)),
                                                // ),
                                                // Positioned(
                                                //   top: height * 0.16,
                                                //   left: height * 0.03,
                                                //   child: Text(snapshot.data[index].Location,
                                                //       style: TextStyle(
                                                //           fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xffa06b08))),
                                                // ),
                                                // Positioned(
                                                //   top: height * 0.03,
                                                //   left: height * 0.08,
                                                //   child: Text(snapshot.data[index].startTime,
                                                //       style: TextStyle(fontSize: 15, color: Color(0xffa06b08))),
                                                // ),
                                              ],
                                            ),
                                            SizedBox(height: 10)
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        );
                      }
                       else {
                        return Align(child: Loading2());
                      }
                    }),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xfff3ad3d),
        selectedItemColor: Colors.black45,
        unselectedItemColor: Colors.black45,
        items: [
          BottomNavigationBarItem(
              icon: Container(height: 20, width: 20, child: new Image.asset("assets/icons/home.png")), label: "Home"),
          BottomNavigationBarItem(
              icon: Container(height: 20, width: 20, child: new Image.asset("assets/icons/globe.png")), label: "Explore"),
          BottomNavigationBarItem(
              icon: Container(height: 20, width: 20, child: new Image.asset("assets/icons/icon.png")), label: "Journey"),
          BottomNavigationBarItem(
              icon: Container(height: 20, width: 20, child: new Image.asset("assets/icons/gift.png")), label: "Specials"),
        ],
        onTap: (index) {
          setState(() {
            switch (index) {
              case 0:
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return HomeScreen(newUser: newUser);
                  }));
                  break;
                }
              case 1:
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return Explore(newUser: newUser);
                  }));
                  break;
                }
              case 2:
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return UserJourney(newUser: newUser);
                  }));
                  break;
                }
              case 3:
                {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return SpecialEvents(newUser: newUser);
                  }));
                  break;
                }
            }
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 45),
        child: Wrap(children: [
          Container(
            color: Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  child:loading
                      ?Loading2()
                      :Text(Going_Not_Going),
                  onPressed: isDisabled
                      ? (){

                    Going_Not_Going = 'Going';
                    CanTakePart canTakePart = new CanTakePart();
                    canTakePart.EventID = event.EventID;
                    canTakePart.UserID = newUser.UserID;
                    setState(() => loading = true);
                    EventUngoing(canTakePart);

                  }
                  : () {
                      Going_Not_Going = 'Ungoing';
                      CanTakePart canTakePart = new CanTakePart();
                      canTakePart.EventID = event.EventID;
                      canTakePart.UserID = newUser.UserID;
                      setState(() => loading = true);
                      registerUserEvent(canTakePart);
                        },
                  color: Color(0xffFFA800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xffFFA800))),
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
                FlatButton(
                  child: Text("Invite"),
                  onPressed: () {
//                    var  response = urlToFile(event.ImageUrl);
//                    File file;
//                    response.then((result) {
//                      file = result;
//                      String eventData = "Event Name: " + event.Title + "\n" + "Event Location: " + event.Location + "\n"
//                          + "Event Start Date: " + DateFormat('yyyy-MM-dd').format(new DateFormat("yyyy-MM-dd").parse(event.StartDate));
//                      Share.shareFiles([file.path], text: eventData);
//                    });

                    String eventData = "Check out " + event.Title + "\n"
                        + "Read more in the Dance United App" + "\n"
                        + "www.danceunited.se";

                    final RenderBox box = context.findRenderObject();

                    Share.share(eventData,
                      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);

                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.black)),
                  padding: EdgeInsets.symmetric(horizontal: 50),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
