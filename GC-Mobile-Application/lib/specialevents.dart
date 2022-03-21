import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:united_app/first.dart';
import 'package:united_app/homescreen.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/shared/SharedMethods.dart';
import 'package:united_app/userjourney.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'eventdetailed.dart';
import 'explore.dart';
import 'model/loading.dart';
import 'model/promo.dart';
import 'model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecialEvents extends StatefulWidget {
  final User newUser;
  SpecialEvents({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return SpecialEventsState(newUser);
  }
}

class SpecialEventsState extends State<SpecialEvents> {
  User newUser;
  SpecialEventsState(this.newUser);

  int _currentIndex = 3;
  Future specialEventsFuture;
  Future externalPromosFuture;
  final storage = new FlutterSecureStorage();
  var internalPromos = new List();

  getSpecialEvents() async {
    String token = await storage.read(key: "token");

    var result = await getSpecialEventsFromServer("specialEvents", token);
    var promoResult = await getPromosFromServer("getSpecialScreenPromo", token);

    if (result.data['status'] == true) {
      var events = new List();

      for (int i = 0; i < promoResult.data['data'].length; i++) {
        Promo promo = new Promo();
        promo.promoID = promoResult.data['data'][i]['promoID'];
        promo.EventID = promoResult.data['data'][i]['eventID'];
        promo.viewCounter = promoResult.data['data'][i]['viewCounter'];

        promo.promoAddress = promoResult.data['data'][i]['promoCity'];

        if(promo.promoAddress != null && promo.promoAddress.contains(",")){
          List addressParts = promo.promoAddress.split(',');
          promo.promoCountry = addressParts[0];
          promo.promoCity = addressParts[1];
        }
        internalPromos.add(promo);
      }

      for (int i = 0; i < result.data['data'].length; i++) {
        for(int j=0; j<internalPromos.length; j++){
          if(result.data['data'][i]['EventID'] == internalPromos[j].EventID &&
              internalPromos[j].promoAddress == null){

            Event event= new Event();
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
            for (int j = 0; j < internalPromos.length; j++) {
              if (internalPromos[j].EventID == event.EventID) {
                event.viewCounter = internalPromos[j].viewCounter;
              }
            }
            events.add(event);

          }else if(result.data['data'][i]['EventID'] == internalPromos[j].EventID &&  internalPromos[j].promoAddress != null ){


            Event event= new Event();
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

            for (int j = 0; j < internalPromos.length; j++) {
              if (internalPromos[j].EventID == event.EventID) {
                event.viewCounter = internalPromos[j].viewCounter;
              }
            }

            if (internalPromos[j].promoAddress == newUser.City){
              events.add(event);
            }
            else if (internalPromos[j].promoAddress == newUser.Country){
              events.add(event);
            }
            else if (internalPromos[j].promoCity ==  newUser.City && internalPromos[j].promoCountry == newUser.Country){
              events.add(event);
            }

          }
        }
      }
      events.sort((a,b) {
        return b.StartDate.compareTo(a.StartDate);
      });

      return events;
    }
    else if (result.data['status'] == false) {
      Fluttertoast.showToast(
          msg: "Ooops something is wrong, please try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
      return null;
    }
  }

  getExternalPromos() async {
    String token = await storage.read(key: "token");

    var result = await getExternalPromosFromServer("externalPromos", token);

    var externalPromos = new List();
    if (result.data['status'] == true) {
      for (int i = 0; i < result.data['data'].length; i++) {
        if(result.data['data'][i]['promoType'] != "Internal Promo") {

          Promo promo = new Promo();

          promo.promoAddress = result.data['data'][i]['promoCity'];

          if(promo.promoAddress != null && promo.promoAddress.contains(",")){
            List addressParts = promo.promoAddress.split(',');
            promo.promoCountry = addressParts[0];
            promo.promoCity = addressParts[1];
          }

          promo.promoID = result.data['data'][i]['promoID'];
          promo.EventID = result.data['data'][i]['eventID'];
          promo.promoType = result.data['data'][i]['promoType'];
          promo.offerTitle = result.data['data'][i]['offerTitle'];
          promo.promoImageUrl = result.data['data'][i]['promoImageUrl'];
          promo.destinationLink = result.data['data'][i]['destinationLink'];
          promo.mainStyle = result.data['data'][i]['mainStyle'];
          promo.relatedStyle1 = result.data['data'][i]['relatedStyle1'];
          promo.relatedStyle2 = result.data['data'][i]['relatedStyle2'];
          promo.relatedStyle3 = result.data['data'][i]['relatedStyle3'];
          promo.viewCounter = result.data['data'][i]['viewCounter'];


          if (promo.EventID == null && promo.promoAddress != null){
            if (promo.promoAddress == newUser.City){
              externalPromos.add(promo);
            }
            else if (promo.promoAddress == newUser.Country){
              externalPromos.add(promo);
            }
            else if (promo.promoCity ==  newUser.City && promo.promoCountry == newUser.Country){
              externalPromos.add(promo);
            }
          } else if (promo.EventID == null && promo.promoAddress == null){
            externalPromos.add(promo);
          }

        }
      }

      return externalPromos;
    } else if (result.data['status'] == false) {
      //await storage.deleteAll();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
      return null;
    }
  }

  saveViewCounterInDb(promoID, viewCounter) async {
    String token = await storage.read(key: "token");
    var response = await saveCounter("updateCounter", token, {"promoID": promoID, "counter": viewCounter});
  }

  saveViewCounterSpecialInternalPromos(eventID, viewCounter) async {
    String token = await storage.read(key: "token");
    var response = await saveCounter("updateCounterSpecialScreenPromos", token, {"eventID": eventID, "counter": viewCounter});
  }

  @override
  void initState() {
    specialEventsFuture = getSpecialEvents();
    externalPromosFuture = getExternalPromos();
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
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("SPECIALS", style: TextStyle(fontSize: 20, color: Color(0xffFFA800), fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => UserJourney(newUser: newUser),
                                transitionDuration: Duration(seconds: 0)));
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(newUser.profilePictureLink),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder(
                  future: Future.wait([specialEventsFuture, externalPromosFuture]),
                  builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                      return Column(
                        children: [
                          snapshot.data[0] != null ?
                          Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data[0].length,
                                itemBuilder: (context, index) {
                                  return
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Center(
                                        child: GestureDetector(
                                          onTap: () {
                                            snapshot.data[0][index].viewCounter++;
                                            saveViewCounterSpecialInternalPromos(
                                                snapshot.data[0][index].EventID, snapshot.data[0][index].viewCounter);
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                              return EventDetailed(event: snapshot.data[0][index], newUser: newUser);
                                            }));
                                          },
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: height * 0.2,
                                                    width: width * 0.95,
                                                    child: FadeInImage(
                                                        image: NetworkImage(snapshot.data[0][index].ImageUrl),
                                                        placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                                        fit: BoxFit.cover),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                }),
                          ) : Container(),
                          snapshot.data[1] != null ?
                          Container(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data[1].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          snapshot.data[1][index].viewCounter++;
                                          saveViewCounterInDb(snapshot.data[1][index].promoID, snapshot.data[1][index].viewCounter);
                                          launch(snapshot.data[1][index].destinationLink);
                                        },
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Container(
                                                  height: height * 0.2,
                                                  width: width * 0.95,
                                                  child: FadeInImage(
                                                      image: NetworkImage(snapshot.data[1][index].promoImageUrl),
                                                      placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                                      fit: BoxFit.cover),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ) : Container()
                        ],
                      );
                    }
                    else if(snapshot.connectionState == ConnectionState.waiting){
                      return Align(child: Loading2());
                    }
                    else{
                      return Container();
                    }
                  }),
            ],
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
                  Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen(newUser: newUser), transitionDuration: Duration(seconds: 0)));
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
                  break;
                }
            }
          });
        },
      ),
    );
  }
}