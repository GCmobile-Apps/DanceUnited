import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:united_app/Custom%20Classes/Gradient_Border.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/model/event.dart';
import 'package:image_picker/image_picker.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/professional2.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:async/async.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:united_app/shared/SharedMethods.dart';

class NewEventDetails extends StatefulWidget {
  final Event newEvent;
  final ProfessionalUser proUser;
  final storage = new FlutterSecureStorage();
  NewEventDetails({this.newEvent, this.proUser});

  @override
  State<StatefulWidget> createState() {
    return NewEventDetailsState(newEvent, proUser);
  }
}

class NewEventDetailsState extends State<NewEventDetails> {
  Event newEvent;
  ProfessionalUser proUser;
  NewEventDetailsState(this.newEvent, this.proUser);
  final storage = new FlutterSecureStorage();
  var imageResponse;
  TimeOfDay currentTime;
  PickedFile pickedFile;
  bool circularProgress = false;
  TextEditingController textEditingController = new TextEditingController();
  final ImagePicker imagePicker = ImagePicker();

  final AsyncMemoizer memoizer = AsyncMemoizer();
  List<String> secondaryPreferencesList = new List();
  List<Preferences> preferencesList = new List();
  MultiSelectController controller = new MultiSelectController();

  bool monday = false;
  bool tuesday = false;
  bool wednesday = false;
  bool thursday = false;
  bool friday = false;
  bool saturday = false;
  bool sunday = false;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  String formattedStartTime;
  String formattedEndTime;

  DateTime endDate;
  String formattedEndDate;

  bool startTimeCheck = false;
  bool endTimeCheck = false;
  bool endDateCheck = false;
  bool eventImageCheck = false;
  bool locationCheck = false;
  bool descriptionCheck = false;

  bool createEventCheck = false;
  String ID="";

  SharedMethods sh= new SharedMethods();

  createEvent() async {
    newEvent.Prize = "No";
    setState(() {
      createEventCheck = true;
    });

    if (newEvent.SeriesEndDate == null){
      newEvent.SeriesEndDate = newEvent.EndDate;
    }

    print("This is new event");
    print(newEvent.toJson());
    var result = await createNewEvent("createNewEvent", {"event": newEvent.toJson(), "userID": proUser.UserID});
    final decoded = json.decode(result);
    ID= decoded['ID'];
    if(ID!=null){
       setState(() {
         createEventCheck = false;
       });
       postLocation();
       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Professional2(proUser: proUser)), (route) => false);
     }
  }

  postLocation() async {
    print(country);
    var result = await postEventCountry("addCountry", {"event": {"eventId":ID, "country":country}});

  }

  pickTime() async {
    TimeOfDay timeOfDay = await showTimePicker(
        context: context,
        initialTime: currentTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.cyan, //color you want at header
              buttonTheme: ButtonTheme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  secondary: Colors.cyan, // Color you want for action buttons (CANCEL and OK)
                ),
              ),
            ),
            child: child,
          );
        });
    if (timeOfDay != null) {
      setState(() {
        currentTime = timeOfDay;
      });
    }
    return timeOfDay;
  }


  void takePhoto(ImageSource source) async {
    final picked = await imagePicker.getImage(source: source);
    final bytes = (await picked.readAsBytes()).lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;

    if(mb < 1) {
      setState(() {
        pickedFile = picked;
      });
      setState(() {
        circularProgress = true;
      });
      if (pickedFile != null) {
        imageResponse = patchImage("addImage", pickedFile.path, newEvent.EventID, "eventImages");
        imageResponse.then((result) {
          newEvent.ImageUrl = result;
          setState(() {
            circularProgress = false;
          });
        });
      }
    }else{
      Fluttertoast.showToast(
          msg: "Image larger than 1MB not allowed",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
    }
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  @override
  void initState() {
    TimeOfDay _time = TimeOfDay.now();
    currentTime = TimeOfDay.now();
    print("current time");
    print(currentTime);
    formattedStartTime = formatTimeOfDay(currentTime);
    print("  formattedStartTime");
    print(formattedStartTime);
//    print(_time);
//    currentTime = _time.replacing(
//        hour: _time.hour + 0,
//        minute: _time.minute
//    );
    formattedEndTime = formatTimeOfDay(currentTime);
    print("formattedEndTime");
    print(formattedEndTime);
    endDate = new DateFormat("yyyy-MM-dd").parse(newEvent.StartDate);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(endDate);
    print(formatted);
    print("endDate");
    print(endDate);
    newEvent.startTime = formattedStartTime;
    print("newEvent.startTime ");
    print(newEvent.startTime );
    newEvent.endTime = formattedEndTime;
    print("newEvent.endTime ");
    print(newEvent.endTime);
    newEvent.EndDate = DateFormat('yyyy-MM-dd').format(endDate);
    print(" newEvent.EndDate  ");
    print( newEvent.EndDate );
    formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
    print(" formattedEndDate ");
    print( formattedEndDate);
    super.initState();
  }

  var country;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(newEvent.Title,
                                style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.bold)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Text(newEvent.Type, style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("Event Calendar image", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                    Text("This is how it will look in the calendar", style: TextStyle(fontSize: 12, color: Colors.black)),
                    SizedBox(height: 20),
                    Stack(
                      children: [
                        Container(
                          height: height * 0.18,
                          width: width * 0.9,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget> [
                                FlatButton(
                                    onPressed: () {
                                      takePhoto(ImageSource.gallery);
                                    },
                                    child: Text("Add preview picture", style: TextStyle(fontSize: 15, color: Colors.white))),
                              ],
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: pickedFile == null
                                  ? AssetImage("assets/images/transparwent.jpeg")
                                  : FileImage(File(pickedFile.path)),
                              fit: BoxFit.cover,
                            ),
                            gradient: LinearGradient(
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                              colors: [
                                const Color(0xffFF3F58).withOpacity(0.6),
                                const Color(0xffffc135).withOpacity(0.9),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text("Main style", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                    Text("category in the event calendar", style: TextStyle(fontSize: 12, color: Colors.black)),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: ClipOval(
                        child: Container(
                          child: UnicornOutlineButton(
                            strokeWidth: 2,
                            radius: 100,
                            gradient: LinearGradient(colors: [Color(0xFFFFE600), Color(0xFFFFE600)]),
                            child: Text(newEvent.Tags, textAlign: TextAlign.center),
                            onPressed: () {
                              setState(() {
                              });
                            },
                          ),
                          height: 75,
                          width: 75,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    Text("Related style(s)", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                    Text("help more people to find your event", style: TextStyle(fontSize: 12, color: Colors.black)),                      SizedBox(height: 20),
                    secondaryPreferencesList.length == 0
                        ? GestureDetector(
                      onTap: () {
                        sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                      },
                      child: ClipOval(
                        child: Container(
                          child: UnicornOutlineButton(
                            strokeWidth: 2,
                            radius: 100,
                            gradient: LinearGradient(colors: [Color(0xFFFFE600), Color(0xFFFFE600)]),
                            child: Center(child: Icon(Icons.add)),
                            onPressed: () {
                              setState(() {
                                sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));

                              });
                            },
                          ),
                          height: 75,
                          width: 75,
                        ),
                      ),
                    )
                        : secondaryPreferencesList.length == 1
                        ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xFFFFE600), Color(0xFFFFE600)]),
                                child: Center(child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center)),
                                onPressed: () {
                                  setState(() {
                                  });
                                },
                              ),
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                          },
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xFFFFE600), Color(0xFFFFE600)]),
                                child: Center(child: Icon(Icons.add)),
                                onPressed: () {
                                    sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));

                                },
                              ),
                              height: 75,
                              width: 75,
                            ),
                          ),
                        )
                      ],
                    )
                        : secondaryPreferencesList.length == 2
                        ? Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                          },
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]),
                                child: Center(child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center)),
                                onPressed: () {
                                    sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                    },
                              ),
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                        SizedBox(height: 40),
                        GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]),
                                child: Center(child: Text(secondaryPreferencesList[1], textAlign: TextAlign.center)),
                                onPressed: () {
                                  setState(() {
                                  });
                                },
                              ),
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                          },
                          child: ClipOval(
                            child: Container(
                              height: 75,
                              width: 75,
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]),
                                child: Center(child: Icon(Icons.add)),
                                onPressed: () {
                                    sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                    },
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                        : Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                          },
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]),
                                child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center),
                                onPressed: () {
                                  sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));

                                },
                              ),
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]),
                                child: Text(secondaryPreferencesList[1], textAlign: TextAlign.center),
                                onPressed: () {
                                  setState(() {
                                  });
                                },
                              ),
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {},
                          child: ClipOval(
                            child: Container(
                              child: UnicornOutlineButton(
                                strokeWidth: 2,
                                radius: 100,
                                gradient: LinearGradient(colors: [Color(0xfffdb602), Color(0xfffdb602)]),
                                child: Text(secondaryPreferencesList[2], textAlign: TextAlign.center),
                                onPressed: () {
                                  setState(() {
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
                    SizedBox(height: 40),
                    Row(
                        children: [
                          Text("Event Location", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                        ]
                    ),
                    SizedBox(height: 20),

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  final kInitialPosition = LatLng(60.12816100000001, 18.643501);
                                  return PlacePicker(
                                    apiKey: "AIzaSyBG9rhs1LqFSbtMeYdWwhEZZtkaFIwKvnM", // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) {
                                      setState(() {
                                        var EventLocation;
                                        var length2 = result.addressComponents.length;
                                        for (int i = 0; i < length2; i++) {
                                          if (result.addressComponents[i].types[0] == 'country') {
                                            country = result.addressComponents[i].longName;
                                          }
                                          if (result.addressComponents[i].types[0] == 'locality' && EventLocation == null) {
                                            EventLocation = result.addressComponents[i].longName;
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_3' &&
                                              EventLocation == null) {
                                            EventLocation = result.addressComponents[i].longName;
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_2' &&
                                              EventLocation == null) {
                                            EventLocation = result.addressComponents[i].longName;
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_1' &&
                                              EventLocation == null) {
                                            EventLocation = result.addressComponents[i].longName;
                                          }
                                        }

                                        newEvent.CompleteAddress = result.formattedAddress;

                                        if (EventLocation == null){
                                          newEvent.Location = country;
                                        }
                                        else{
                                          newEvent.Location = EventLocation;
                                        }
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    initialPosition: kInitialPosition,
                                    useCurrentLocation: false,
                                  );
                                }),
                              );
                            },
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                            color: Color(0xfffdb602),
                            child: Text("Pick Location", style: TextStyle(color: Colors.white)
                            ),
                        ),
                        )
                      ],
                    ),
                    newEvent.Location == null
                        ? Container()
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(newEvent.CompleteAddress),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Text("Event serie", style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold)),
                    Text("Is this event repeating at a specific day?", style: TextStyle(fontSize: 12, color: Colors.black)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Start"),
                        Text(
                            DateFormat('EEEE').format(DateTime.parse(newEvent.StartDate))+", "
                                +
                            DateFormat('dd').format(new DateFormat("yyyy-MM-dd").parse(newEvent.StartDate)) + " " +
                            new DateFormat.MMMM().format(new DateFormat("yyyy-MM-dd").parse(newEvent.StartDate)) + " " +
                            DateFormat('yyyy').format(new DateFormat("yyyy-MM-dd").parse(newEvent.StartDate))
                            ,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                var timeResponse = pickTime();
                                timeResponse.then((result) {
                                  startTime = result;
                                  formattedStartTime = formatTimeOfDay(startTime);
                                  newEvent.startTime = formattedStartTime;
                                });
                              });
                            },
                            child: Text(formattedStartTime))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("End"),
                        FlatButton(
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: new DateFormat("yyyy-MM-dd").parse(newEvent.StartDate),
                                    firstDate: new DateFormat("yyyy-MM-dd").parse(newEvent.StartDate),
                                    lastDate: DateTime(3000))
                                .then((value) => setState(() {
                                      endDate = value;
                                      formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
                                      newEvent.EndDate = formattedEndDate;
                                    }));
                          },
                          child: Text(DateFormat('EEEE').format(DateTime.parse(newEvent.EndDate))+", "+
                              DateFormat('dd').format(new DateFormat("yyyy-MM-dd").parse(newEvent.EndDate)) + " " +
                              new DateFormat.MMMM().format(new DateFormat("yyyy-MM-dd").parse(newEvent.EndDate)) + " " +
                              DateFormat('yyyy').format(new DateFormat("yyyy-MM-dd").parse(newEvent.EndDate))
                              ,
                              style: TextStyle(fontWeight: FontWeight.bold)),

                        ),
                        FlatButton(
                            onPressed: () {
                              setState(() {
                                var timeResponse = pickTime();
                                timeResponse.then((result) {
                                  endTime = result;
                                  formattedEndTime = formatTimeOfDay(endTime);
                                  newEvent.endTime = formattedEndTime;
                                });
                              });
                            },
                            child: Text(formattedEndTime))
                      ],
                    ),
                    newEvent.notRepeat == null ? Text("does not repeat") : Text("repeats every ${newEvent.notRepeat}"),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              monday = !monday;
                              tuesday = false;
                              wednesday = false;
                              thursday = false;
                              friday = false;
                              saturday = false;
                              sunday = false;
                              if (monday) {
                                newEvent.notRepeat = "Monday";
                              } else if (!monday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: monday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('Mo')),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tuesday = !tuesday;
                              monday = false;
                              wednesday = false;
                              thursday = false;
                              friday = false;
                              saturday = false;
                              sunday = false;
                              if (tuesday) {
                                newEvent.notRepeat = "Tuesday";
                              } else if (!tuesday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: tuesday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('Tu')),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              wednesday = !wednesday;
                              tuesday = false;
                              monday = false;
                              thursday = false;
                              friday = false;
                              saturday = false;
                              sunday = false;
                              if (wednesday) {
                                newEvent.notRepeat = "Wednesday";
                              } else if (!wednesday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: wednesday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('We')),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              thursday = !thursday;
                              tuesday = false;
                              wednesday = false;
                              monday = false;
                              friday = false;
                              saturday = false;
                              sunday = false;
                              if (thursday) {
                                newEvent.notRepeat = "Thursday";
                              } else if (!thursday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: thursday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('Th')),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              friday = !friday;
                              tuesday = false;
                              wednesday = false;
                              thursday = false;
                              monday = false;
                              saturday = false;
                              sunday = false;
                              if (friday) {
                                newEvent.notRepeat = "Friday";
                              } else if (!friday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: friday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('Fr')),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              saturday = !saturday;
                              tuesday = false;
                              wednesday = false;
                              thursday = false;
                              friday = false;
                              monday = false;
                              sunday = false;
                              if (saturday) {
                                newEvent.notRepeat = "Saturday";
                              } else if (!saturday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: saturday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('Sa')),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              sunday = !sunday;
                              tuesday = false;
                              wednesday = false;
                              thursday = false;
                              friday = false;
                              saturday = false;
                              monday = false;
                              if (sunday) {
                                newEvent.notRepeat = "Sunday";
                              } else if (!sunday) {
                                newEvent.notRepeat = null;
                              }
                            });
                          },
                          child: ClipOval(
                            child: Container(
                              color: sunday ? Colors.grey : Color(0xFFF4D2B3),
                              height: 40,
                              width: 40,
                              child: Center(child: Text('Su')),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    newEvent.notRepeat != null
                        ? Row(
                            children: [
                              Text("Series ends at:"),
                              SizedBox(
                                width: 10,
                              ),

                              newEvent.SeriesEndDate != null?
                              RaisedButton(
                                onPressed: () {
                                  showDatePicker(
                                          context: context,
                                          initialDate: DateTime.parse(newEvent.SeriesEndDate),
                                          firstDate: DateTime(2001),
                                          lastDate: DateTime(3001))
                                      .then((value) => setState(() {
                                          endDate = value;
                                          formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
                                          newEvent.SeriesEndDate = formattedEndDate;
                                  }));
                                  },

                                child:
                                Text("DatePicker")
                              ):
                              RaisedButton(
                                  onPressed: () {
                                    showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2001),
                                        lastDate: DateTime(3001))
                                        .then((value) => setState(() {
                                      endDate = value;
                                      formattedEndDate = DateFormat('yyyy-MM-dd').format(endDate);
                                      newEvent.SeriesEndDate = formattedEndDate;
                                    }));
                                  },

                                  child:
                                  Text("DatePicker")
                              ),
                              newEvent.SeriesEndDate != null?
                              Text(
                                  "   " + DateFormat("dd-MMMM-yyyy").format(DateTime.parse(newEvent.SeriesEndDate))

                              ):
                              Text(
                                  "   "

                              )
                            ],
                          )
                        : Container(),


                    SizedBox(height: 40),
                    Text("Description", style: TextStyle(fontWeight: FontWeight.bold)),
                    TextField(
                        controller: textEditingController,
                        keyboardType: TextInputType.multiline,
                        maxLines: 8,
                        decoration: InputDecoration(border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color(0xFFFFC135)),
                        ),
                        )),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              createEventCheck ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Loading2()),
              ) :
              Container(
                height: height * 0.1,
                width: width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors:[
                          Color(0xFFFFC135),
                          Color(0xFFFF3F58),
                        ]
                    ),
                    //borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => Professional2(proUser: proUser)), (route) => false);
                        },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.white,
                        child: Text("cancel", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        padding: EdgeInsets.symmetric(horizontal: 30)),
                    FlatButton(
                        onPressed: circularProgress
                            ? null
                            : () {
                                newEvent.Description = textEditingController.text;
                                newEvent.viewCounter = 0;

                                if (secondaryPreferencesList.length == 3) {
                                  newEvent.relatedStyle1 = secondaryPreferencesList[0];
                                  newEvent.relatedStyle2 = secondaryPreferencesList[1];
                                  newEvent.relatedStyle3 = secondaryPreferencesList[2];
                                } else if (secondaryPreferencesList.length == 2) {
                                  newEvent.relatedStyle1 = secondaryPreferencesList[0];
                                  newEvent.relatedStyle2 = secondaryPreferencesList[1];
                                } else if (secondaryPreferencesList.length == 1) {
                                  newEvent.relatedStyle1 = secondaryPreferencesList[0];
                                }

                                if (newEvent.startTime == null) {
                                  startTimeCheck = true;
                                } else if (newEvent.startTime != null) {
                                  startTimeCheck = false;
                                }
                                if (newEvent.endTime == null) {
                                  endTimeCheck = true;
                                } else if (newEvent.endTime != null) {
                                  endTimeCheck = false;
                                }
                                if (newEvent.EndDate == null) {
                                  endDateCheck = true;
                                } else if (newEvent.EndDate != null) {
                                  endDateCheck = false;
                                }

                                if (newEvent.Location == null) {
                                  locationCheck = true;
                                } else if (newEvent.Location != null) {
                                  locationCheck = false;
                                }
                                if (newEvent.Description == "") {
                                  descriptionCheck = true;
                                } else if (newEvent.Description != "") {
                                  descriptionCheck = false;
                                }
                                if (newEvent.ImageUrl == null) {
                                  eventImageCheck = true;
                                } else if (newEvent.ImageUrl != null) {
                                  eventImageCheck = false;
                                }

                                if (locationCheck && descriptionCheck && eventImageCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Location, Description and Event Image cannot be empty",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (locationCheck && descriptionCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Location and Description cannot be empty",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (locationCheck && eventImageCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Location and Event Image not selected",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (descriptionCheck && eventImageCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Description and Event Image cannot be empty",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (locationCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Location not selected",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (descriptionCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Don’t forget to add a description",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (eventImageCheck) {
                                  Fluttertoast.showToast(
                                      msg: "Event Image Not Picked",
                                      toastLength: Toast.LENGTH_SHORT,
                                      backgroundColor: Colors.black);
                                } else if (!locationCheck && !descriptionCheck && !eventImageCheck) {
                                  createEvent();
                                }
                              },
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        color: Colors.white,
                        child: Text("done", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        padding: EdgeInsets.symmetric(horizontal: 30))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
