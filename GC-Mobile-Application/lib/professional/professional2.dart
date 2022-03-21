import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_app/Custom%20Classes/Gradient_Border.dart';
import 'package:united_app/first.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/model/promo.dart';
import 'package:united_app/professional/eventhost.dart';
import 'package:united_app/professional/fullscreenpromo.dart';
import 'package:united_app/professional/mainscreenpromo.dart';
import 'package:united_app/professional/newspromo.dart';
import 'package:united_app/professional/professionaleventdetailed.dart';
import 'package:image_picker/image_picker.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:async/async.dart';
import 'package:united_app/professional/professionalexplore.dart';
import 'package:united_app/professional/professionalhome.dart';
import 'package:united_app/professional/professionalspecialevents.dart';
import 'package:united_app/shared/SharedMethods.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Professional2 extends StatefulWidget {
  final ProfessionalUser proUser;
  Professional2({this.proUser});

  @override
  State<StatefulWidget> createState() {
    return Professional2State(proUser);
  }
}

class Professional2State extends State<Professional2> {
  ProfessionalUser proUser = new ProfessionalUser();
  Professional2State(this.proUser);

  final storage = new FlutterSecureStorage();
  int _currentIndex = 2;

  Future future;
  Future externalPromosFuture;

  bool mainOptions = true;
  bool secondaryOptions = true;

  bool upcomingEvents = true;
  bool about = false;
  bool startPromos = false;
  bool activePromos = false;

  bool editProfile = false;
  bool editTitle = false;
  bool editName = false;
  Future linksFuture;

  bool profilePictureUpdateCheck = false;

  var imageResponse;
  PickedFile pickedFile;
  bool showDetails = false;
  bool circularProgress = false;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController titleController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<String> secondaryPreferencesList = new List();
  List<Preferences> preferencesList = new List();
  MultiSelectController controller = new MultiSelectController();

  bool artistCheckBoxValue = false;
  bool danceSchoolCheckBoxValue = false;
  bool eventOrganiserCheckBoxValue = false;

  Future professionalUserFuture;

  bool checkBoxValue = false;
  bool loading = false;
  bool updateUserNameCheck = false;
  bool updateDescriptionCheck = false;
  bool updateDescription = false;
  FocusNode focusNode;
  List<Event> dbEvents = new List();
  bool emptyEvents = false;

  SharedMethods sh = new SharedMethods();

  updateProfessionalPreference() async {
    // setState(() {
    //   proUser.Preference1 = null;
    //   proUser.Preference2 = null;
    //   proUser.Preference3 = null;
    // });

    String token = await storage.read(key: "token");
    var response;

    if(secondaryPreferencesList.length==3){
       await updateProfessionalUserPreference("updateProfessionalUserPreferences", token, {"userID": proUser.UserID, "preference1": secondaryPreferencesList[0], "preference2":secondaryPreferencesList[1], "preference3":secondaryPreferencesList[2]});
    }else if(secondaryPreferencesList.length==2){
     await updateProfessionalUserPreference("updateProfessionalUserPreferences", token, {"userID": proUser.UserID, "preference1": secondaryPreferencesList[0], "preference2":secondaryPreferencesList[1], "preference3":null});
    }else if(secondaryPreferencesList.length==1){
      await updateProfessionalUserPreference("updateProfessionalUserPreferences", token, {"userID": proUser.UserID, "preference1": secondaryPreferencesList[0], "preference2":null, "preference3":null});
    } else {
     await updateProfessionalUserPreference("updateProfessionalUserPreferences", token, {"userID": proUser.UserID, "preference1": null, "preference2":null, "preference3":null});
    }
    var result = await postprofessionalStyles("addProfessionalStyles", {"userId":  proUser.UserID, "styles":secondaryPreferencesList});
    print("result from post style");
    print(result.data);
    // response = await updateProfessionalUserPreference("updateProfessionalUserPreferences", token, {"userID": proUser.UserID, "preference1": null, "preference2":null, "preference3":null});

      response=result;
    if (response == 200) {
      setState(() {
        getProfessionalUser();
      });
    }
  }


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
                    await storage.delete(key: "professionalToken");
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.clear();
                    setState(() => loading = false);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
                  },
                  color: Color(0xffFFA800),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Color(0xffFFA800))),
                ),
                SizedBox(height: 30),
                FlatButton(
                    onPressed: () {
                      setState(() => loading = false);
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
                            String token = await storage.read(key: "professionalToken");
                            var result =
                                await deleteProfessionalAccount("deleteProfessionalAccount", token, {"userID": proUser.UserID});
                            if (result == 200) {
                              await storage.deleteAll();
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

  calenderViewPopUp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200,
                    width: 400,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: (pickedFile == null && proUser.calenderViewLink == null)
                            ? AssetImage("assets/images/image_placeholder.jpg")
                            : (pickedFile != null && proUser.calenderViewLink == null)
                                ? FileImage(File(pickedFile.path))
                                : (pickedFile == null && proUser.calenderViewLink != null)
                                    ? NetworkImage(proUser.calenderViewLink)
                                    : FileImage(File(pickedFile.path)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  circularProgress
                      ? Loading2()
                      : FlatButton(
                          child: Text("Upload Calendar"),
                          color: Colors.transparent,
                          onPressed: () async {
                            final picked = await imagePicker.getImage(source: ImageSource.gallery);
                            setState(() {
                              pickedFile = picked;
                            });
                            setState(() {
                              circularProgress = true;
                            });
                            if (pickedFile != null) {
                              imageResponse = patchImage("addImage", pickedFile.path, proUser.UserID, "professionalCalendarView");
                              imageResponse.then((calendarViewLink) async {
                                print(calendarViewLink);
                                var response = await saveCalendarViewLink(
                                    "saveCalendarViewLink", {"userID": proUser.UserID, "calendarViewLink": calendarViewLink});
                                if (response == 200) {
                                  setState(() {
                                    imageCache.clear();
                                    imageCache.clearLiveImages();
                                    professionalUserFuture = getProfessionalUser();
                                    Navigator.pop(context);
                                  });
                                }
                              });
                            }
                            setState(() {
                              circularProgress = false;
                            });
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.black)),
                          padding: EdgeInsets.symmetric(horizontal: 60),
                        ),
                ],
              ),
              actions: [
                RaisedButton(
                  child: Text("Done"),
                  color: Colors.amber,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            );
          });
        }).then((value) => setState(() {}));
  }

  updateProfilePicture() async {
    final picked = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = picked;
    });
    setState(() {
      circularProgress = true;
    });
    if (pickedFile != null) {
      imageResponse = patchImage("addImage", pickedFile.path, proUser.UserID, "uploads");
      imageResponse.then((profilePictureLink) async {
        var response =
            await saveProfilePicture("profilePicture", {"userID": proUser.UserID, "profilePictureLink": profilePictureLink});
        if (response == 200) {
          setState(() {
            imageCache.clear();
            imageCache.clearLiveImages();
            getProfessionalUser();
            //profilePictureUpdateCheck = false;
          });
        }
      });
    }
    setState(() {
      circularProgress = false;
    });
  }

  updateSecondaryProfilePicture() async {
    setState(() {
      proUser.secondaryProfilePictureLink = null;
    });
    final picked = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = picked;
    });
    setState(() {
      circularProgress = true;
    });
    if (pickedFile != null) {
      imageResponse = patchImage("addImage", pickedFile.path, proUser.UserID + "1", "uploads");
      imageResponse.then((secondaryProfilePictureLink) async {
        var response = await saveSecondaryProfilePicture(
            "secondaryProfilePicture", {"userID": proUser.UserID, "secondaryProfilePictureLink": secondaryProfilePictureLink});
        if (response == 200) {
          setState(() {
            imageCache.clear();
            imageCache.clearLiveImages();
            getProfessionalUser();
          });
        }
      });
    }
    setState(() {
      circularProgress = false;
    });
  }

  updateTitle() async {
    setState(() {
      updateUserNameCheck = true;
    });
    var response = await saveTitle("updateTitle", {"userID": proUser.UserID, "title": titleController.text});
    if (response == 200) {
      setState(() {
        updateUserNameCheck = false;
        getProfessionalUser();
      });
    }
  }

  updateName() async {
    setState(() {
      updateUserNameCheck = true;
    });
    var response = await saveName("updateName", {"userID": proUser.UserID, "name": titleController.text});
    if (response == 200) {
      setState(() {
        updateUserNameCheck = false;
        getProfessionalUser();
      });
    }
  }

  updateUserDescription() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var backStageCode = prefs.getString('backStageCode');
    var professionalToken = prefs.getString('professionalToken');
    setState(() {
      updateDescriptionCheck = true;
    });
    var response = await saveDescription(
        "editDescription", professionalToken, {"userID": proUser.UserID, "description": descriptionController.text});
    if (response == 200) {
      setState(() {
        print("description updated");
        getProfessionalUser();
      });
    }
  }

  updateLocation(city,country,streetAddress) async {

    String token = await storage.read(key: "professionalToken");
    var response = await updateProfessionalUserLocation(
        "updateProUserLocation", token, {"userID": proUser.UserID, "location": proUser.StreetAddress, "Country": country, "City":city});
    if (response == 200) {
      setState(() {
        professionalUserFuture = getProfessionalUser();
        proUser.City = city;
        proUser.Country = country;
      });
    }

  }

  getProfessionalUser() async {
    String token = await storage.read(key: "token");


    var result = await getProfessionalUserFromServer("getProfessionalUser", proUser.backStageCode);
    if (result.data['status'] == true) {
      setState(() {
        proUser.UserID = result.data['data'][0]['userID'];
        proUser.FirstName = result.data['data'][0]['firstName'];
        proUser.LastName = result.data['data'][0]['lastName'];
        proUser.title = result.data['data'][0]['title'];
        proUser.username = result.data['data'][0]['username'];
        proUser.password = result.data['data'][0]['password'];
        proUser.Email = result.data['data'][0]['email'];
        proUser.StreetAddress = result.data['data'][0]['streetAddress'];
        proUser.City = result.data['data'][0]['city'];
        proUser.Country = result.data['data'][0]['country'];
        proUser.profilePictureLink = result.data['data'][0]['profilePictureLink'];
        proUser.secondaryProfilePictureLink = result.data['data'][0]['secondaryProfilePictureLink'];
        proUser.calenderViewLink = result.data['data'][0]['calenderViewLink'];
        proUser.backStageCode = result.data['data'][0]['backStageCode'];
        proUser.description = result.data['data'][0]['description'];
        proUser.Preference1 = result.data['data'][0]['preference1'];
         proUser.Preference2 = result.data['data'][0]['preference2'];
         proUser.Preference3 = result.data['data'][0]['preference3'];

      });
    }
    print("this is the updated stuff");
    print(proUser.City);
    print(proUser.Country);

    var resultget= await getprofessionalStyles("getProfessionalStyles", token,{"userID": proUser.UserID});
    print("get style from api");
    print(proUser.UserID);
    print(resultget.data);
    print(resultget.data["styles"]);
    updateSecondarypreferenceArray();
    return proUser;
  }

  community(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Community?",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: artistCheckBoxValue,
                          onChanged: (bool value) {
                            setState(() {
                              artistCheckBoxValue = value;
                            });
                          }),
                      Text("Artist")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: danceSchoolCheckBoxValue,
                          onChanged: (bool value) {
                            setState(() {
                              danceSchoolCheckBoxValue = value;
                            });
                          }),
                      Text("Dance School")
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: eventOrganiserCheckBoxValue,
                          onChanged: (bool value) {
                            setState(() {
                              eventOrganiserCheckBoxValue = value;
                            });
                          }),
                      Text("Event Organiser")
                    ],
                  ),
                ],
              ),
              actions: [
                RaisedButton(
                  child: Text("done"),
                  color: Colors.amber,
                  onPressed: () {},
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                  padding: EdgeInsets.all(8.0),
                ),
              ],
            );
          });
        });
  }

  getLinks() async {
    var result = await getLinksFromServer("findAllLinks");
    return result.data['data'];
  }

  updateSecondarypreferenceArray() async {

    if (proUser.Preference1 != null){
      if((proUser.Preference1==proUser.Preference2)&&(proUser.Preference1==proUser.Preference3)){
        secondaryPreferencesList.add(null);
      }
      else {
        secondaryPreferencesList.add(proUser.Preference1);
      }
    }
    if (proUser.Preference2 != null){
      if((proUser.Preference2==proUser.Preference1)&&(proUser.Preference2==proUser.Preference3)){
        secondaryPreferencesList.add(null);
      }else{
      secondaryPreferencesList.add(proUser.Preference2);}

    }
    if (proUser.Preference3 != null){
      if((proUser.Preference3==proUser.Preference1)&&(proUser.Preference3==proUser.Preference2)){
        secondaryPreferencesList.add(null);
      }
     else{
        secondaryPreferencesList.add(proUser.Preference3);
      }
    }


  }

  @override
  void initState() {
    linksFuture = getLinks();
    externalPromosFuture = sh.getAllPromos(context, proUser.UserID);
    professionalUserFuture = getProfessionalUser();
    future = sh.getProUserEvents(proUser, dbEvents);
    super.initState();
  }

  void showKeyboard() {
    focusNode.requestFocus();
  }

  void dismissKeyboard() {
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 20),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: [
                          Stack(
                            children: [
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
                              Stack(children: [
                                Center(
                                    child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 120,
                                        backgroundImage: NetworkImage(proUser.profilePictureLink))),
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
                                profilePictureUpdateCheck == true ? Align(child: Loading2()) : Container(),
                              ]),
                              editProfile
                                  ? Positioned(
                                      top: height * 0.2,
                                      left: width * 0.78,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            profilePictureUpdateCheck = true;
                                            updateProfilePicture();
                                          });
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            decoration: new BoxDecoration(
                                              color: Color(0xffdadada),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 5.0,
                                                    offset: Offset(5.0, 5.0),
                                                    spreadRadius: 5.0)
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
                              proUser.secondaryProfilePictureLink == null
                                  ? Align(child: Loading2())
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 190),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Stack(
                                            children: [
                                              Container(
                                                height: height * 0.2,
                                                width: height * 0.2,
                                                color: Colors.transparent,
                                              ),
                                              Positioned(
                                                top: width * 0.05,
                                                left: width * 0.05,
                                                child: Container(
                                                  height: height * 0.15,
                                                  width: height * 0.15,
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: NetworkImage(proUser.secondaryProfilePictureLink),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              editProfile
                                                  ? Positioned(
                                                      top: height * 0.07,
                                                      left: width * 0.23,
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          updateSecondaryProfilePicture();
                                                        },
                                                        child: ClipOval(
                                                          child: Container(
                                                            decoration: new BoxDecoration(
                                                              color: Color(0xffdadada),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.grey,
                                                                    blurRadius: 5.0,
                                                                    offset: Offset(5.0, 5.0),
                                                                    spreadRadius: 5.0)
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
                                        ],
                                      )),
                            ],
                          ),
                          Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    editTitle
                                        ? Container(
                                            width: 150,
                                            child: Padding(
                                              padding: const EdgeInsets.all(1.0),
                                              child: TextField(
                                                focusNode: focusNode,
                                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                                decoration: new InputDecoration.collapsed(hintText: 'Professional Title'),
                                                controller: titleController,
                                              ),
                                            ))
                                        //: proUser.title == null
                                        : updateUserNameCheck == true
                                            ? Center(
                                                child: Container(
                                                    width: width - 40,
                                                    child: Text(proUser.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 30))),
                                              )
                                            : Center(
                                                child: Container(
                                                    width: width - 40,
                                                    child: Text(proUser.title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 30))),
                                              ),
                                    editProfile
                                        ? GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                editTitle = true;
                                                titleController.text = proUser.FirstName;
                                                editProfile = false;
                                              });
                                              showKeyboard();
                                            },
                                            child: ClipOval(
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: Color(0xffdadada),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 5.0,
                                                        offset: Offset(5.0, 5.0),
                                                        spreadRadius: 5.0)
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
                                                    updateTitle();
                                                  });
                                                  dismissKeyboard();
                                                },
                                                child: ClipOval(
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                      color: Color(0xffdadada),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 5.0,
                                                            offset: Offset(5.0, 5.0),
                                                            spreadRadius: 5.0)
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    editName
                                        ? Container(
                                            width: 150,
                                            child: TextField(
                                              controller: nameController,
                                            ))
                                        : Text("Event Organizer"),
                                    editProfile
                                        ? Container()
//                                  ? GestureDetector(
//                                      onTap: () {
//                                        setState(() {
//                                          editName = true;
//                                          editProfile = false;
//                                        });
////                                    updateName();
//                                        community(context);
//                                      },
//                                      child: ClipOval(
//                                        child: Container(
//                                          decoration: new BoxDecoration(
//                                            color: Color(0xffdadada),
//                                            boxShadow: [
//                                              BoxShadow(
//                                                  color: Colors.grey,
//                                                  blurRadius: 5.0,
//                                                  offset: Offset(5.0, 5.0),
//                                                  spreadRadius: 5.0)
//                                            ],
//                                          ),
//                                          height: 35.0,
//                                          width: 35.0,
//                                          child: Center(
//                                            child: Icon(Icons.edit, color: Colors.black),
//                                          ),
//                                        ),
//                                      ),
//                                    )
                                        : editName
                                            ? GestureDetector(
                                                onTap: () {
                                                  updateName();
                                                  setState(() {
                                                    editName = false;
                                                  });
                                                },
                                                child: ClipOval(
                                                  child: Container(
                                                    decoration: new BoxDecoration(
                                                      color: Color(0xffdadada),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.grey,
                                                            blurRadius: 5.0,
                                                            offset: Offset(5.0, 5.0),
                                                            spreadRadius: 5.0)
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
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RaisedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return EventHost(proUser: proUser);
                                  }));
                                },
                                color: Color(0xffee7f40),
                                child: Text("create event", style: TextStyle(color: Colors.white)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                              ),
                            ],
                          ),
                          proUser.calenderViewLink != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Container(
                                    height: 200,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(proUser.calenderViewLink),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  mainOptions = true;
                                  upcomingEvents = true;
                                  about = false;
                                  startPromos = false;
                                  activePromos = false;
                                });
                              },
                              child: Text("Profile",
                                  style: TextStyle(fontSize: 20, color: mainOptions ? Color(0xffFFA901) : Colors.black))),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  mainOptions = false;
                                  upcomingEvents = false;
                                  about = false;
                                  startPromos = true;
                                  activePromos = false;
                                });
                              },
                              child: Text("Marketing",
                                  style: TextStyle(fontSize: 20, color: !mainOptions ? Color(0xffFFA901) : Colors.black)))
                        ],
                      ),
                      mainOptions
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                  onPressed: () {
                                    setState(() {
                                      upcomingEvents = true;
                                      about = false;
                                      startPromos = false;
                                      activePromos = false;
                                    });
                                  },
                                  child: Text("Upcoming Events",
                                      style: TextStyle(color: upcomingEvents ? Color(0xffFFA901) : Colors.black)),
                                ),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        upcomingEvents = false;
                                        about = true;
                                        startPromos = false;
                                        activePromos = false;
                                      });
                                    },
                                    child: Text("About", style: TextStyle(color: about ? Color(0xffFFA901) : Colors.black))),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        upcomingEvents = false;
                                        about = false;
                                        startPromos = true;
                                        activePromos = false;
                                      });
                                    },
                                    child: Text("Start Promos",
                                        style: TextStyle(color: startPromos ? Color(0xffFFA901) : Colors.black))),
                                FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        upcomingEvents = false;
                                        about = false;
                                        startPromos = false;
                                        activePromos = true;
                                      });
                                    },
                                    child: Text("Active Promos",
                                        style: TextStyle(color: activePromos ? Color(0xffFFA901) : Colors.black))),
                              ],
                            ),
                      mainOptions && upcomingEvents
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                            return EventHost(proUser: proUser);
                                          }));
                                        },
                                        color: Color(0xffee7f40),
                                        child: Text("create event", style: TextStyle(color: Colors.white)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                      ),
                                    ),
                                  ],
                                ),
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
                                                            event: snapshot.data[index], proUser: proUser);
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
                                                              // Align(
                                                              //     alignment: Alignment.centerRight, // Align however you like (i.e .centerRight, centerLeft)
                                                              //     child:
                                                              //     // Text(snapshot.data[index].startTime, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
                                                              // ),
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
                                    }),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
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
                                          } else if (snapshot.data == null) {
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
                                          await storage.delete(key: "professionalToken");
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          prefs.setBool("sessionCheck", false);
                                          prefs.setBool("sessionCheckFullScreen", false);
                                          await prefs.remove("backStageCode");
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
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Container(),
                      mainOptions && about
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Location", style: TextStyle(color: Color(0xffFFA800), fontSize: 15, fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  child: Text("Helpful if you have a dance school."),
                                ),
                                FutureBuilder(
                                    future: professionalUserFuture,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('[' + snapshot.data.StreetAddress + ']'),
                                            ],
                                          ),
                                        );
                                      } else if (snapshot.data == null) {
                                        return Container();
                                      } else if (snapshot.data == null) {
                                        Fluttertoast.showToast(
                                            msg: "Something is wrong - please try again later",
                                            toastLength: Toast.LENGTH_SHORT,
                                            backgroundColor: Colors.black);
                                        return null;
                                      } else {
                                        return Align(child: Loading2());
                                      }
                                    }),
                                SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          final kInitialPosition = LatLng(-33.8567844, 151.213108);
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


                                              proUser.StreetAddress = result.formattedAddress;
                                              Navigator.of(context).pop();
                                              updateLocation(city,country,streetAddress);

                                            },
                                            initialPosition: kInitialPosition,
                                            useCurrentLocation: true,
                                          );
                                        }),
                                      );
                                    },
                                    color: Color(0xffee7f40),
                                    child: Text("Pick Location", style: TextStyle(color: Colors.white)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),                                    ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                  child: Divider(
                                    color: Color(0xfff4aa3c),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Upload Schedule", style: TextStyle(color: Color(0xffFFA800), fontSize: 15, fontWeight: FontWeight.bold)),

                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Helpful if you have a dance school or give classes"),
                                ),
                                SizedBox(height: 10),

                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      RaisedButton(
                                        onPressed: () {
                                          calenderViewPopUp(context);
                                        },
                                        color: Color(0xffee7f40),
                                        child: Text("Upload schedule", style: TextStyle(color: Colors.white)),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                  child: Divider(
                                    color: Color(0xfff4aa3c),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("Styles", style: TextStyle(color: Color(0xffFFA800), fontSize: 15, fontWeight: FontWeight.bold)),

                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Text("What dances do you offer?"),
                                ),
                                SizedBox(height: 10),
                                secondaryPreferencesList.length == 0
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                        child: RaisedButton(
                                          onPressed: () {
                                            sh
                                                .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                .then((value) => setState(() {
                                                  updateProfessionalPreference();
                                            }));
                                          },
                                          color: Color(0xffee7f40),
                                          child: Text("choose your styles", style: TextStyle(color: Colors.white)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                        ),
                                      )
                                    :
                                secondaryPreferencesList.length == 1
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {},
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();
                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Center(child: Icon(Icons.add)),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                    : secondaryPreferencesList.length == 2
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Text(secondaryPreferencesList[1], textAlign: TextAlign.center),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        // onTap: () {
                                        //   sh
                                        //       .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                        //       .then((value) => setState(() {}));
                                        // },
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Center(child: Icon(Icons.add)),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                                    :
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        // onTap: () {
                                        //   sh
                                        //       .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                        //       .then((value) => setState(() {}));
                                        // },
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Text(secondaryPreferencesList[1], textAlign: TextAlign.center),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: ClipOval(
                                          child: Container(
                                            child: UnicornOutlineButton(
                                              strokeWidth: 2,
                                              radius: 60,
                                              gradient: LinearGradient(
                                                  end: const Alignment(0.0, -1),
                                                  begin: const Alignment(0.0, 0.6),
                                                  colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                                              ),
                                              child: Text(secondaryPreferencesList[2], textAlign: TextAlign.center),
                                              onPressed: () {
                                                setState(() {
                                                  sh
                                                      .filtersPopUp(context, preferencesList, secondaryPreferencesList)
                                                      .then((value) => setState(() {
                                                    updateProfessionalPreference();

                                                  }));
                                                });
                                              },
                                            ),
                                            height: 75,
                                            width: 75,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
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
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (updateDescription == true) {
                                            //dismissKeyboard();
                                            updateUserDescription();
                                            updateDescription = false;
                                          } else {
                                            updateDescription = true;
                                            //showKeyboard();
                                          }
                                        });
                                      },
                                      child: updateDescription
                                          ? ClipOval(
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: Color(0xffdadada),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 5.0,
                                                        offset: Offset(5.0, 5.0),
                                                        spreadRadius: 5.0)
                                                  ],
                                                ),
                                                height: 35.0,
                                                width: 35.0,
                                                child: Center(
                                                  child: Icon(Icons.check, color: Colors.black),
                                                ),
                                              ),
                                            )
                                          : ClipOval(
                                              child: Container(
                                                decoration: new BoxDecoration(
                                                  color: Color(0xffdadada),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey,
                                                        blurRadius: 5.0,
                                                        offset: Offset(5.0, 5.0),
                                                        spreadRadius: 5.0)
                                                  ],
                                                ),
                                                height: 35.0,
                                                width: 35.0,
                                                child: Center(
                                                  child: Icon(Icons.edit, color: Colors.black),
                                                ),
                                              ),
                                            ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  child: updateDescription
                                      ? Container(
                                          width: width / 3,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: TextField(
                                              focusNode: focusNode,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(color: Colors.black, fontSize: 10),
                                              decoration: new InputDecoration.collapsed(hintText: 'Description'),
                                              controller: descriptionController,
                                            ),
                                          ))
                                      : updateUserNameCheck == true
                                          ? Text(proUser.description, style: TextStyle(color: Colors.grey, fontSize: 14))
                                          : Text(proUser.description, style: TextStyle(fontSize: 14)),
                                ),
                              ],
                            )
                          : !mainOptions && startPromos
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Text("Choose Promotion", style: TextStyle(fontWeight: FontWeight.bold)),
                                    ),
                                    Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Stack(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                      return MainScreenPromo(proUser: proUser);
                                                    }));
                                                  },
                                                  child: Container(
                                                    height: height * 0.2,
                                                    width: width * 0.85,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xff900521),
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("News Promotion",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                        Text("Main Screen",
                                                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Stack(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                      return NewsPromo(proUser: proUser);
                                                    }));
                                                  },
                                                  child: Container(
                                                    height: height * 0.2,
                                                    width: width * 0.85,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xff900521),
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("Post Offer",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                        Text("Special Section",
                                                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 5),
                                            child: Stack(
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                                      return FullScreenPromo(proUser: proUser);
                                                    }));
                                                  },
                                                  child: Container(
                                                    height: height * 0.2,
                                                    width: width * 0.85,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xff900521),
                                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text("Full Screen Promo",
                                                            textAlign: TextAlign.center,
                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                                        Text("Advanced",
                                                            textAlign: TextAlign.center, style: TextStyle(color: Colors.white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: Row(
                                              children: [
                                                Text("Why promoting your offers?"),
                                                FlatButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      "Learn more",
                                                      style: TextStyle(color: Color(0xff900521)),
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              : !mainOptions && activePromos
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Text("Your active promotions", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        FutureBuilder(
                                            future: externalPromosFuture,
                                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                                              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                                return Container(
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      physics: NeverScrollableScrollPhysics(),
                                                      itemCount: snapshot.data.length,
                                                      itemBuilder: (context, index) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Card(
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(10),
                                                                ),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                        decoration: BoxDecoration(
                                                                            color: Colors.grey,
                                                                            borderRadius: BorderRadius.vertical(
                                                                                top: Radius.circular(10), bottom: Radius.zero)),
                                                                        width: double.infinity,
                                                                        height: height * 0.05,
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                                                                          child: Text(
                                                                            snapshot.data[index].offerTitle,
                                                                            style: TextStyle(
                                                                                fontSize: 20, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        )),
                                                                    Padding(
                                                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Column(
                                                                            children: [
                                                                              Container(
                                                                                height: height * 0.15,
                                                                                width: height * 0.25,
                                                                                decoration: BoxDecoration(
                                                                                  borderRadius:
                                                                                  BorderRadius.all(Radius.circular(10)),
                                                                                  image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: NetworkImage(
                                                                                        snapshot.data[index].promoImageUrl),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Column(
                                                                            children: [
                                                                              Text(
                                                                                snapshot.data[index].viewCounter.toString(),
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(
                                                                                    fontSize: 50, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              Text(
                                                                                "Engagements",
                                                                                textAlign: TextAlign.left,
                                                                                style: TextStyle(
                                                                                    fontSize: 10, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            ],
                                                                          ),

                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 10),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                );
                                              } else if (snapshot.data == null) {
                                                return Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                                  child: Card(
                                                      child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text("Don't miss this opportunity",
                                                            style: TextStyle(
                                                                color: Color(0xfff4aa3c),
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold)),
                                                        SizedBox(height: 20),
                                                        Text(
                                                            "Dance United is committed to create to most convinient way for dancers "
                                                            "to manage their activities",
                                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                        SizedBox(height: 20),
                                                        Text("We also help you to...",
                                                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                                      ],
                                                    ),
                                                  )),
                                                );
                                              } else {
                                                return Align(child: Loading2());
                                              }
                                            }),
                                      ],
                                    )
                                  : Container(),
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
                                pageBuilder: (_, __, ___) => ProfessionalHome(proUser: proUser),
                                transitionDuration: Duration(seconds: 0)));
                        break;
                      }
                    case 1:
                      {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (_, __, ___) => ProfessionalExplore(proUser: proUser),
                                transitionDuration: Duration(seconds: 0)));
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
                                pageBuilder: (_, __, ___) => ProfessionalSpecialEvents(proUser: proUser),
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
