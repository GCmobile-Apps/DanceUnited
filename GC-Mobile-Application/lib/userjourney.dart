import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/eventdetailed.dart';
import 'package:united_app/explore.dart';
import 'package:united_app/first.dart';
import 'package:united_app/model/cantakepart.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/ranking.dart';
import 'package:united_app/shared/SharedMethods.dart';
import 'package:united_app/specialevents.dart';
import 'package:united_app/homescreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Custom Classes/Gradient_Border.dart';
import 'model/event.dart';
import 'model/loading.dart';
import 'model/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserJourney extends StatefulWidget {
  final User newUser;
  UserJourney({this.newUser});

  SharedMethods sh= new SharedMethods();

  @override
  State<StatefulWidget> createState() {
    return UserJourneyState(newUser);
  }
}

class UserJourneyState extends State<UserJourney> {
  User newUser;
  UserJourneyState(this.newUser);

  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<String> secondaryPreferencesList = new List();
  List<Preferences> preferencesList = new List();
  MultiSelectController controller = new MultiSelectController();

  bool updateUserNameCheck = false;

  int _currentIndex = 2;

  Future future;
  Future profilePictureFuture;
  Future preferencesFuture;
  Future pastEvents;
  Future linksFuture;
  List<Event> dbEvents = new List();
  Future rankingFuture;

  final storage = new FlutterSecureStorage();

  bool checkBoxValue = false;

  PickedFile pickedFile;
  final ImagePicker imagePicker = ImagePicker();
  bool circularProgress = false;
  var imageResponse;
  bool editProfile = false;
  bool editTitle = false;
  bool loading =false;

  TextEditingController nameController = new TextEditingController();

  FocusNode focusNode;
  SharedMethods sh= new SharedMethods();

  deleteAccount(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Dance United"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Do you want to delete your account?",
                    style: TextStyle(color: Color(0xfff7c864), fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                Text("Please consider giving us feedback about what went wrong"),
                RaisedButton(
                  child: Text("Give feedback"),
                  onPressed: () {
                    Navigator.pop(context);
                    feedback(context);
                  },
                  color: Color(0xffFFA800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xffFFA800))),
                ),
                SizedBox(height: 20),
                Text("You can also logout instead and come back anytime"),
                RaisedButton(
                  child: Text("Log me out"),
                  onPressed: () async {
                    await storage.deleteAll();
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setBool("sessionCheck", false);
                    prefs.setBool("sessionCheckFullScreen", false);
                    await prefs.remove("email");
                    await prefs.remove("password");
                    await prefs.remove("token");
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                  },
                  color: Color(0xffFFA800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xffFFA800))),
                ),
                SizedBox(height: 30),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      deleteAccountPermanently(context);
                    },
                    child: Text("No, I'm sure i want to delete my account"))
              ],
            ),
            actions: <Widget>[],
          );
        });
  }

  deleteAccountPermanently(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Dance United"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("This will permanently delete your data from this app.",
                      style: TextStyle(color: Color(0xfff7c864), fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                          value: checkBoxValue,
                          onChanged: (bool value) {
                            setState(() {
                              checkBoxValue = value;
                            });
                          }),
                      Expanded(child: Text("I'm aware of that my account can't be restored once it's fully deleted"))
                    ],
                  ),
                  SizedBox(height: 30),
                  RaisedButton(
                    child: Text("Delete my account"),
                    onPressed: checkBoxValue
                        ? () async {
                            String token = await storage.read(key: "token");
                            var result = await deleteUserAccount("deleteAccount", token, {"userID": newUser.UserID});
                            if (result == 200) {
                              await storage.deleteAll();
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              await prefs.clear();
                              Navigator.pushAndRemoveUntil(
                                  context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                            }
                          }
                        : null,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xffFFA800))),
                  ),
                ],
              ),
              actions: [],
            );
          });
        });
  }

  feedback(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Thank you for giving us feedback!",
                      style: TextStyle(color: Color(0xfff7c864), fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text("We have just started a want to get better."),
                  SizedBox(height: 10),
                  Text("Drop us a message via our official Facebook page"),
                  SizedBox(height: 10),
                  FutureBuilder(
                      future: linksFuture,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                          return FlatButton(
                              onPressed: () {
                                launch(snapshot.data[6]['link_value']);
                              },
                              child: Text("Take me there.",
                                  style: TextStyle(color: Color(0xfff7c864), fontWeight: FontWeight.bold)));
                        }
                        else if (snapshot.data == null) {
                          return Container();
                        } else {
                          return Align(child: Loading2());
                        }
                      }),
                ],
              ),
              actions: [
                RaisedButton(
                  child: Text("done"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Color(0xffFFA800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xffFFA800))),
                ),
              ],
            );
          });
        });
  }

  getUserSpecificEvents() async {
    String token = await storage.read(key: "token");
    var result = await getUserEvents("userEvents", token, {"userID": newUser.UserID});
    List<Event> dbEvents = new List();

    if (result.data != null) {
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
        dbEvents.add(event);
      }
    }
    return dbEvents;
  }

  getPastEvents() async {
    List<Event> dbEvents = new List();
    List<Event> pastEvents = new List();

    var response = await getUserSpecificEvents();
    dbEvents = response;

    for (int i = 0; i < dbEvents.length; i++) {
      DateTime dbStartDate = new DateFormat("yyyy-MM-dd").parse(dbEvents[i].StartDate);
      DateTime dbEndDate = new DateFormat("yyyy-MM-dd").parse(dbEvents[i].EndDate);

      DateTime yesterday = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day - 1);

      if ((dbStartDate.isBefore(yesterday)) || dbEndDate == yesterday) {
        pastEvents.add(dbEvents[i]);
      }
    }
    return pastEvents;
  }

  getUserSpecificPreferences() async {
    String token = await storage.read(key: "token");
    var result = await getEventsFromServer("events", token);
    var resultAllUsers = await getAllUsersFromServer("allUsers", token);
    var allGoingEvents = await getAllGoingEvents("allGoingEvents", token);
    var rank = new List();
    var userGoingEventsIds = new List();

    for (int j = 0; j < allGoingEvents.data['data'].length; j++) {
      if (allGoingEvents.data['data'][j]['UserId'] == newUser.UserID) {
        userGoingEventsIds.add(allGoingEvents.data['data'][j]['EventID']);
      }
    }

    if (result.data['message'] != 'Not found') {
      int totalEventCounter = 0;
      int monthlyEventCounter = 0;

      List<Ranking> ranking = new List();
      int counter = 0;
      Ranking rankingObj = new Ranking();
      Ranking holder = new Ranking();

      List<User> users = new List();
      List<User> usersCountryBased = new List();
      List<CanTakePart> goingEvents = new List();

      if (result.data['status'] == true) {
        for (int i = 0; i < result.data['data'].length; i++) {
          for (int j = 0; j < userGoingEventsIds.length; j++) {
            if (userGoingEventsIds[j] == result.data['data'][i]['EventID']) {
              DateTime dbStartDate = new DateFormat("yyyy-MM-dd").parse(result.data['data'][i]['StartDate']);
              DateTime dbEndDate = new DateFormat("yyyy-MM-dd").parse(result.data['data'][i]['EndDate']);

              DateTime monthStart = new DateTime(DateTime.now().year, DateTime.now().month, 1);
              DateTime monthEnd = new DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

              totalEventCounter++;
              if (dbStartDate.isAfter(monthStart) &&
                  dbStartDate.isBefore(monthEnd) &&
                  dbEndDate.isAfter(monthStart) &&
                  dbEndDate.isBefore(monthEnd)) {
                monthlyEventCounter++;
              }
            }
          }
        }
        rank.add(monthlyEventCounter);
        rank.add(totalEventCounter);
      } else if (result.data['status'] == false) {
        await storage.deleteAll();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
        return null;
      }

      for (int i = 0; i < resultAllUsers.data['data'].length; i++) {
        User user = new User();
        user.UserID = resultAllUsers.data['data'][i]['UserID'];
        user.FirstName = resultAllUsers.data['data'][i]['FirstName'];
        user.LastName = resultAllUsers.data['data'][i]['LastName'];
        user.username = resultAllUsers.data['data'][i]['username'];
        user.password = resultAllUsers.data['data'][i]['password'];
        user.StreetAddress = resultAllUsers.data['data'][i]['StreetAddress'];
        user.City = resultAllUsers.data['data'][i]['City'];
        user.Country = resultAllUsers.data['data'][i]['Country'];
        user.ZipCode = resultAllUsers.data['data'][i]['Zipcode'];
        user.ContactNumber = resultAllUsers.data['data'][i]['ContactNumber'];
        user.Email = resultAllUsers.data['data'][i]['Email'];
        user.profilePictureLink = resultAllUsers.data['data'][i]['profilePictureLink'];
        users.add(user);

        if (resultAllUsers.data['data'][i]['City'] == newUser.City) {
          User user = new User();
          user.UserID = resultAllUsers.data['data'][i]['UserID'];
          user.FirstName = resultAllUsers.data['data'][i]['FirstName'];
          user.LastName = resultAllUsers.data['data'][i]['LastName'];
          user.username = resultAllUsers.data['data'][i]['username'];
          user.password = resultAllUsers.data['data'][i]['password'];
          user.StreetAddress = resultAllUsers.data['data'][i]['StreetAddress'];
          user.City = resultAllUsers.data['data'][i]['City'];
          user.Country = resultAllUsers.data['data'][i]['Country'];
          user.ZipCode = resultAllUsers.data['data'][i]['Zipcode'];
          user.ContactNumber = resultAllUsers.data['data'][i]['ContactNumber'];
          user.Email = resultAllUsers.data['data'][i]['Email'];
          user.profilePictureLink = resultAllUsers.data['data'][i]['profilePictureLink'];
          usersCountryBased.add(user);
        }
      }

      for (int i = 0; i < allGoingEvents.data['data'].length; i++) {
        CanTakePart canTakePart = new CanTakePart();
        canTakePart.UserID = allGoingEvents.data['data'][i]['UserId'];
        canTakePart.EventID = allGoingEvents.data['data'][i]['EventID'];
        goingEvents.add(canTakePart);
      }

      for (int i = 0; i < users.length; i++) {
        rankingObj = new Ranking();
        counter = 0;

        for (int j = 0; j < goingEvents.length; j++) {
          if (users[i].UserID == goingEvents[j].UserID) {
            counter++;
          }
        }
        rankingObj.userID = users[i].UserID;
        rankingObj.numberOfEventsGoing = counter;
        ranking.add(rankingObj);
      }

      for (int i = 0; i < ranking.length; ++i) {
        for (int j = i + 1; j < ranking.length; ++j) {
          if (ranking[i].numberOfEventsGoing < ranking[j].numberOfEventsGoing) {
            holder = ranking[i];
            ranking[i] = ranking[j];
            ranking[j] = holder;
          }
        }
      }

      List<Ranking> ranking2 = new List();
      for (int i = 0; i < usersCountryBased.length; i++) {
        rankingObj = new Ranking();
        counter = 0;

        for (int j = 0; j < goingEvents.length; j++) {
          if (usersCountryBased[i].UserID == goingEvents[j].UserID) {
            counter++;
          }
        }
        rankingObj.userID = usersCountryBased[i].UserID;
        rankingObj.numberOfEventsGoing = counter;
        ranking2.add(rankingObj);
      }

      for (int i = 0; i < ranking2.length; ++i) {
        for (int j = i + 1; j < ranking2.length; ++j) {
          if (ranking2[i].numberOfEventsGoing < ranking2[j].numberOfEventsGoing) {
            holder = ranking2[i];
            ranking2[i] = ranking2[j];
            ranking2[j] = holder;
          }
        }
      }

      for (int i = 0; i < ranking.length; i++) {
        if (ranking[i].userID == newUser.UserID) {
          rank.add(++i); // at 3rd place added ranking from all over the database
        }
      }

      for (int i = 0; i < ranking2.length; i++) {
        if (ranking2[i].userID == newUser.UserID) {
          rank.add(++i); // at 4th place added ranking from the Country of user logged in
        }
      }
    } else {
      rank.add(0);
      rank.add(0);
      rank.add(0);
      rank.add(0);
    }
    return rank;
  }

  updateProfilePicture() async {
    setState(() {
      newUser.profilePictureLink = null;
    });
    String token = await storage.read(key: "token");
    final picked = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = picked;
    });
    setState(() {
      circularProgress = true;
    });
    if (pickedFile != null) {
      imageResponse = patchImage("addImage", pickedFile.path, newUser.UserID, "uploads");
      imageResponse.then((profilePictureLink) async {
        var response = await updateUserProfilePicture(
            "updateUserProfilePicture", token, {"userID": newUser.UserID, "profilePictureLink": profilePictureLink});
        if (response == 200) {
          setState(() {
            imageCache.clear();
            imageCache.clearLiveImages();
            profilePictureFuture = getUserProfilePicture();
          });
        }
      });
    }
    setState(() {
      circularProgress = false;
    });
  }

  getUserProfilePicture() async {
    String token = await storage.read(key: "token");
    var result = await getUserProfilePictureFromServer("userProfilePicture", token, {"userID": newUser.UserID});
    setState(() {
      newUser.FirstName = result.data['data'][0]['FirstName'];
      updateUserNameCheck = false;
      newUser.Country = result.data['data'][0]['Country'];
      newUser.profilePictureLink = result.data['data'][0]['profilePictureLink'];
      newUser.Preference1=result.data['data'][0]['Preference1'];
      newUser.Preference2=result.data['data'][0]['Preference2'];
      newUser.Preference3=result.data['data'][0]['Preference3'];
      newUser.City=result.data['data'][0]['City'];
    });
  }
  updateStyle() async {
     setState(() {
       newUser.Preference1 = null;
       newUser.Preference2 = null;
       newUser.Preference3 = null;
     });
     String token = await storage.read(key: "token");
     var response;
     if(secondaryPreferencesList.length==3){
       response = await updatePreference("updatePreferences", token, {"userID": newUser.UserID, "preference1": secondaryPreferencesList[0], "preference2":secondaryPreferencesList[1], "preference3":secondaryPreferencesList[2]});
     }else if(secondaryPreferencesList.length==2){
       response = await updatePreference("updatePreferences", token, {"userID": newUser.UserID, "preference1": secondaryPreferencesList[0], "preference2":secondaryPreferencesList[1], "preference3":null});
     }else{
       response = await updatePreference("updatePreferences", token, {"userID": newUser.UserID, "preference1": secondaryPreferencesList[0], "preference2":null, "preference3":null});
     }

     if (response == 200) {
       setState(() {
         getUserProfilePicture();
       });
     }
  }

  updateName() async {
    setState(() {
      updateUserNameCheck = true;
    });
    String token = await storage.read(key: "token");
    var response = await updateUserName("updateUserName", token, {"userID": newUser.UserID, "firstname": nameController.text});
    if (response == 200) {
      setState(() {
        getUserProfilePicture();
      });
    }
  }

  updateLocation(city,country,streetAddress) async {
    setState(() {
      newUser.Country = null;
      newUser.City = null;
    });
    String token = await storage.read(key: "token");
    var response = await updateUserLocation("updateUserLocation", token, {"userID": newUser.UserID, "location": city,"street":streetAddress,"country":country});
    print(response);
    if (response == 200) {
      setState(() {
        getUserProfilePicture();
      });
    }
  }

  updatePreferences(preferences, String token) async {
    setState(() {
      newUser.Country = null;
    });
    String token = await storage.read(key: "token");
    var response = await updateUserLocation("updateUserLocation", token, {"userID": newUser.UserID, "location": newUser.City});
    if (response == 200) {
      setState(() {
        getUserProfilePicture();
      });
    }
  }

  getLinks() async {
    var result = await getLinksFromServer("findAllLinks");
    return result.data['data'];
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void dismissKeyboard() {
    focusNode.unfocus();
  }

  @override
  void initState() {
//    profilePictureFuture = getUserProfilePicture();
    pastEvents = getPastEvents();
    rankingFuture = getUserSpecificPreferences();
    linksFuture = getLinks();
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading ? Loading() : Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: [
                    Stack(children: [
                      newUser.profilePictureLink == null
                          ? Align(child: Loading2())
                          : Center(
                              child: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 120,
                                  backgroundImage: NetworkImage(newUser.profilePictureLink))),
                      Center(
                        child: Container(
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
                      ),
                    ]),
                    Positioned(
                      left: width * 0.8,
                      child: FloatingActionButton(
                        heroTag: "EditButton",
                        onPressed: () {
                          setState(() {
                            editProfile = !editProfile;
                          });
                        },
                        child: editProfile
                            ? Icon(Icons.check, color: Colors.black)
                            : Icon(Icons.edit, color: Colors.black),
                        backgroundColor: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 5),
                    editProfile
                        ? Positioned(
                            top: height * 0.18,
                            left: width * 0.78,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  updateProfilePicture();
                                });
                              },
                              child: ClipOval(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: Color(0xffdadada),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey, blurRadius: 5.0, offset: Offset(5.0, 5.0), spreadRadius: 5.0)
                                    ],
                                  ),
                                  height: 35.0,
                                  width: 35.0,
                                  child: Center(
                                    child: Icon(Icons.camera_alt, color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize:MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      editTitle
                          ? Container(
                              width:width/3,
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: TextField(
                                  focusNode: focusNode,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                  decoration: new InputDecoration.collapsed(hintText: 'User Name'),
                                  controller: nameController,
                                ),
                              ))
                          : updateUserNameCheck == true
                              ? Text(newUser.FirstName,
                                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 30))
                              : Text(newUser.FirstName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                      editProfile
                          ? GestureDetector(
                              onTap: () {
                                setState(() {
                                  editTitle = true;
                                  editProfile = false;
                                  nameController.text = newUser.FirstName;
                                });
                                showKeyboard();
                              },
                              child: ClipOval(
                                child: Container(
                                  decoration: new BoxDecoration(
                                    color: Color(0xffdadada),
                                    boxShadow: [
                                      BoxShadow(color: Colors.grey, blurRadius: 5.0, offset: Offset(5.0, 5.0), spreadRadius: 5.0)
                                    ],
                                  ),
                                  height: 35.0,
                                  width: 35.0,
                                  child: Center(
                                    child: Icon(Icons.edit, color: Colors.black),
                                  ),
                                ),
                              ),
                            )
                          : editTitle
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editTitle = false;
                                      updateName();
                                    });
                                    dismissKeyboard();
                                  },
                                  child: ClipOval(
                                    child: Container(
                                      decoration: new BoxDecoration(
                                        color: Color(0xffdadada),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey, blurRadius: 5.0, offset: Offset(5.0, 5.0), spreadRadius: 5.0)
                                        ],
                                      ),
                                      height: 35.0,
                                      width: 35.0,
                                      child: Center(
                                        child: Icon(Icons.check, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      newUser.Preference1 != null
                          ?GestureDetector(
                        onTap: () {
                          // setState(() {
                          //   sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {
                          //     updateStyle();
                          //   }));
                          // });
                        },
                            child: ClipOval(
                                  child: Container(
                                    child: UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 60,
                                      gradient: LinearGradient(
                                          end: const Alignment(0.0, -1),
                                          begin: const Alignment(0.0, 0.6),
                                          colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                      child:
                                          Flexible(
                                            child: Text(
                                              newUser.Preference1, textAlign: TextAlign.center,
                                            ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {
                                            updateStyle();
                                          }));
                                        });
                                      },
                                    ),
                                    height: width/4,
                                    width: width/4,
                                  ),
                                ),
                          )
                          : Loading2(),
                      SizedBox(width: 10),
                      newUser.Preference2 != null
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {
                              updateStyle();
                            }));
                          });
                        },
                            child: ClipOval(
                                child: Container(
                                  child: UnicornOutlineButton(
                                    strokeWidth: 2,
                                    radius: 60,
                                    gradient: LinearGradient(
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.6),
                                        colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                    child:
                                    Flexible(
                                      child: Text(newUser.Preference2, textAlign: TextAlign.center)
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {
                                          updateStyle();
                                        }));
                                      });
                                    },
                                  ),
                                  height: width/4,
                                  width: width/4,
                                ),
                              ),
                          )
                          : Container(),
                      SizedBox(width: 10),
                      newUser.Preference3 != null
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {
                              updateStyle();
                            }));
                          });
                        },

                            child: ClipOval(
                                child: Container(

                                  child: UnicornOutlineButton(
                                    strokeWidth: 2,
                                    radius: 60,
                                    gradient: LinearGradient(
                                        end: const Alignment(0.0, -1),
                                        begin: const Alignment(0.0, 0.6),
                                        colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                    child:
                                    Flexible(
                                        child: Text(newUser.Preference3, textAlign: TextAlign.center)
                                    ),
                                    onPressed: () {},
                                  ),
                                  height: width/4,
                                  width: width/4,
                                ),
                              ),
                          )
                          : Container(),
                      SizedBox(width: 2),

                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: rankingFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ClipOval(
                                    child: Container(

                                      color: Color(0xfff3aa3c),
                                      height: 35.0,
                                      width: 35.0,
                                      child: Center(child: Icon(Icons.whatshot)),
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Text("Journey", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                Column(
                                children: [
                                  Container(
                                    child: UnicornOutlineButton(
                                      strokeWidth: 2,
                                      radius: 60,
                                      gradient: LinearGradient(
                                          end: const Alignment(0.0, -1),
                                          begin: const Alignment(0.0, 0.6),
                                          colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                      child: RichText(
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                          children: <TextSpan>[
                                            TextSpan(text: snapshot.data[1].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30)),
                                            TextSpan(text: '\n Total', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                                          ],
                                        ),
                                      ),
                                      onPressed: () {},
                                    ),
                                    height: width/4,
                                    width: width/4,
                                  ),
                                ],
                              ),
                              ]
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      child: UnicornOutlineButton(
                                        strokeWidth: 2,
                                        radius: 60,
                                        gradient: LinearGradient(
                                            end: const Alignment(0.0, -1),
                                            begin: const Alignment(0.0, 0.6),
                                            colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: snapshot.data[0].toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30)),
                                              TextSpan(text: '\n Event', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                      height: width/4,
                                      width: width/4,
                                    ),
                                    // Text(snapshot.data[0].toString(),
                                    //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
                                    // Text("Events")
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Container(
                                      child: UnicornOutlineButton(
                                        strokeWidth: 2,
                                        radius: 60,
                                        gradient: LinearGradient(
                                            end: const Alignment(0.0, -1),
                                            begin: const Alignment(0.0, 0.6),
                                            colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                                children: <TextSpan>[
                                                  TextSpan(text: "#${snapshot.data[3].toString()}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30)),
                                                  TextSpan(text: '\n City', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                                                ],
                                              ),
                                            ),
                                        onPressed: () {},
                                      ),
                                      height: width/4,
                                      width: width/4,
                                    ),

                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Container(
                                      child: UnicornOutlineButton(
                                        strokeWidth: 2,
                                        radius: 60,
                                        gradient: LinearGradient(
                                            end: const Alignment(0.0, -1),
                                            begin: const Alignment(0.0, 0.6),
                                            colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]),
                                        child: RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(text: "#${snapshot.data[2].toString()}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30)),
                                              TextSpan(text: '\n' + "All Over", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10)),
                                            ],
                                          ),
                                        ),
                                        onPressed: () {},
                                      ),
                                      height: width/4,
                                      width: width/4,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                      else {
                        return Align(child: Loading2());
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                      newUser.Country == null || newUser.City==null ? Align(child: Loading2()) : Text(newUser.Country+", "+newUser.City),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          final kInitialPosition = LatLng(60.12816100000001, 18.643501);
                          return PlacePicker(
                            apiKey: "AIzaSyBG9rhs1LqFSbtMeYdWwhEZZtkaFIwKvnM", // Put YOUR OWN KEY here.
                            onPlacePicked: (result) {
                              var city;
                              var country;
                              var streetAddress;
                              var length = result.addressComponents.length;
                              for (int i = 0; i < length; i++) {
                                if (result.addressComponents[i].types[0] == 'country') {
                                  country = result.addressComponents[i].longName;
                                }
                                if (result.addressComponents[i].types[0] == 'locality' && city == null) {
                                  city = result.addressComponents[i].longName;
                                  //country= result.addressComponents[i].
                                } else if (result.addressComponents[i].types[0] == 'administrative_area_level_3' &&
                                    city == null) {
                                  city = result.addressComponents[i].longName;
                                } else if (result.addressComponents[i].types[0] == 'administrative_area_level_2' &&
                                    city == null) {
                                  city = result.addressComponents[i].longName;
                                } else if (result.addressComponents[i].types[0] == 'administrative_area_level_1' &&
                                    city == null) {
                                  city = result.addressComponents[i].longName;
                                }
                              }
                              Navigator.of(context).pop();
                              streetAddress = city+country+"";
                              updateLocation(city,country,streetAddress);
                            },
                            initialPosition: kInitialPosition,
                            useCurrentLocation: false,
                          );
                        }),
                      );
                    },
                    color: Color(0xffee7f40),
                    child: Text("Pick Location", style: TextStyle(color: Colors.white)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),                    ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Past events", style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                FutureBuilder(
                    future: pastEvents,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null &&
                          snapshot.data.length != 0) {
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
                      }
                      else if (snapshot.data != null && snapshot.data.length == 0) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: (){
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
                                  image: DecorationImage(image: AssetImage("assets/images/soempty.png"), fit: BoxFit.cover)),
                            ),
                          ),
                        );
                      }
                      else if (snapshot.data == null) {
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => Explore(newUser: newUser),
                                      transitionDuration: Duration(seconds: 0)));
                            },
                            child: Container(
                              height: 140,
                              width: width*0.85,
                              decoration: BoxDecoration(
                                  image: DecorationImage(image: AssetImage("assets/images/soempty.png"), fit: BoxFit.cover)),
                            ),
                          ),
                        );
                      }
                      else {
                        return Align(child: Loading2());
                      }
                    }),
                FutureBuilder(
                    future: linksFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text("Our Vision", style: TextStyle(color: Color(0xffFFA800))),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: FlatButton(
                                  onPressed: () {
                                    launch(snapshot.data[4]['link_value']);
                                  },
                                  child: Text("Feedback and Contact")),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: FlatButton(
                                  onPressed: () {
                                    launch(snapshot.data[2]['link_value']);
                                  },
                                  child: Text("Dance United Community Rules")),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: FlatButton(
                                  onPressed: () {
                                    launch(snapshot.data[3]['link_value']);
                                  },
                                  child: Text("Dance United Website")),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text("Legal Notice", style: TextStyle(color: Color(0xffFFA800))),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: FlatButton(
                                  onPressed: () {
                                    launch(snapshot.data[0]['link_value']);
                                  },
                                  child: Text("Privacy Policy")),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              child: FlatButton(
                                  onPressed: () {
                                    launch(snapshot.data[1]['link_value']);
                                  },
                                  child: Text("Terms and Conditions of use")),
                            ),
                          ],
                        );
                      }
                      else if (snapshot.data == null) {
                        return Container();
                      } else {
                        return Align(child: Loading2());
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text("App Settings", style: TextStyle(color: Color(0xffFFA800))),
                ),
                FlatButton(
                    onPressed: () async {
                      setState(() => loading = true);
                      await storage.deleteAll();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setBool("sessionCheck", false);
                      prefs.setBool("sessionCheckFullScreen", false);
                      await prefs.remove("email");
                      await prefs.remove("password");
                      await prefs.remove("token");
                      Navigator.pushAndRemoveUntil(
                          context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                    },
                    child: Text("Logout"),
                    color: Colors.transparent),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: FlatButton(
                      onPressed: () {
                        deleteAccount(context);
                      },
                      child: Text("Delete my account"),
                      color: Colors.transparent),
                )
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
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => HomeScreen(newUser: newUser), transitionDuration: Duration(seconds: 0)));
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
