import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:united_app/first.dart';
import 'package:united_app/homescreen.dart';
import 'package:united_app/model/promo.dart';
import 'package:united_app/shared/SharedMethods.dart';
import 'package:united_app/specialevents.dart';
import 'package:united_app/userjourney.dart';
import 'package:intl/intl.dart';
import 'ServerRequests/http.dart';
import 'eventdetailed.dart';
import 'model/event.dart';
import 'model/loading.dart';
import 'model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:async/async.dart';
import 'model/preferences.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Explore extends StatefulWidget {
  final User newUser;
  Explore({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return ExploreState(newUser);
  }
}

class ExploreState extends State<Explore> with SingleTickerProviderStateMixin {
  User newUser;
  ExploreState(this.newUser);

  Future future;
  Future fullScreenPromoFuture;
  Future preferencesFuture;
  Future filtersFuture;
  bool isCalender;
  var newresult;

  String tag;
  String type = "Social";

  int _currentIndex = 1;
  final storage = new FlutterSecureStorage();
  final bottomNavigationPages = [UserJourney(), Explore(), SpecialEvents()];
  final date = DateTime.now();
  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime sDate;
  DateTime eDate;

  String eventLocation;
  String eventCountry;

  String selectedDateToShow;

  bool checkStyle1 = true;
  bool checkStyle2 = false;
  bool checkStyle3 = false;

  bool checkDate1 = true;
  bool checkDate2 = false;
  bool checkDate3 = false;
  bool checkDate4 = false;

  bool checkLocation1 = true;
  bool checkLocation2 = false;
  bool checkLocation3 = false;

  List<String> tags = new List();
  List<String> preferences = new List();
  List<Preferences> preferencesList = new List();
  final AsyncMemoizer memoizer = AsyncMemoizer();
  MultiSelectController controller = new MultiSelectController();

  var selectedDate = DateTime.now();

  SharedMethods sh = new SharedMethods();

  createEvent(var item) {
    Event event = new Event();
    event.EventID = item['EventID'];
    event.Title = item['Title'];
    event.Description = item['Description'];
    event.StartDate = item['StartDate'];
    event.EndDate = item['EndDate'];
    event.Location = item['Location'];
    event.Prize = item['Prize'];
    event.Type = item['Type'];
    event.ImageUrl = item['ImageUrl'];
    event.Tags = item['Tags'];
    event.notRepeat = item['notRepeat'];
    event.startTime = item['startTime'];
    event.endTime = item['endTime'];
    event.viewCounter = item['viewCounter'];
    return event;
  }


  getEvents(String tag, DateTime startDate, DateTime endDate, String type, String location, String userCountry) async {
    String token = await storage.read(key: "token");
    var result = await getEventsFromServer("events", token);


    print("Sending request to server");
    String month= DateFormat.MMMM().format(startDate);

    print("I am sending this data to the server");
    print(endDate);
    print(isCalender);

    if(isCalender) {
      newresult= await postRequestEventsToServer(
          "getEventsByFiltersMobile",
          {"location": location, "tag": tag, "type": type, "date": month});
    }
    else{
      newresult= await postRequestEventsToServer(
          "getEventsByFiltersMobile",
          {"location": location, "tag": tag, "type": type, "date": startDate});
    }
    // print("I have reiceved this on flutter side");
          print(newresult.data);
          print(newresult.data['events'].length);
    //       print(newresult.data['events'][0]);

    if (result.data['status'] == true) {
      List<Event> dbEvents = new List();
      for (int i=0; i <newresult.data['events'].length ; i++){
        dbEvents.add(createEvent(newresult.data['events'][i]));
      }
      return dbEvents;
    }
  }


  getEventsold(String tag, DateTime startDate, DateTime endDate, String type, String location, String userCountry) async {
    // String token = await storage.read(key: "token");
    //
    //
    //
    // var result = await getEventsFromServer("events", token);
    // if (result.data['status'] == true) {
    //   List<Event> dbEvents = new List();
    //   for (int i = 0; i < result.data['data'].length; i++) {
    //     DateTime dbStartDate = new DateFormat("yyyy-MM-dd").parse(result.data['data'][i]['StartDate']);
    //     var countryResult = await getEventCountry("getCountry", {result.data['data'][i]['EventID']});
    //     var country = countryResult.data['data']['country'];
    //     if (country != null) {
    //
    //       if ((result.data['data'][i]['Location'] == location || country == userCountry) ||
    //           result.data['data'][i]['Location'] == null) {
    //           if (type == "Social,Party" || type == "Social" || type == "Party") {
    //             String type1 = "Social";
    //             String type2 = "Party";
    //             if (result.data['data'][i]['Tags'] == tag ||
    //                 result.data['data'][i]['relatedStyle1'] == tag ||
    //                 result.data['data'][i]['relatedStyle2'] == tag ||
    //                 result.data['data'][i]['relatedStyle3'] == tag) {
    //               if (result.data['data'][i]['Type'] == type1 || result.data['data'][i]['Type'] == type2) {
    //                 if ((dbStartDate == startDate ||
    //                         (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate)) ||
    //                         dbStartDate == endDate) ||
    //                     (dbStartDate == startDate ||
    //                         (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate) || dbStartDate == endDate))) {
    //                   dbEvents.add(createEvent(result.data['data'][i]));
    //                 }
    //               }
    //             }
    //           } else {
    //           if (result.data['data'][i]['Tags'] == tag ||
    //               result.data['data'][i]['relatedStyle1'] == tag ||
    //               result.data['data'][i]['relatedStyle2'] == tag ||
    //               result.data['data'][i]['relatedStyle3'] == tag) {
    //             if (result.data['data'][i]['Type'] == type) {
    //               if ((dbStartDate == startDate ||
    //                       (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate)) ||
    //                       dbStartDate == endDate) ||
    //                   (dbStartDate == startDate ||
    //                       (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate) || dbStartDate == endDate))) {
    //                 dbEvents.add(createEvent(result.data['data'][i]));
    //               }
    //             }
    //           }
    //         }
    //       }
    //     } else {
    //       if (type == "Social,Party" || type == "Social" || type == "Party") {
    //         String type1 = "Social";
    //         String type2 = "Party";
    //         if (result.data['data'][i]['Tags'] == tag ||
    //             result.data['data'][i]['relatedStyle1'] == tag ||
    //             result.data['data'][i]['relatedStyle2'] == tag ||
    //             result.data['data'][i]['relatedStyle3'] == tag) {
    //           if (result.data['data'][i]['Type'] == type1 || result.data['data'][i]['Type'] == type2) {
    //             if ((dbStartDate == startDate ||
    //                     (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate)) ||
    //                     dbStartDate == endDate) ||
    //                 (dbStartDate == startDate ||
    //                     (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate) || dbStartDate == endDate))) {
    //               dbEvents.add(createEvent(result.data['data'][i]));
    //             }
    //           }
    //         }
    //       } else {
    //         if (result.data['data'][i]['Tags'] == tag ||
    //             result.data['data'][i]['relatedStyle1'] == tag ||
    //             result.data['data'][i]['relatedStyle2'] == tag ||
    //             result.data['data'][i]['relatedStyle3'] == tag) {
    //           if (result.data['data'][i]['Type'] == type) {
    //             if ((dbStartDate == startDate ||
    //                     (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate)) ||
    //                     dbStartDate == endDate) ||
    //                 (dbStartDate == startDate ||
    //                     (dbStartDate.isAfter(startDate) && dbStartDate.isBefore(endDate) || dbStartDate == endDate))) {
    //               dbEvents.add(createEvent(result.data['data'][i]));
    //             }
    //           }
    //         }
    //       }
    //     }
    //   }
    //   print(dbEvents);
    //   dbEvents.sort((a, b)=> a.StartDate.compareTo(b.StartDate));
    //   return dbEvents;
    // } else if (result.data['status'] == false) {
    //   Fluttertoast.showToast(
    //       msg: "Ooops something went wrong,please try again later",
    //       toastLength: Toast.LENGTH_SHORT,
    //       backgroundColor: Colors.black);
    //   //await storage.deleteAll();
    //   //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
    //   return null;
    // }
  }

  saveViewCounterInDb(eventID, viewCounter) async {
    String token = await storage.read(key: "token");
    var response = await saveCounter("updateCounterFullScreenPromos", token, {"eventID": eventID, "counter": viewCounter});
  }

  saveViewCounterInDbExternalPromos(promoID, viewCounter) async {
    String token = await storage.read(key: "token");
    var response = await saveCounter("updateCounterFullScreenExternalPromos", token, {"promoID": promoID, "counter": viewCounter});
  }

  getFullScreenPromo() async {

    String token = await storage.read(key: "token");
    var result = await getFullScreenPromoEventsFromServer("fullScreenPromo", token);
    var resultFullScreenPromos = await getFullScreenPromosFromServer("getFullScreenPromo", token);

    List fullScreenPromos = new List();
    List fullScreenPromoEvents = new List();
    print("Showing full promo");


    if (resultFullScreenPromos.data['status'] == true){

      for (int i = 0; i < resultFullScreenPromos.data['data'].length; i++) {
        Promo promo = new Promo();
        promo.promoID = resultFullScreenPromos.data['data'][i]['promoID'];
        promo.EventID = resultFullScreenPromos.data['data'][i]['eventID'];
        promo.offerTitle = resultFullScreenPromos.data['data'][i]['offerTitle'];
        promo.promoImageUrl = resultFullScreenPromos.data['data'][i]['promoImageUrl'];
        promo.viewCounter = resultFullScreenPromos.data['data'][i]['viewCounter'];
        promo.promoAddress = resultFullScreenPromos.data['data'][i]['promoCity'];
        promo.promoType = resultFullScreenPromos.data['data'][i]['promoType'];

        if (promo.promoAddress != null && promo.promoAddress.contains(",")) {
          List addressParts = promo.promoAddress.split(',');
          promo.promoCountry = addressParts[0];
          promo.promoCity = addressParts[1];
        }
        promo.destinationLink = resultFullScreenPromos.data['data'][i]['destinationLink'];
        fullScreenPromos.add(promo);
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
          fullScreenPromoEvents.add(event);
        }
      }



      List WithoutLocationBasedmainScreenPromos = new List();
      List LocationMatchedmainScreenPromos = new List();
      List LocationNotMatchedmainScreenPromos = new List();

      List WithoutLocationBasedmainScreenPromosEvents = new List();
      List LocationMatchedmainScreenPromosEvents = new List();
      List LocationNotMatchedmainScreenPromosEvents = new List();


      for (int T = 0; T<fullScreenPromos.length; T++){
        if (fullScreenPromos[T].promoAddress != null) {
          if (fullScreenPromos[T].promoAddress == newUser.Country
              || fullScreenPromos[T].promoAddress == newUser.City
              ||  (fullScreenPromos[T].promoCity == newUser.City ||  fullScreenPromos[T].promoCountry == newUser.Country)
          ){
            if (fullScreenPromos[T].promoType == 'Internal Promo'){
              for (int k=0; k<fullScreenPromos.length; k++){
                if (fullScreenPromoEvents[k].EventID == fullScreenPromos[T].EventID){
                  LocationMatchedmainScreenPromosEvents.add(fullScreenPromoEvents[k]);
                  LocationMatchedmainScreenPromos.add(fullScreenPromos[T]);
                }
              }
            }
            if (fullScreenPromos[T].promoType == 'External Promo'){
              LocationMatchedmainScreenPromos.add(fullScreenPromos[T]);
            }

          }
          else {
            if (fullScreenPromos[T].promoType == 'Internal Promo'){
              for (int k=0; k<fullScreenPromoEvents.length; k++){
                if (fullScreenPromoEvents[k].EventID == fullScreenPromos[T].EventID){
                  LocationNotMatchedmainScreenPromosEvents.add(fullScreenPromoEvents[k]);
                  LocationNotMatchedmainScreenPromos.add(fullScreenPromos[T]);
                }
              }
            }
            if (fullScreenPromos[T].promoType == 'External Promo'){
              LocationNotMatchedmainScreenPromos.add(fullScreenPromos[T]);
            }
          }
        }
        else if (fullScreenPromos[T].promoAddress == null) {
          if (fullScreenPromos[T].promoType == 'Internal Promo'){
            for (int k=0; k<fullScreenPromoEvents.length; k++){
              if (fullScreenPromoEvents[k].EventID == fullScreenPromos[T].EventID){
                WithoutLocationBasedmainScreenPromosEvents.add(fullScreenPromoEvents[k]);
                WithoutLocationBasedmainScreenPromos.add(fullScreenPromos[T]);
              }
            }
          }
          if (fullScreenPromos[T].promoType == 'External Promo'){
            WithoutLocationBasedmainScreenPromos.add(fullScreenPromos[T]);
          }
        }
      }



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

  filtersPopUp(BuildContext context, List<Preferences> preferencesList, List<String> secondaryPreferencesList) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Search Settings"),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Location", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Expanded(
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    final kInitialPosition = LatLng(60.12816100000001, 18.643501);
                                    return PlacePicker(
                                      apiKey: "AIzaSyBG9rhs1LqFSbtMeYdWwhEZZtkaFIwKvnM", // Put YOUR OWN KEY here.
                                      onPlacePicked: (result) {
                                        var length2 = result.addressComponents.length;
                                        eventLocation = null;
                                        eventCountry = null;
                                        bool l = false, a3 = false, a2 = false, a1 = false;
                                        for (int i = 0; i < length2; i++) {
                                          if (result.addressComponents[i].types[0] == 'country') {
                                            eventCountry = result.addressComponents[i].longName;
                                          }

                                          if (result.addressComponents[i].types[0] == 'locality' && eventLocation == null) {
                                            setState(() {
                                              eventLocation = result.addressComponents[i].longName;
                                              l = true;
                                            });
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_3' &&
                                              eventLocation == null) {
                                            setState(() {
                                              eventLocation = result.addressComponents[i].longName;
                                              a3 = true;
                                            });
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_2' &&
                                              eventLocation == null) {
                                            setState(() {
                                              eventLocation = result.addressComponents[i].longName;
                                              a2 = true;
                                            });
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_1' &&
                                              eventLocation == null) {
                                            setState(() {
                                              eventLocation = result.addressComponents[i].longName;
                                              a1 = true;
                                            });
                                          }else if(l == false && a3 == false && a2 == false && a1 == false){
                                            eventLocation = null;
                                          }
                                          newUser.Country = eventCountry;
                                        }

                                        Navigator.of(context).pop();
                                        //getEvents(tag, startDate, endDate, type, location)
                                      },
                                      initialPosition: kInitialPosition,
                                      useCurrentLocation: false,
                                    );
                                  }),
                                );
                              },
                              child: Text("Pick Location"),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 30),
                      Text("Choose up to 3 related styles", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                                    return MultiSelectItem(
                                      isSelecting: controller.isSelecting,
                                      onSelected: () {
                                        setState(() {
                                          if (secondaryPreferencesList.length < 3) {
                                            if (!controller.isSelected(index)) {
                                              secondaryPreferencesList.add(snapshot.data[index].preferenceName);
                                            }
                                            controller.toggle(index);
                                            if (!controller.isSelected(index)) {
                                              secondaryPreferencesList
                                                  .removeWhere((element) => element == snapshot.data[index].preferenceName);
                                            }
                                          } else if (secondaryPreferencesList.length == 3) {
                                            if (!controller.isSelected(index)) {
                                              Fluttertoast.showToast(
                                                  msg: "Deselect one option to select another",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  backgroundColor: Colors.black);
                                            }
                                            if (controller.isSelected(index)) {
                                              controller.toggle(index);
                                            }
                                            if (!controller.isSelected(index)) {
                                              secondaryPreferencesList
                                                  .removeWhere((element) => element == snapshot.data[index].preferenceName);
                                            }
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          color: controller.isSelected(index) ? Color(0xfffdb602) : Color(0xfff1ead7),
                                          elevation: 10,
                                          child: Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(snapshot.data[index].preferenceName,
                                                    style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                              )),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(color: Colors.white70, width: 1),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
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
              actions: [
                RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('done'))
              ],
            );
          });
        }).then((value) => setState(() {


      if (preferences.length == 1) {
        storage.write(key: "preference1", value: preferences[0]);
        tags[0] = preferences[0];
      } else if (preferences.length == 2) {
        storage.write(key: "preference1", value: preferences[0]);
        storage.write(key: "preference2", value: preferences[1]);
        tags[0] = preferences[0];
        tags[1] = preferences[1];
      } else if (preferences.length == 3) {
        storage.write(key: "preference1", value: preferences[0]);
        storage.write(key: "preference2", value: preferences[1]);
        storage.write(key: "preference3", value: preferences[2]);
        tags[0] = preferences[0];
        tags[1] = preferences[1];
        tags[2] = preferences[2];
      }
      checkStyle1 == true
          ? tag = tags[0]
          : checkStyle2 == true
          ? tag = tags[1]
          : tag = tags[2];
      future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
    }));
  }


  var tag1, tag2, tag3;

  getTags() async {
    tag1 = await storage.read(key: "preference1");
    tag2 = await storage.read(key: "preference2");
    tag3 = await storage.read(key: "preference3");

    print("here are my initial tags");
    print(tag1 + " " + tag2 + "  " + tag3);
  }

  @override
  void initState() {
    tags.add("");
    tags.add("");
    tags.add("");

    getTags().then((value) => setState(() {
          tags[0] = tag1;
          tags[1] = tag2;
          tags[2] = tag3;
          tag = tags[0];
        }));

    DateTime today = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day);

    eventLocation = newUser.City;
    eventCountry = newUser.Country;

    sDate = today;
    eDate = today;

    future = getEvents(tag, sDate, eDate, type, newUser.City, eventLocation);

    preferencesFuture = sh.getPreferences(preferencesList);
    fullScreenPromoFuture = getFullScreenPromo();

    fullScreenPromoFuture.then((result) {
      if (result != null) {
        Timer(
            Duration(seconds: 60),
            () => showGeneralDialog(
                  context: context,
                  barrierDismissible: false,
                  barrierLabel: "Dialog",
                  transitionDuration: Duration(milliseconds: 400),
                  pageBuilder: (_, __, ___) {
                    double width = MediaQuery.of(context).size.width;
                    double height = MediaQuery.of(context).size.height;
                    return Scaffold(
                      body: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 4,
                            child: FutureBuilder(
                                future: fullScreenPromoFuture,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {

                                    return GestureDetector(
                                      onTap: () {
                                        if(snapshot.data.EventID != null){
                                          snapshot.data.viewCounter++;
                                          saveViewCounterInDb(snapshot.data.EventID, snapshot.data.viewCounter);
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return EventDetailed(event: snapshot.data, newUser: newUser);
                                          }));
                                        }else{
                                          snapshot.data.viewCounter++;
                                          saveViewCounterInDbExternalPromos(snapshot.data.promoID,
                                              snapshot.data.viewCounter);
                                          launch(snapshot.data.destinationLink);
                                        }
                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: height,
                                            width: width,
                                            child: FadeInImage(
                                                image: NetworkImage(snapshot.data.EventID == null ?
                                                snapshot.data.promoImageUrl :
                                                snapshot.data.ImageUrl),
                                                placeholder: AssetImage("assets/images/eventPlaceHolder.jpg"),
                                                fit: BoxFit.cover),
                                          ),
                                          Positioned(
                                            top: height * 0.02,
                                            left: width * 0.9,
                                            child: IconButton(
                                              icon: Icon(FontAwesomeIcons.solidWindowClose, color: Color(0xffFFA800), size: 30),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.data == null) {
                                    return Center(child: Text("Full Screen Promo not available"));
                                  } else {
                                    return Align(child: CircularProgressIndicator());
                                  }
                                }),
                          ),
                        ],
                      ),
                    );
                  },
                ));
      }
    });
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            eventCountry == null
                                ? Container()
                                : Text(eventLocation,
                                    style: TextStyle(color: Color(0xffFFA800), fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        IconButton(
                          icon: Container(height: 20, width: 20, child: new Image.asset("assets/icons/Explore.png")),
                          onPressed: () {
                            filtersPopUp(context, preferencesList, preferences);
                          },
                        ),
                      ],
                    ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Wrap(
                  children: <Widget>[
                    SizedBox(
                      width: width / 4,
                      child: FlatButton(
                        child: Text(
                          tags[0],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          setState(() {
                            tag = tags[0];

                            checkStyle1 = true;
                            checkStyle2 = false;
                            checkStyle3 = false;

                            future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                          });
                        },
                        color: checkStyle1 ? Color(0xffFFA800) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: checkStyle1 ? Color(0xffFFA800) : Colors.black)),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: width / 4,
                      child: FlatButton(
                        child: Text(
                          tags[1],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          setState(() {
                            tag = tags[1];

                            checkStyle1 = false;
                            checkStyle2 = true;
                            checkStyle3 = false;

                            future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                          });
                        },
                        color: checkStyle2 ? Color(0xffFFA800) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: checkStyle2 ? Color(0xffFFA800) : Colors.black)),
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: width / 4,
                      child: FlatButton(
                        child: Text(
                          tags[2],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onPressed: () {
                          setState(() {
                            tag = tags[2];

                            checkStyle1 = false;
                            checkStyle2 = false;
                            checkStyle3 = true;

                            future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                          });
                        },
                        color: checkStyle3 ? Color(0xffFFA800) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: checkStyle3 ? Color(0xffFFA800) : Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("Today"),
                      onPressed: () {
                        setState(() {
                          DateTime today =
                              new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day);

                          checkDate1 = true;
                          checkDate2 = false;
                          checkDate3 = false;
                          checkDate4 = false;
                          isCalender = false;
                          sDate = today;
                          eDate = today;
                          String formattedDate = DateFormat('dd.MM.yyyy').format(sDate);
                          selectedDateToShow = formattedDate;
                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkDate1 ? Color(0xffFFA800) : Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: checkDate1 ? Color(0xffFFA800) : Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("Tomorrow"),
                      onPressed: () {
                        setState(() {
                          DateTime tomorrow =
                              new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day + 1);
                          checkDate1 = false;
                          checkDate2 = true;
                          checkDate3 = false;
                          checkDate4 = false;
                          isCalender = false;

                          sDate = tomorrow;
                          eDate = tomorrow;
                          String formattedDate = DateFormat('dd.MM.yyyy').format(sDate);
                          selectedDateToShow = formattedDate;
                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkDate2 ? Color(0xffFFA800) : Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: checkDate2 ? Color(0xffFFA800) : Colors.black,
                          )),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("This Week"),
                      onPressed: () {
                        final date = DateTime.now();
                        DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
                        DateTime startDate = getDate(date.subtract(Duration(days: date.weekday - 1)));
                        DateTime endDate = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));

                        setState(() {
                          checkDate1 = false;
                          checkDate2 = false;
                          checkDate3 = true;
                          checkDate4 = false;
                          isCalender = false;

                          sDate = startDate;
                          eDate = endDate;
                          selectedDateToShow = null;

                          print("\n\n\nTesting = ");
                          print(tag);
                          print(sDate);
                          print(eDate);
                          print(type);
                          print(eventLocation);
                          print(eventCountry);

                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkDate3 ? Color(0xffFFA800) : Colors.transparent,
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: checkDate3 ? Color(0xffFFA800) : Colors.black,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("This Weekend"),
                      onPressed: () {
                        setState(() {
                          final date = DateTime.now();
                          DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
                          DateTime weekEndSunday = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));
                          DateTime weekEndSaturday = DateTime(weekEndSunday.year, weekEndSunday.month, weekEndSunday.day - 1);

                          checkDate1 = false;
                          checkDate2 = false;
                          checkDate3 = false;
                          checkDate4 = true;
                          isCalender = false;

                          sDate = weekEndSaturday;
                          eDate = weekEndSunday;
                          selectedDateToShow = null;
                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkDate4 ? Color(0xffFFA800) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: checkDate4 ? Color(0xffFFA800) : Colors.black)),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("Classes"),
                      onPressed: () {
                        setState(() {
                          type = "Classes";
                          checkLocation1 = false;
                          checkLocation2 = true;
                          checkLocation3 = false;

                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkLocation2 ? Color(0xffFFA800) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: checkLocation2 ? Color(0xffFFA800) : Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("Social & Party"),
                      onPressed: () {
                        setState(() {
                          type = "Social,Party";
                          checkLocation1 = true;
                          checkLocation2 = false;
                          checkLocation3 = false;

                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkLocation1 ? Color(0xffFFA800) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: checkLocation1 ? Color(0xffFFA800) : Colors.black)),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: FlatButton(
                      child: Text("Festival"),
                      onPressed: () {
                        setState(() {
                          type = "Festival";
                          checkLocation1 = false;
                          checkLocation2 = false;
                          checkLocation3 = true;

                          future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                        });
                      },
                      color: checkLocation3 ? Color(0xffFFA800) : Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: checkLocation3 ? Color(0xffFFA800) : Colors.black)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 00, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Events", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        selectedDateToShow != null ? Text(selectedDateToShow.toString()) : Container(),
                      ],
                    ),
                    IconButton(
                        icon: Container(height: 20, width: 20, child: new Image.asset("assets/icons/calicon.jpeg")),
                        onPressed: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 1),
                            lastDate: DateTime(DateTime.now().year + 1, 12),
                            initialDate: selectedDate,
                            locale: Locale("en"),
                          ).then((date) {
                            setState(() {
                              DateTime firstDay = DateTime(date.year, date.month, 1);
                              DateTime lastDay = DateTime(date.year, date.month + 1, 0);

                              sDate = firstDay;
                              eDate = lastDay;
                              checkDate1 = false;
                              checkDate2 = false;
                              checkDate3 = false;
                              checkDate4 = false;
                              isCalender = true;

                              String formattedDate = DateFormat('MMMM').format(sDate);
                              selectedDateToShow = formattedDate;
                              future = getEvents(tag, sDate, eDate, type, eventLocation, eventCountry);
                            });
                          });
                        })
                  ],
                ),
              ),
              FutureBuilder(
                  future: future,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done && snapshot.data != null && snapshot.data.length != 0) {
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
                                    snapshot.data[index].viewCounter++;
                                    saveViewCounterInDb(snapshot.data[index].EventID, snapshot.data[index].viewCounter);

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
                    } else if (snapshot.connectionState != ConnectionState.waiting && snapshot.data == null ||
                        snapshot.data.length == 0) {
                      return Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              String eventData = "We miss your events at Dance United" + "\n"
                              + "Learn more at www.danceunited.se";
                              final RenderBox box = context.findRenderObject();

                              Share.share(eventData, sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
                            },
                            child: Container(
                              height: 140,
                              width: width*0.95,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage("assets/images/noevents.png"), fit: BoxFit.cover)),
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
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => HomeScreen(newUser: newUser), transitionDuration: Duration(seconds: 0)));
                  break;
                }
              case 1:
                {
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
