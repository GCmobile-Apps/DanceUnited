import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfessionalEventDetailed extends StatefulWidget {
  final Event event;
  final ProfessionalUser proUser;
  ProfessionalEventDetailed({this.event, this.proUser});

  @override
  State<StatefulWidget> createState() {
    return ProfessionalEventDetailedState(event, proUser);
  }
}

class ProfessionalEventDetailedState extends State<ProfessionalEventDetailed> {
  Event event;
  ProfessionalUser proUser;
  ProfessionalEventDetailedState(this.event, this.proUser);

  Future futureWhoIsGoing;
  Future eventDetailsFuture;
  Future professionalofevent;


  bool editEventDetails = false;
  bool editTitle = false;
  bool editDescription = false;
  DateTime selectedDate = DateTime.now();
  String selectedLocation;

  TextEditingController titleController = new TextEditingController();
  TextEditingController descriptionController = new TextEditingController();

  TimeOfDay currentTime;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  String startTimePeriod;
  String endTimePeriod;

  String formattedStartTime;
  String formattedEndTime;

  var imageResponse;
  PickedFile pickedFile;
  bool showDetails = false;
  bool circularProgress = false;
  final ImagePicker imagePicker = ImagePicker();
  ProfessionalUser professionalUser = new ProfessionalUser();


  // Helper Function ----------------------------------------------------------------------------------------------- //

  getEventPublisher() async {


    var result = await getEventPublisherFromServer("professionalUser", {"eventID": event.EventID});
    print("Data recieved");
    print(result.data);

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

  pickTime() async {
    TimeOfDay timeOfDay = await showTimePicker(
        context: context,
        initialTime: currentTime,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData(),
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

  String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  // Helper Function ----------------------------------------------------------------------------------------------- //

  getEventDetails() async {
    var result = await getSpecificEventFromServer("specificEvent", {"eventID": event.EventID});
    Event newEvent = new Event();
    setState(() {
      Event newEvent = new Event();
      event.EventID = result.data['data'][0]['EventID'];
      event.Title = result.data['data'][0]['Title'];
      event.Description = result.data['data'][0]['Description'];
      event.StartDate = result.data['data'][0]['StartDate'];
      event.EndDate = result.data['data'][0]['EndDate'];
      event.Location = result.data['data'][0]['Location'];
      event.Prize = result.data['data'][0]['Prize'];
      event.Type = result.data['data'][0]['Type'];
      event.ImageUrl = result.data['data'][0]['ImageUrl'];
      event.Tags = result.data['data'][0]['Tags'];
      event.notRepeat = result.data['data'][0]['notRepeat'];
      event.startTime = result.data['data'][0]['startTime'];
      event.endTime = result.data['data'][0]['endTime'];
      event.CompleteAddress = result.data['data'][0]['CompleteAddress'];
    });

    return newEvent;
  }

  // Event Update Functions ------------------------------------------------------------------------------------------ //

  updateTitle() async {
    setState(() {
      event.Title = null;
    });
    var response = await updateEventTitle("updateEventTitle", {"eventID": event.EventID, "title": titleController.text});
    if (response == 200) {
      getEventDetails();
    }
  }

  updateStartDate(DateTime selectedDate) async {
    setState(() {
      editEventDetails = !editEventDetails;
      event.StartDate = null;
    });
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    var response = await updateEventStartDate("updateEventStartDate", {"eventID": event.EventID, "startDate": formattedDate});
    if (response == 200) {
      setState(() {
        getEventDetails();
      });
    }
  }

  updateStartTime(selectedTime) async {
    setState(() {
      editEventDetails = !editEventDetails;
      event.startTime = null;
    });
    var response = await updateEventStartTime("updateEventStartTime", {"eventID": event.EventID, "startTime": selectedTime});
    if (response == 200) {
      setState(() {
        getEventDetails();
      });
    }
  }

  updateEndTime(selectedTime) async {
    setState(() {
      editEventDetails = !editEventDetails;
      event.endTime = null;
    });
    var response = await updateEventEndTime("updateEventEndTime", {"eventID": event.EventID, "endTime": selectedTime});
    if (response == 200) {
      setState(() {
        getEventDetails();
      });
    }
  }

  updateEventImage() async {
    final picked = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      pickedFile = picked;
    });
    setState(() {
      circularProgress = true;
    });
    if (pickedFile != null) {
      imageResponse = patchImage("addImage", pickedFile.path, event.EventID, "eventImages");
      imageResponse.then((profilePictureLink) async {
        var response =
            await updateEventImageInDb("updateEventImage", {"eventID": event.EventID, "eventImageLink": profilePictureLink});
        if (response == 200) {
          setState(() {
            getEventDetails();
            imageCache.clear();
            imageCache.clearLiveImages();
          });
        }
      });
    }
    setState(() {
      circularProgress = false;
    });
  }

  updateDescription() async {
    setState(() {
      event.Description = null;
    });
    var response =
        await updateEventDescription("updateDescription", {"eventID": event.EventID, "description": descriptionController.text});
    if (response == 200) {
      setState(() {
        getEventDetails();
      });
    }
  }

  updateLocation() async {
    setState(() {
      editEventDetails = !editEventDetails;
      event.Location = null;
    });
    var response = await updateEventLocation("updateLocation", {"eventID": event.EventID, "location": selectedLocation});
    if (response == 200) {
      setState(() {
        getEventDetails();
      });
    }
  }

  // Event Update Functions ------------------------------------------------------------------------------------------ //

  @override
  void initState() {
    currentTime = TimeOfDay.now();
    professionalofevent = getEventPublisher();
    eventDetailsFuture = getEventDetails();
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
                          editTitle
                              ? Container(
                                  width: width * 0.5,
                                  child: TextField(
                                    controller: titleController,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                                    decoration: new InputDecoration.collapsed(hintText: 'Event Title'),
                                  ))
                              : event.Title == null
                                  ? Loading2()
                                  : Container(
                                      width: width * 0.8,
                                      child: Text(event.Title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                                    ),
                          editEventDetails
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editTitle = true;
                                      titleController.text = event.Title;
                                      editEventDetails = false;
                                    });
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
                              Row(
                                children: [
                                  event.StartDate == null
                                      ? Loading2()
                                      : Text(
                                           new DateFormat('dd').format(new DateFormat("yyyy-MM-dd").parse(event.StartDate)) + " " +
                                           new DateFormat('MMMM').format(new DateFormat("yyyy-MM-dd").parse(event.StartDate)) + " " +
                                               new DateFormat('yyyy').format(new DateFormat("yyyy-MM-dd").parse(event.StartDate))
                                  ),
                                  editEventDetails
                                      ? GestureDetector(
                                          onTap: () async {
                                            final DateTime picked = await showDatePicker(
                                                context: context,
                                                initialDate: selectedDate,
                                                firstDate: DateTime(2015, 8),
                                                lastDate: DateTime(2101));
                                            if (picked != null && picked != selectedDate)
                                              setState(() {
                                                selectedDate = picked;
                                                updateStartDate(selectedDate);
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
                                                child: Icon(Icons.edit, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Row(
                                children: [
                                  event.startTime == null ? Loading2() : Text(event.startTime),
                                  editEventDetails
                                      ? GestureDetector(
                                          onTap: () {
                                            var timeResponse = pickTime();
                                            timeResponse.then((result) {
                                              startTime = result;
                                              formattedStartTime = formatTimeOfDay(startTime);
                                              updateStartTime(formattedStartTime);
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
                                                child: Icon(Icons.edit, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                  Text(" - "),
                                  event.endTime == null ? Loading2() : Text(event.endTime),
                                  editEventDetails
                                      ? GestureDetector(
                                          onTap: () {
                                            var timeResponse = pickTime();
                                            timeResponse.then((result) {
                                              endTime = result;
                                              formattedEndTime = formatTimeOfDay(endTime);
                                              updateEndTime(formattedEndTime);
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
                                                child: Icon(Icons.edit, color: Colors.black),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                              Text(
                                  new DateFormat('dd').format(new DateFormat("yyyy-MM-dd").parse(event.EndDate)) + " " +
                                      new DateFormat('MMMM').format(new DateFormat("yyyy-MM-dd").parse(event.EndDate)) + " " +
                                     new DateFormat('yyyy').format(new DateFormat("yyyy-MM-dd").parse(event.EndDate))
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.location_on, size: 30),
                          ),
                          event.Location == null ? Loading2() :
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

                                child:
                                    event.CompleteAddress == null?

                                Text(event.Location):
                                Text(event.CompleteAddress),
                              )
                          ),
                          editEventDetails
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) {
                                        final kInitialPosition = LatLng(-33.8567844, 151.213108);
                                        return PlacePicker(
                                          apiKey: "AIzaSyBG9rhs1LqFSbtMeYdWwhEZZtkaFIwKvnM", // Put YOUR OWN KEY here.
                                          onPlacePicked: (result) {
                                            setState(() {
                                              var length2 = result.addressComponents.length;
                                              selectedLocation = null;
                                              for (int i = 0; i < length2; i++) {
                                                if (result.addressComponents[i].types[0] == 'locality' &&
                                                    selectedLocation == null) {
                                                  selectedLocation = result.addressComponents[i].longName;
                                                } else if (result.addressComponents[i].types[0] ==
                                                        'administrative_area_level_3' &&
                                                    selectedLocation == null) {
                                                  selectedLocation = result.addressComponents[i].longName;
                                                } else if (result.addressComponents[i].types[0] ==
                                                        'administrative_area_level_2' &&
                                                    selectedLocation == null) {
                                                  selectedLocation = result.addressComponents[i].longName;
                                                } else if (result.addressComponents[i].types[0] ==
                                                        'administrative_area_level_1' &&
                                                    selectedLocation == null) {
                                                  selectedLocation = result.addressComponents[i].longName;
                                                }
                                              }
                                              updateLocation();
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          initialPosition: kInitialPosition,
                                          useCurrentLocation: true,
                                        );
                                      }),
                                    );
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
                                        child: Icon(Icons.edit, color: Colors.black),
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
                SizedBox(height: 20),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              event.ImageUrl == null
                                  ? Loading2():
                              Container(
                                height: height * 0.2,
                                width: width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(event.ImageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                            ],
                          ),
                          SizedBox(height: 10)
                        ],
                      ),
                    ),
                    editEventDetails
                        ? Positioned(
                            top: height * 0.01,
                            left: width * 0.82,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  updateEventImage();
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



                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                      children: <Widget>[




                        FutureBuilder(
                            future: professionalofevent,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                              children: <Widget>[
                                                Container(height: 100, width: 100, child: Image.network(professionalUser.secondaryProfilePictureLink)),
                                              ],
                                          ),
                                          Text(professionalUser.title, style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text("Event Organizer"),
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




                    //   professionalUser.secondaryProfilePictureLink == null ?
                    //   Loading2():
                    //   Container(height: 100, width: 100, child: Image.network(professionalUser.secondaryProfilePictureLink)),
                    //   Padding(
                    //     padding: const EdgeInsets.only(left: 20),
                    //     child: Column(
                    //       mainAxisAlignment: MainAxisAlignment.start,
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: <Widget>[
                    //         professionalUser.title == null ?
                    //         Loading2():
                    //         Text(professionalUser.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    //         Text("Event Organizer"),
                    //       ],
                    //     ),
                    //   ),
                     ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Text("Event", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xffFFA800))),
                          editEventDetails
                              ? GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      editDescription = true;
                                      descriptionController.text = event.Description;
                                      editEventDetails = false;
                                    });
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
                                        child: Icon(Icons.edit, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              : editDescription
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          editDescription = false;
                                          updateDescription();
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          editDescription
                              ? Expanded(
                                  child: IntrinsicWidth(
                                    child: TextField(
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      controller: descriptionController,
                                      style: TextStyle(fontWeight: FontWeight.normal),
                                      decoration: new InputDecoration.collapsed(hintText: 'Event Description'),
                                    ),
                                  ),
                                )
                              : event.Description == null
                                  ? Loading2()
                                  : Expanded(child: Text(event.Description, style: TextStyle(fontWeight: FontWeight.normal))),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            SizedBox(width: width * 0.78),
            FloatingActionButton(
              heroTag: "EditButton",
              onPressed: () {
                setState(() {
                  editEventDetails = !editEventDetails;
                });
              },
              child: editEventDetails
                  ? Icon(Icons.check, color: Colors.black)
                  : Icon(Icons.edit, color: Colors.black),
              backgroundColor: Colors.amber,
            ),
          ],
        ),
      ),
    );
  }
}
