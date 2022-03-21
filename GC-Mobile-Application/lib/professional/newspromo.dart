import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:united_app/ServerRequests/http.dart';
import 'package:united_app/model/cardInfo.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/loading.dart';
import 'package:united_app/model/preferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/model/promo.dart';
import 'package:united_app/professional/professional2.dart';
import 'package:united_app/shared/SharedMethods.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewsPromo extends StatefulWidget {
  final ProfessionalUser proUser;
  NewsPromo({this.proUser});
  @override
  State<StatefulWidget> createState() {
    return NewsPromoState(proUser);
  }
}

class NewsPromoState extends State<NewsPromo> {
  ProfessionalUser proUser;
  NewsPromoState(this.proUser);
  final storage = new FlutterSecureStorage();

  var result;
  Future future;
  var imageResponse;
  PickedFile pickedFile;
  bool checkBoxValue = true;
  bool editCardNumber = false;
  bool circularProgress = false;
  CardInfo cardInfo = new CardInfo();

  bool offerTitleCheck = false;
  bool mainStyleCheck = false;
  bool eventIDCheck = false;
  bool promoImageCheck = false;
  bool promoLocationCheck=false;

  Promo newPromo = new Promo();
  List<Event> events = new List();
  Event selectedEvent;
  final ImagePicker imagePicker = ImagePicker();

  TextEditingController cvcController = new TextEditingController();
  TextEditingController cardNumber = new TextEditingController();
  TextEditingController offerTitleController = new TextEditingController();
  TextEditingController destinationLinkController = new TextEditingController();
  TextEditingController promoCityController = new TextEditingController();

  //final AsyncMemoizer memoizer = AsyncMemoizer();
  List<String> primaryPreference = new List();
  List<String> secondaryPreferencesList = new List();
  List<Preferences> preferencesList = new List();
  //MultiSelectController primaryStyleController = new MultiSelectController();
  //MultiSelectController controller = new MultiSelectController();

  bool createPromoCheck = false;

  int group = 1;
  Future futureCardInfo;
  bool emptyEvents=false;

  final formKey = GlobalKey<FormState>();
  bool validateForm = false;

  SharedMethods sh= new SharedMethods();

  getCreditCardInfo() async {
    result = await getCreditCardInformation("creditCard", {"userID": proUser.UserID});
    CardInfo cardInformation = new CardInfo();
    if (result.data['status'] == true) {
      cardInformation.cardNumber = result.data['data'][0]['cardNumber'];
      cardInformation.cvc = result.data['data'][0]['cvc'];
    }
    return cardInformation;
  }

  launchNewsPromo(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text("Launch News Promo", style: TextStyle(color: Color(0xffffaa00), fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: height * 0.15,
                          decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(const Radius.circular(10)),
                              border: Border.all(color: Colors.amber)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Text("News Promo", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Text", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Text", style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text("Text", style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Text("Price", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text("Payment", style: TextStyle(fontWeight: FontWeight.bold)),
                            editCardNumber
                                ? FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        cardInfo.cardNumber = cardNumber.text;
                                        cardInfo.cvc = cvcController.text;
                                        var resultCode = saveCardInfo();

                                        print(resultCode);

                                        editCardNumber = !editCardNumber;
                                      });
                                    },
                                    child:
                                        Text("save", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)))
                                : FlatButton(
                                    onPressed: () {
                                      setState(() {
                                        editCardNumber = !editCardNumber;
                                      });
                                    },
                                    child:
                                        Text("edit", style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)))
                          ],
                        ),
                        editCardNumber
                            ? Expanded(
                                child: Column(
                                children: [
                                  TextField(
                                    decoration: new InputDecoration(hintText: "Enter Card Number"),
                                    controller: cardNumber,
                                  ),
                                  TextField(
                                    decoration: new InputDecoration(hintText: "Enter Cvc"),
                                    controller: cvcController,
                                  ),
                                ],
                              ))
                            : FutureBuilder(
                                future: futureCardInfo,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                    return Column(
                                      children: [
                                        Text(snapshot.data.cardNumber.toString()),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(snapshot.data.cvc.toString()),
                                      ],
                                    );
                                  } else if (snapshot.data == null) {
                                    return Text("Error Loading card info");
                                  } else {
                                    return Align(child: Loading2());
                                  }
                                }),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        return Professional2();
                      }));
                    },
                    child: Text("Buy", style: TextStyle(color: Color(0xffffaa00), fontWeight: FontWeight.bold)))
              ],
            );
          });
        });
  }

  saveCardInfo() async {
    var result = await saveCardInformation("saveCardInfo", {"userID": proUser.UserID, "cardInfo": cardInfo});
    return result;
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
        imageResponse = patchImage("addImage", pickedFile.path, newPromo.promoID, "promoImages");
        imageResponse.then((result) {
          newPromo.promoImageUrl = result;
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

  createNewsPromo() async {
    setState(() {
      createPromoCheck = true;
    });
    var result = await createNewNewsPromo("createNewNewsPromo", {"newspromo": newPromo.toJson()});
    if (result == 200) {
      setState(() {
        createPromoCheck = false;
      });
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => Professional2(proUser: proUser)), (route) => false);
    }
  }

  validateFormAndSave() {
    if (formKey.currentState.validate()) {
      setState(() {
        validateForm = true;
      });
    }
  }

  @override
  void initState() {
    futureCardInfo = getCreditCardInfo();
    var uuid = Uuid();
    newPromo.promoID = uuid.v1();
    future = sh.getProUserEvents(proUser,events);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Create News Promo",
                        style: TextStyle(color: Color(0xffffaa00), fontWeight: FontWeight.bold, fontSize: 20)),
                    SizedBox(height: 20),
                    Text("Title", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    TextField(
                      controller: offerTitleController,
                      decoration: new InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Radio(
                                  value: 1,
                                  groupValue: group,
                                  onChanged: (value) {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      eventIDCheck = false;
                                      group = value;
                                    });
                                  }),
                            ),
                            Text("External Promo", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 24,
                              width: 24,
                              child: Radio(
                                  value: 2,
                                  groupValue: group,
                                  onChanged: (value) {
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      group = value;
                                    });
                                  }),
                            ),
                            Text("Internal Promo", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    group == 1
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Destination Link", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              Form(
                                key: formKey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return "Link required";
                                    } else if (!RegExp(
                                            r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")
                                        .hasMatch(value)) {
                                      return "Enter a valid link";
                                    } else {
                                      return null;
                                    }
                                  },
                                  controller: destinationLinkController,
                                  decoration: new InputDecoration(
                                    hintText: "e.g. https://www.example.com/",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )
                        : emptyEvents
                        ?Column()
                        :Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Choose In-App Event Link", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        FutureBuilder(
                            future: future,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                                events = snapshot.data;
                                if(this.selectedEvent==null){
                                  this.selectedEvent=snapshot.data[0];
                                }
                                return DropdownButton<Event>(
                                    value: this.selectedEvent != null ? this.selectedEvent : snapshot.data[0],
                                    items: events.map((Event dropDownItem) {
                                      return DropdownMenuItem<Event>(
                                        value: dropDownItem,
                                        child: Text(dropDownItem.Title),
                                      );
                                    }).toList(),
                                    onChanged: (Event newValue) {
                                      setState(() {
                                        this.selectedEvent = new Event();
                                        setState(() {
                                          this.selectedEvent = newValue;
                                          eventIDCheck = false;
                                        });
                                      });
                                    },
                                    hint: Text("browse your events"));
                              }
                              else {
                                return Align(child: Loading2());
                              }
                            }),
                      ],
                    ),
                    eventIDCheck ? Text("No Event Selected", style: TextStyle(color: Colors.red),) : Container(),
                    SizedBox(height: 20),
                    Text("Promo Image", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Stack(
                      children: [
                        Container(
                          height: height * 0.25,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: pickedFile == null
                                  ? AssetImage("assets/images/promo-placeholder.png")
                                  : FileImage(File(pickedFile.path)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: height * 0.08,
                          left: width * 0.32,
                          child: FlatButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                takePhoto(ImageSource.gallery);
                              },
                              child: Text("change")),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text("Main Style", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 10),
                    primaryPreference.length == 0
                        ? GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              sh.primaryFilterPopUp(context,preferencesList,primaryPreference).then((value) => setState(() {}));
                            },
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey[300],
                                height: 75,
                                width: 75,
                                child: Center(child: Icon(Icons.add)),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              sh.primaryFilterPopUp(context,preferencesList,primaryPreference).then((value) => setState(() {}));
                            },
                            child: ClipOval(
                              child: Container(
                                color: Colors.grey[300],
                                height: 75,
                                width: 75,
                                child: Center(
                                    child: Text(
                                  primaryPreference[0],
                                  textAlign: TextAlign.center,
                                )),
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    Text("Related Style(s)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    SizedBox(height: 10),
                    secondaryPreferencesList.length == 0
                        ? GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                      },
                      child: ClipOval(
                        child: Container(
                          color: Colors.grey[300],
                          height: 75,
                          width: 75,
                          child: Center(child: Icon(Icons.add)),
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
                                        color: Colors.grey[300],
                                        height: 75,
                                        width: 75,
                                        child: Center(child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                    },
                                    child: ClipOval(
                                      child: Container(
                                        color: Colors.grey[300],
                                        height: 75,
                                        width: 75,
                                        child: Center(child: Icon(Icons.add)),
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
                                          FocusScope.of(context).unfocus();
                                          sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            height: 75,
                                            width: 75,
                                            child: Center(child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {},
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            height: 75,
                                            width: 75,
                                            child: Center(child: Text(secondaryPreferencesList[1], textAlign: TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            height: 75,
                                            width: 75,
                                            child: Center(child: Icon(Icons.add)),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            height: 75,
                                            width: 75,
                                            child: Center(child: Text(secondaryPreferencesList[0], textAlign: TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            height: 75,
                                            width: 75,
                                            child: Center(child: Text(secondaryPreferencesList[1], textAlign: TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          sh.filtersPopUp(context,preferencesList,secondaryPreferencesList).then((value) => setState(() {}));
                                        },
                                        child: ClipOval(
                                          child: Container(
                                            color: Colors.grey[300],
                                            height: 75,
                                            width: 75,
                                            child: Center(child: Text(secondaryPreferencesList[2], textAlign: TextAlign.center)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          width: 24,
                          child: Checkbox(
                              value: checkBoxValue,
                              onChanged: (bool value) {
                                FocusScope.of(context).unfocus();
                                setState(() {
                                  checkBoxValue = value;
                                });
                              }),
                        ),
                        Text("location specific(recommended)"),
                      ],
                    ),
                    checkBoxValue == false
                        ? Container()
                        : RaisedButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  final kInitialPosition = LatLng(60.12816100000001, 18.643501);
                                  return PlacePicker(
                                    apiKey: "AIzaSyBG9rhs1LqFSbtMeYdWwhEZZtkaFIwKvnM", // Put YOUR OWN KEY here.
                                    onPlacePicked: (result) {
                                      setState(() {
                                        var length2 = result.addressComponents.length;
                                        var promoCity;
                                        var promoCountry;
                                        for (int i = 0; i < length2; i++) {
                                          if (result.addressComponents[i].types[0] == 'country') {
                                            promoCountry = result.addressComponents[i].longName;
                                          }

                                          if (result.addressComponents[i].types[0] == 'locality' &&
                                              promoCity == null) {
                                            promoCity = result.addressComponents[i].longName;
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_3' &&
                                              promoCity == null) {
                                            promoCity = result.addressComponents[i].longName;
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_2' &&
                                              promoCity == null) {
                                            promoCity = result.addressComponents[i].longName;
                                          } else if (result.addressComponents[i].types[0] == 'administrative_area_level_1' &&
                                              promoCity == null) {
                                            promoCity = result.addressComponents[i].longName;
                                          }
                                        }
                                        if(promoCountry == null){
                                          newPromo.promoCity = promoCity;
                                        }else if(promoCity == null){
                                          newPromo.promoCity = promoCountry;
                                        }else{
                                          newPromo.promoCity = promoCountry + "," + promoCity;
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
                            color: Color(0xffee7f40),
                            child: Text("Pick Location", style: TextStyle(color: Colors.white)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                          ),
                    newPromo.promoCity == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Location", style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(newPromo.promoCity),
                              ],
                            ),
                          ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              createPromoCheck ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Loading2()),
              ) :
              Container(
                height: height * 0.1,
                width: width,
                color: Color(0xffffaa00),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => Professional2(proUser: proUser)), (route) => false);
                        },
                        color: Colors.white,
                        child: Text("Cancel", style: TextStyle(color: Color(0xffffaa00), fontWeight: FontWeight.bold)),
                        padding: EdgeInsets.symmetric(horizontal: 30)),
                    FlatButton(
                        onPressed: circularProgress ? null : () {
                          newPromo.userID = proUser.UserID;
                          if(newPromo.promoImageUrl == null){
                            promoImageCheck = true;
                          }else if(newPromo.promoImageUrl != null){
                            promoImageCheck = false;
                          }

                          if(offerTitleController.text == ""){
                            offerTitleCheck = true;
                          }else{
                            newPromo.offerTitle = offerTitleController.text;
                            offerTitleCheck = false;
                          }

                          if (group == 1) {
                            validateFormAndSave();
                            newPromo.promoType = "External Promo";
                            newPromo.destinationLink = destinationLinkController.text;

                            if(primaryPreference.length == 0){
                              mainStyleCheck = true;
                            }else{
                              newPromo.mainStyle = primaryPreference[0];
                              mainStyleCheck = false;
                            }

                            if (secondaryPreferencesList.length == 3) {
                              newPromo.relatedStyle1 = secondaryPreferencesList[0];
                              newPromo.relatedStyle2 = secondaryPreferencesList[1];
                              newPromo.relatedStyle3 = secondaryPreferencesList[2];
                            } else if (secondaryPreferencesList.length == 2) {
                              newPromo.relatedStyle1 = secondaryPreferencesList[0];
                              newPromo.relatedStyle2 = secondaryPreferencesList[1];
                            } else if (secondaryPreferencesList.length == 1) {
                              newPromo.relatedStyle1 = secondaryPreferencesList[0];
                            }

                            if (validateForm) {
                              if (promoImageCheck && offerTitleCheck && mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image, Offer Title and Main Style not provided",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (promoImageCheck && offerTitleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image and Offer Title not provided",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (promoImageCheck && mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image and Main Style not selected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (offerTitleCheck && mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Offer Title and Main Style not provided",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (promoImageCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image not selected", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.black);
                              } else if (offerTitleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Offer Title cannot be Empty", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.black);
                              } else if (mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Main Style Not Picked", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.black);
                              } else if (!promoImageCheck && !offerTitleCheck && !mainStyleCheck) {
                                //Payment p= new Payment();
                                //p.makePayment();
                                createNewsPromo();
                              }
                            }
                          }
                          else if (group == 2) {
                            newPromo.promoType = "Internal Promo";
                            if(selectedEvent == null){
                              setState(() {
                                eventIDCheck = true;
                              });
                            }else{
                              setState(() {
                                eventIDCheck = false;
                              });
                              newPromo.EventID = selectedEvent.EventID;
                            }
                            if(primaryPreference.length == 0){
                              mainStyleCheck = true;
                            }
                            else{
                              newPromo.mainStyle = primaryPreference[0];
                              mainStyleCheck = false;
                            }
                            if (secondaryPreferencesList.length == 3) {
                              newPromo.relatedStyle1 = secondaryPreferencesList[0];
                              newPromo.relatedStyle2 = secondaryPreferencesList[1];
                              newPromo.relatedStyle3 = secondaryPreferencesList[2];
                            } else if (secondaryPreferencesList.length == 2) {
                              newPromo.relatedStyle1 = secondaryPreferencesList[0];
                              newPromo.relatedStyle2 = secondaryPreferencesList[1];
                            } else if (secondaryPreferencesList.length == 1) {
                              newPromo.relatedStyle1 = secondaryPreferencesList[0];
                            }
                            if(checkBoxValue==true && newPromo.promoCity==null){
                              print("true");
                              promoLocationCheck=true;
                            }
                            else{
                              print("false");
                                promoLocationCheck = false;
                            }
                            if(eventIDCheck == false) {
                              if (promoImageCheck && offerTitleCheck && mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image, Offer Title and Main Style not provided",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (promoImageCheck && offerTitleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image and Offer Title not provided",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (promoImageCheck && mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image and Main Style not selected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (offerTitleCheck && mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Offer Title and Main Style not provided",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (promoImageCheck) {
                                Fluttertoast.showToast(
                                    msg: "Promo Image not selected",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (offerTitleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Offer Title cannot be Empty",
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.black);
                              } else if (mainStyleCheck) {
                                Fluttertoast.showToast(
                                    msg: "Main Style Not Picked", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.black);
                              } else if(promoLocationCheck){
                                Fluttertoast.showToast(
                                    msg: "Location not picked", toastLength: Toast.LENGTH_SHORT, backgroundColor: Colors.black);
                              }else if (!promoImageCheck && !offerTitleCheck && !mainStyleCheck && !promoLocationCheck) {
                                //Payment p= new Payment();
                                //p.makePayment();
                                createNewsPromo();
                              }
                            }
                          }
                        },
                        color: Colors.white,
                        child: Text("Publish", style: TextStyle(color: Color(0xffffaa00), fontWeight: FontWeight.bold)),
                        padding: EdgeInsets.symmetric(horizontal: 30))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
