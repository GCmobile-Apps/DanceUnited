import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/first.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/model/promo.dart';
import 'package:united_app/professional/professional2.dart';
import 'package:async/async.dart';

import '../ServerRequests/http.dart';
import '../ServerRequests/http.dart';

class SharedMethods extends StatefulWidget{

  final storage = new FlutterSecureStorage();

  final AsyncMemoizer memoizer = AsyncMemoizer();
  MultiSelectController controller = new MultiSelectController();
  MultiSelectController primaryStyleController = new MultiSelectController();


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  GetProEvents(dbEvents) async {
    String token = await storage.read(key: "token");
    var result = await getEventsFromServer("events", token);
    print(result.data.length);
    for (int i = 0; i<result.data.length; i++){
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
      dbEvents.add(event);

    }
    return dbEvents;
  }


  getProUserEvents(ProfessionalUser proUser,List<Event> dbEvents) async {
    var result;
    String token = await storage.read(key: "professionalToken");
    result = await getProEventsFromServer("proevents", token, {"userID": proUser.UserID});

    for (int i = 0; i < result.data.length; i++) {
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
      dbEvents.add(event);
    }
    dbEvents.sort((a, b)=> a.StartDate.compareTo(b.StartDate));
    return dbEvents;
  }

  getPreferences(List<Preferences> preferencesList) {
    return this.memoizer.runOnce(() async {
      String token = await storage.read(key: "professionalToken");
      var result = await getPreferencesFromServer("preferences");

      for (int i = 0; i < result.data['list'].length; i++) {
        Preferences preferences = new Preferences();
        preferences.preferenceID = result.data['list'][i]['PreferenceID'];
        preferences.preferenceName = result.data['list'][i]['PreferenceName'];
        preferencesList.add(preferences);
      }
      if(preferencesList.isEmpty){
        Fluttertoast.showToast(
            msg: "Ooops something is wrong,please try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black);
      }
      return preferencesList;
    });
  }


  primaryFilterPopUp(BuildContext context,List<Preferences> preferencesList,List<String> primaryPreference) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Choose main style'),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: getPreferences(preferencesList),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.length,
                                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                  itemBuilder: (context, index) {
                                    return MultiSelectItem(
                                      isSelecting: primaryStyleController.isSelecting,
                                      onSelected: () {
                                        setState(() {
                                          if (primaryPreference.length < 1) {
                                            if (!primaryStyleController.isSelected(index)) {
                                              primaryPreference.add(snapshot.data[index].preferenceName);
                                            }
                                            primaryStyleController.toggle(index);
                                            if (!primaryStyleController.isSelected(index)) {
                                              primaryPreference
                                                  .removeWhere((element) => element == snapshot.data[index].preferenceName);
                                            }
                                          }
                                          else if (primaryPreference.length == 1) {
                                            if (!primaryStyleController.isSelected(index)) {
                                              Fluttertoast.showToast(
                                                  msg: "Deselect one option to select another",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  backgroundColor: Colors.black);
                                            }
                                            if (primaryStyleController.isSelected(index)) {
                                              primaryStyleController.toggle(index);
                                            }
                                            if (!primaryStyleController.isSelected(index)) {
                                              primaryPreference
                                                  .removeWhere((element) => element == snapshot.data[index].preferenceName);
                                            }
                                          }
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Card(
                                          color: primaryStyleController.isSelected(index)
                                              ? Color(0xfffdb602)
                                              : Color(0xfff1ead7),
                                          elevation: 10,
                                          child: Center(
                                              child: Text(snapshot.data[index].preferenceName,
                                                  style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
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
                          }
                          ),
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
        });
  }

  filtersPopUp(BuildContext context,List<Preferences> preferencesList,List<String> secondaryPreferencesList) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Choose up to 3 related styles"),
              content: Container(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: getPreferences(preferencesList),
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
        });
  }



  getAllPromos(BuildContext context, userID) async {


    String token;
    String proToken = await storage.read(key: "professionalToken");
    String userToken = await storage.read(key: "token");

    if(proToken == null){
      token = userToken;
    }else if(userToken == null){
      token = proToken;
    }

    var result = await getProUserSpecialScreenPromosFromServer("getProUserSpecialScreenPromo", token,
        {"userID": userID});
    var mainScreenPromosResult = await getProUserMainScreenPromosFromServer("getProUserMainScreenPromo", token,
        {"userID": userID});
    var fullScreenPromosResult = await getProUserFullScreenPromosFromServer("getProUserFullScreenPromo", token,
        {"userID": userID});
    var totalCounter = 0;


    var allPromosList = new List();
    if (result.data['status'] == true || mainScreenPromosResult.data['status'] == true || fullScreenPromosResult.data['status'] == true) {

      if(result.data['data'] != null) {
        for (int i = 0; i < result.data['data'].length; i++) {
          Promo promo = new Promo();
          promo.promoID = result.data['data'][i]['promoID'];
          promo.userID = result.data['data'][i]['userID'];
          promo.promoType = result.data['data'][i]['promoType'];
          promo.offerTitle = result.data['data'][i]['offerTitle'];
          promo.promoImageUrl = result.data['data'][i]['promoImageUrl'];
          promo.destinationLink = result.data['data'][i]['destinationLink'];
          promo.mainStyle = result.data['data'][i]['mainStyle'];
          promo.relatedStyle1 = result.data['data'][i]['relatedStyle1'];
          promo.relatedStyle2 = result.data['data'][i]['relatedStyle2'];
          promo.relatedStyle3 = result.data['data'][i]['relatedStyle3'];
          promo.promoCity = result.data['data'][i]['promoCity'];
          promo.viewCounter = result.data['data'][i]['viewCounter'];

          totalCounter = totalCounter + result.data['data'][i]['viewCounter'];

          allPromosList.add(promo);
        }
      }
      if(mainScreenPromosResult.data['data'] != null) {
        for (int i = 0; i < mainScreenPromosResult.data['data'].length; i++) {
          Promo promo = new Promo();
          promo.promoID = mainScreenPromosResult.data['data'][i]['promoID'];
          promo.userID = mainScreenPromosResult.data['data'][i]['userID'];
          promo.promoType = mainScreenPromosResult.data['data'][i]['promoType'];
          promo.offerTitle = mainScreenPromosResult.data['data'][i]['offerTitle'];
          promo.promoImageUrl = mainScreenPromosResult.data['data'][i]['promoImageUrl'];
          promo.destinationLink = mainScreenPromosResult.data['data'][i]['destinationLink'];
          promo.mainStyle = mainScreenPromosResult.data['data'][i]['mainStyle'];
          promo.relatedStyle1 = mainScreenPromosResult.data['data'][i]['relatedStyle1'];
          promo.relatedStyle2 = mainScreenPromosResult.data['data'][i]['relatedStyle2'];
          promo.relatedStyle3 = mainScreenPromosResult.data['data'][i]['relatedStyle3'];
          promo.promoCity = mainScreenPromosResult.data['data'][i]['promoCity'];
          promo.viewCounter = mainScreenPromosResult.data['data'][i]['viewCounter'];

          totalCounter = totalCounter + mainScreenPromosResult.data['data'][i]['viewCounter'];

          allPromosList.add(promo);
        }
      }

      if(fullScreenPromosResult.data['data'] != null) {
        for (int i = 0; i < fullScreenPromosResult.data['data'].length; i++) {
          Promo promo = new Promo();
          promo.promoID = fullScreenPromosResult.data['data'][i]['promoID'];
          promo.userID = fullScreenPromosResult.data['data'][i]['userID'];
          promo.promoType = fullScreenPromosResult.data['data'][i]['promoType'];
          promo.offerTitle = fullScreenPromosResult.data['data'][i]['offerTitle'];
          promo.promoImageUrl = fullScreenPromosResult.data['data'][i]['promoImageUrl'];
          promo.destinationLink = fullScreenPromosResult.data['data'][i]['destinationLink'];
          promo.mainStyle = fullScreenPromosResult.data['data'][i]['mainStyle'];
          promo.relatedStyle1 = fullScreenPromosResult.data['data'][i]['relatedStyle1'];
          promo.relatedStyle2 = fullScreenPromosResult.data['data'][i]['relatedStyle2'];
          promo.relatedStyle3 = fullScreenPromosResult.data['data'][i]['relatedStyle3'];
          promo.promoCity = fullScreenPromosResult.data['data'][i]['promoCity'];
          promo.viewCounter = fullScreenPromosResult.data['data'][i]['viewCounter'];

          totalCounter = totalCounter + fullScreenPromosResult.data['data'][i]['viewCounter'];

          allPromosList.add(promo);
        }
      }


      for (int k = 0; k < allPromosList.length; k++) {
        if (totalCounter == 0) {
          allPromosList[k].percentage = 0.0;
        } else {
          allPromosList[k].percentage = (allPromosList[k].viewCounter * 100) / totalCounter;
        }
      }

      return allPromosList;
    } else if (result.data['status'] == false) {
      //await storage.deleteAll();
      //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
      return null;
    }
  }

  getEvents(BuildContext context,Event event) async {
    String token = await storage.read(key: "token");
    var result = await getEventsFromServer("events", token);

    print("These are the events from  the database");
    print(result.data['data']);

    if (result.data['status'] == true) {
      List<Event> dbEvents = new List();

      final date = DateTime.now();
      DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);
      DateTime startDate = getDate(date.subtract(Duration(days: date.weekday - 1)));
      DateTime endDate = getDate(date.add(Duration(days: DateTime.daysPerWeek - date.weekday)));

      for (int i = 0; i < result.data['data'].length; i++) {
        DateTime dbStartDate = new DateFormat("yyyy-MM-dd").parse(result.data['data'][i]['StartDate']);

        if (event.Tags == result.data['data'][i]['Tags'] &&
            event.Location == result.data['data'][i]['Location'] &&
            (dbStartDate.isAfter(startDate) || dbStartDate == startDate) &&
            (dbStartDate.isBefore(endDate) || dbStartDate == endDate) &&
            event.EventID != result.data['data'][i]['EventID']) {
          Event newEvent = new Event();
          newEvent.EventID = result.data['data'][i]['EventID'];
          newEvent.Title = result.data['data'][i]['Title'];
          newEvent.Description = result.data['data'][i]['Description'];
          newEvent.StartDate = result.data['data'][i]['StartDate'];
          newEvent.EndDate = result.data['data'][i]['EndDate'];
          newEvent.Location = result.data['data'][i]['Location'];
          newEvent.Prize = result.data['data'][i]['Prize'];
          newEvent.Type = result.data['data'][i]['Type'];
          newEvent.ImageUrl = result.data['data'][i]['ImageUrl'];
          newEvent.startTime = result.data['data'][i]['startTime'];
          newEvent.endTime = result.data['data'][i]['endTime'];
          newEvent.Tags = result.data['data'][i]['Tags'];
          newEvent.notRepeat = result.data['data'][i]['notRepeat'];

          dbEvents.add(newEvent);
        }
      }
      return dbEvents;
    }
    else if (result.data['status'] == false) {
      Fluttertoast.showToast(
          msg: "Ooops something is wrong,please try again later",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      await storage.deleteAll();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
      return null;
    }
  }






}