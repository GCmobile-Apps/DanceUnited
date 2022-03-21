import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:united_app/eventdetailed.dart';
import 'package:united_app/first.dart';
import 'package:united_app/model/promo.dart';
import 'package:united_app/specialevents.dart';
import 'package:united_app/userjourney.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ServerRequests/http.dart';
import 'model/event.dart';
import 'model/loading.dart';
import 'model/user.dart';
import 'explore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  final User newUser;
  HomeScreen({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState(newUser);
  }
}

class HomeScreenState extends State<HomeScreen> {
  User newUser;
  HomeScreenState(this.newUser);

  Future future;
  Future userEventsFuture;
  int _currentIndex = 0;
  bool checkBoxValue = false;
  final storage = new FlutterSecureStorage();

  String greatest;
  String middle;
  String smallest;

  List<Event> dbEvents = new List();

  getUserSpecificEvents() async {
    String token = await storage.read(key: "token");
    var result = await getUserEvents("userEvents", token, {"userID": newUser.UserID});

    DateTime currentDate = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day);
    if (result.data['status'] == true) {
      List<Event> dbEvents = new List();
      if (result.data != null) {
        for (int i = 0; i < result.data['data'].length; i++) {
          DateTime eventStartDate = new DateFormat("yyyy-MM-dd").parse(result.data['data'][i]['StartDate']);
          if (eventStartDate.isAfter(currentDate) || eventStartDate == currentDate) {
            Event event = new Event();
            event.EventID = result.data['data'][i]['EventID'];
            event.Title = result.data['data'][i]['Title'];
            event.Description = result.data['data'][i]['Description'];
            event.StartDate = result.data['data'][i]['StartDate'];
            event.EndDate = result.data['data'][i]['EndDate'];
            event.Location = result.data['data'][i]['Location'];
            event.Prize = result.data['data'][i]['Prize'];
            event.Type = result.data['data'][i]['Type'];
            event.ImageUrl = result.data['data'][i]['ImageUrl'];
            event.Tags = result.data['data'][i]['Tags'];
            event.notRepeat = result.data['data'][i]['notRepeat'];
            event.startTime = result.data['data'][i]['startTime'];
            event.endTime = result.data['data'][i]['endTime'];
            event.viewCounter = result.data['data'][i]['viewCounter'];
            dbEvents.add(event);
          }
        }
      }

      if (dbEvents.length != 0) {
        return dbEvents;
      } else if (dbEvents.length == 0) {
        return null;
      }
    } else if (result.data['status'] == false) {
      Fluttertoast.showToast(
          msg: "Ooops something is wrong,please try again later", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
      return null;
    }
  }

  getMainScreenPromo() async {
    // ignore: non_constant_identifier_names
    var UserMetaresult = await getuserMeta(
        "getUsersMeta", {'UserID': newUser.UserID});

    var MainScreenPromotions = null;
    var FullScreenPromotions = null;
    List MainScreenPromotionsArray = new List();
    List FullScreenPromotionsArray = new List();


    if (UserMetaresult.data['data'] != null) {
      print("data on the backend");

      UserMetaresult.data['data'][0]['MainScreenPromotions'] =
          UserMetaresult.data['data'][0]['MainScreenPromotions'].replaceAll(
              RegExp("'"), ''); // h*llo hello
      UserMetaresult.data['data'][0]['FullScreenPromotions'] =
          UserMetaresult.data['data'][0]['FullScreenPromotions'].replaceAll(
              RegExp("'"), ''); // h*llo hello

      MainScreenPromotions =
      UserMetaresult.data['data'][0]['MainScreenPromotions'];
      final split = MainScreenPromotions.split(',');
      MainScreenPromotionsArray = [
        for (int i = 0; i < split.length; i++)
          split[i]
      ];

      FullScreenPromotions =
      UserMetaresult.data['data'][0]['FullScreenPromotions'];
      final Fullsplit = FullScreenPromotions.split(',');
      FullScreenPromotionsArray = [
        for (int i = 0; i < Fullsplit.length; i++)
          Fullsplit[i]
      ];
    }


    String token = await storage.read(key: "token");
    var result = await getMainScreenPromoEventsFromServer(
        "mainScreenPromo", token);
    var resultMainScreenPromos = await getMainScreenPromosFromServer(
        "getMainScreenPromo", token);


    List mainScreenPromos = new List();
    List mainScreenPromoEvents = new List();

    if (resultMainScreenPromos.data['status'] == true) {
      for (int i = 0; i < resultMainScreenPromos.data['data'].length; i++) {
        Promo promo = new Promo();
        promo.promoID = resultMainScreenPromos.data['data'][i]['promoID'];
        promo.EventID = resultMainScreenPromos.data['data'][i]['eventID'];
        promo.offerTitle = resultMainScreenPromos.data['data'][i]['offerTitle'];
        promo.promoImageUrl =
        resultMainScreenPromos.data['data'][i]['promoImageUrl'];
        promo.viewCounter =
        resultMainScreenPromos.data['data'][i]['viewCounter'];
        promo.promoAddress =
        resultMainScreenPromos.data['data'][i]['promoCity'];
        promo.promoType = resultMainScreenPromos.data['data'][i]['promoType'];
        promo.viewCounter =
        resultMainScreenPromos.data['data'][i]['viewCounter'];

        if (promo.promoAddress != null && promo.promoAddress.contains(",")) {
          List addressParts = promo.promoAddress.split(',');
          promo.promoCountry = addressParts[0];
          promo.promoCity = addressParts[1];
        }
        promo.destinationLink =
        resultMainScreenPromos.data['data'][i]['destinationLink'];
        mainScreenPromos.add(promo);
      }

      if (result.data['status'] == true) {
        for (int i = 0; i < result.data['data'].length; i++) {
          Event event = new Event();
          event.EventID = result.data['data'][i]['EventID'];
          event.Title = result.data['data'][i]['Title'];
          event.Description = result.data['data'][i]['Description'];
          event.StartDate = result.data['data'][i]['StartDate'];
          event.EndDate = result.data['data'][i]['EndDate'];
          event.Location = result.data['data'][i]['Location'];
          event.Prize = result.data['data'][i]['Prize'];
          event.Type = result.data['data'][i]['Type'];
          event.ImageUrl = result.data['data'][i]['ImageUrl'];
          event.Tags = result.data['data'][i]['Tags'];
          event.notRepeat = result.data['data'][i]['notRepeat'];
          event.startTime = result.data['data'][i]['startTime'];
          event.endTime = result.data['data'][i]['endTime'];
          event.viewCounter = result.data['data'][i]['viewCounter'];
          mainScreenPromoEvents.add(event);
        }
      }



      for (int l = 0; l<MainScreenPromotionsArray.length; l++){
        MainScreenPromotionsArray[l] = MainScreenPromotionsArray[l].replaceAll(new RegExp(r"\s+"), "");
      }



      List WithoutLocationBasedmainScreenPromos = new List();
      List LocationMatchedmainScreenPromos = new List();
      List LocationNotMatchedmainScreenPromos = new List();

      List WithoutLocationBasedmainScreenPromosEvents = new List();
      List LocationMatchedmainScreenPromosEvents = new List();
      List LocationNotMatchedmainScreenPromosEvents = new List();


      for (int T = 0; T<mainScreenPromos.length; T++){
        if (mainScreenPromos[T].promoAddress != null) {

          if (mainScreenPromos[T].promoAddress == newUser.Country
          || mainScreenPromos[T].promoAddress == newUser.City
          ||  (mainScreenPromos[T].promoCity == newUser.City ||  mainScreenPromos[T].promoCountry == newUser.Country)
          ){
            if (mainScreenPromos[T].promoType == 'Internal Promo'){
              for (int k=0; k<mainScreenPromoEvents.length; k++){
                if (mainScreenPromoEvents[k].EventID == mainScreenPromos[T].EventID){
                  LocationMatchedmainScreenPromosEvents.add(mainScreenPromoEvents[k]);
                  LocationMatchedmainScreenPromos.add(mainScreenPromos[T]);
                }
              }
            }
            if (mainScreenPromos[T].promoType == 'External Promo'){
              LocationMatchedmainScreenPromos.add(mainScreenPromos[T]);
            }

          }
          else {
            if (mainScreenPromos[T].promoType == 'Internal Promo'){
              for (int k=0; k<mainScreenPromoEvents.length; k++){
                if (mainScreenPromoEvents[k].EventID == mainScreenPromos[T].EventID){
                  LocationNotMatchedmainScreenPromosEvents.add(mainScreenPromoEvents[k]);
                  LocationNotMatchedmainScreenPromos.add(mainScreenPromos[T]);
                }
              }
            }
            if (mainScreenPromos[T].promoType == 'External Promo'){
              LocationNotMatchedmainScreenPromos.add(mainScreenPromos[T]);
            }
          }
        }
        else if (mainScreenPromos[T].promoAddress == null) {
          if (mainScreenPromos[T].promoType == 'Internal Promo'){
            for (int k=0; k<mainScreenPromoEvents.length; k++){
              if (mainScreenPromoEvents[k].EventID == mainScreenPromos[T].EventID){
                WithoutLocationBasedmainScreenPromosEvents.add(mainScreenPromoEvents[k]);
                WithoutLocationBasedmainScreenPromos.add(mainScreenPromos[T]);

              }
            }
          }
          if (mainScreenPromos[T].promoType == 'External Promo'){
            WithoutLocationBasedmainScreenPromos.add(mainScreenPromos[T]);
          }
        }
      }

      print("User's Location");
      print(newUser.City + "  "+ newUser.Country);

      print("Here's the three different type of promos");
      print(WithoutLocationBasedmainScreenPromos.length);
      print(LocationNotMatchedmainScreenPromos.length);
      print(LocationMatchedmainScreenPromos.length);

      print("Here's the three different type of Events");
      print(WithoutLocationBasedmainScreenPromosEvents.length);
      print(LocationNotMatchedmainScreenPromosEvents.length);
      print(LocationMatchedmainScreenPromosEvents.length);

      Random random = new Random();

      if (LocationMatchedmainScreenPromos.length == 0){
        if (LocationNotMatchedmainScreenPromos.length ==0){

          int randomNumber = random.nextInt(WithoutLocationBasedmainScreenPromos.length);

          if (WithoutLocationBasedmainScreenPromos[randomNumber].promoType == 'External Promo') {
            return WithoutLocationBasedmainScreenPromos[randomNumber];
          }
          if (WithoutLocationBasedmainScreenPromos[randomNumber].promoType == 'Internal Promo') {
            return WithoutLocationBasedmainScreenPromosEvents[new Random().nextInt(WithoutLocationBasedmainScreenPromosEvents.length)];
          }
        }
      }

      if (LocationMatchedmainScreenPromos.length == 0 ){
        if (LocationNotMatchedmainScreenPromos.length !=0) {

          int randomNumber = random.nextInt(LocationNotMatchedmainScreenPromos.length);

          if (LocationNotMatchedmainScreenPromos[randomNumber].promoType == 'External Promo') {
            return LocationNotMatchedmainScreenPromos[randomNumber];
          }
          if (LocationNotMatchedmainScreenPromos[randomNumber].promoType == 'Internal Promo') {
            return LocationNotMatchedmainScreenPromosEvents[new Random().nextInt(LocationNotMatchedmainScreenPromosEvents.length)];

          }

        }
      }


      if (LocationMatchedmainScreenPromos.length != 0 ){
        int randomNumber = random.nextInt(LocationMatchedmainScreenPromos.length);

        print("This is the random number");
        print(randomNumber);
        if (LocationMatchedmainScreenPromos[randomNumber].promoType == 'External Promo') {
          return LocationMatchedmainScreenPromos[randomNumber];
        }
        if (LocationMatchedmainScreenPromos[randomNumber].promoType == 'Internal Promo') {

          return LocationMatchedmainScreenPromosEvents[new Random().nextInt(LocationMatchedmainScreenPromosEvents.length)];
        }

      }


    }
  }

  saveViewCounterInDb(eventID, viewCounter) async {
    String token = await storage.read(key: "token");
    var response = await saveCounter("updateCounterMainScreenPromos", token, {"eventID": eventID, "counter": viewCounter});
  }

  saveViewCounterInDbExternalPromos(promoID, viewCounter) async {
    String token = await storage.read(key: "token");
    var response =
        await saveCounter("updateCounterMainScreenExternalPromos", token, {"promoID": promoID, "counter": viewCounter});
  }

  @override
  void initState() {
    future = getMainScreenPromo();
    userEventsFuture = getUserSpecificEvents();
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
            padding: const EdgeInsets.only(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FutureBuilder(
                    future: future,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        print("\n\nEvent Id = ");
                        print(snapshot.data.EventID);

                        print("Event View Counter = ");
                        print(snapshot.data.viewCounter);


                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: GestureDetector(
                            onTap: () {
                              if (snapshot.data.EventID != null) {
                                snapshot.data.viewCounter++;
                                saveViewCounterInDb(snapshot.data.EventID, snapshot.data.viewCounter);
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return EventDetailed(event: snapshot.data, newUser: newUser);
                                }));
                              } else {
                                snapshot.data.viewCounter++;
                                saveViewCounterInDbExternalPromos(snapshot.data.promoID, snapshot.data.viewCounter);
                                launch(snapshot.data.destinationLink);
                              }
                            },
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: height * 0.3,
                                      width: width,
                                      child: FadeInImage(
                                        image: NetworkImage(
                                            snapshot.data.EventID == null ?
                                            snapshot.data.promoImageUrl :
                                            snapshot.data.ImageUrl),
                                        placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10)
                              ],
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Align(child: Loading2());
                      } else if (snapshot.data == null) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                  width: width,
                                  height: width / 1.5,
                                  child: Image(image: AssetImage('assets/images/newsPlaceHolder.png'))),
                            ],
                          ),
                        );
                      } else {
                        return Align(child: Loading2());
                      }
                    }),
                SizedBox(height: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Your Upcoming events", style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold)),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(newUser.profilePictureLink),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: userEventsFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
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
                        );
                      } else if (snapshot.connectionState == ConnectionState.waiting) {
                        return Align(child: Loading2());
                      } else if (snapshot.data == null) {
                        return Padding(
                            padding: const EdgeInsets.all(20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (_, __, ___) => Explore(newUser: newUser),
                                        transitionDuration: Duration(seconds: 0)));
                              },
                              child: Container(
                                height: 140,
                                width: width*0.95,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/images/startexploring.png"), fit: BoxFit.cover)),
                              ),
                            ));
                      } else {
                        return Align(child: Loading2());
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black45,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xfff3ad3d),
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
            _currentIndex = index;

            switch (_currentIndex) {
              case 0:
                {
                  break;
                }
              case 1:
                {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => Explore(newUser: newUser), transitionDuration: Duration(seconds: 0)));
                  break;
                }
              case 2:
                {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => UserJourney(newUser: newUser), transitionDuration: Duration(seconds: 0)));
                  break;
                }
              case 3:
                {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => SpecialEvents(newUser: newUser),
                          transitionDuration: Duration(seconds: 0)));
                  break;
                }
            }
          });
        },
      ),
    );
  }
}
