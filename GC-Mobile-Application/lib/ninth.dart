import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:united_app/eigth.dart';
import 'package:united_app/tenth.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'ServerRequests/http.dart';
import 'model/loading.dart';
import 'model/preferences.dart';
import 'model/user.dart';
import 'package:async/async.dart';
import 'package:uuid/uuid.dart';

class NinthPage extends StatefulWidget {
  final User newUser;
  NinthPage({this.newUser});

  @override
  State<StatefulWidget> createState() {
    return NinthPageState(newUser);
  }
}

class NinthPageState extends State<NinthPage> {
  User newUser;
  NinthPageState(this.newUser);

  String userId;
  bool isSelected = false;
  final storage = new FlutterSecureStorage();

  List<Preferences> preferencesList = new List();
  final AsyncMemoizer memoizer = AsyncMemoizer();
  List userPreferencesList = new List();
  MultiSelectController controller = new MultiSelectController();

  @override
  void initState() {
    getPreferences();
    var uuid = Uuid();
    userId = uuid.v1();
    newUser.UserID = userId;
    super.initState();
  }

  getPreferences() {
    return this.memoizer.runOnce(() async {
      String token = await storage.read(key: "token");
      var result = await getPreferencesFromServer("preferences");
      for (int i = 0; i < result.data['list'].length; i++) {
        Preferences preferences = new Preferences();
        preferences.preferenceID = result.data['list'][i]['PreferenceID'];
        preferences.preferenceName = result.data['list'][i]['PreferenceName'];
        preferencesList.add(preferences);
      }
      print("two");
      if (preferencesList.isEmpty) {
        Fluttertoast.showToast(
            msg: "Ooops something is wrong,please try again later",
            toastLength: Toast.LENGTH_SHORT,
            backgroundColor: Colors.black);
      }
      print(preferencesList);
      return preferencesList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration:
                BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/BackGroundSignUp.png"), fit: BoxFit.cover)),
          ),
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
              color: Color(0xff000000).withOpacity(0.2),
            ),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                                color: Colors.red, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3),
                          child: Container(
                            height: 7,
                            width: 7,
                            decoration: BoxDecoration(
                                color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
//                        Padding(
//                          padding: const EdgeInsets.only(left: 20),
//                          child: RaisedButton(
//                            child: Text("back"),
//                            color: Colors.amber,
//                            elevation: 10,
//                            onPressed: () {
//
//                              Navigator.push(
//                                  context,
//                                  PageRouteBuilder(
//                                      pageBuilder: (_, __, ___) => EigthPage(newUser: newUser),
//                                      transitionDuration: Duration(seconds: 0)));
//                            },
//                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
//                            padding: EdgeInsets.all(8.0),
//                          ),
//                        ),
                      ],
                    ),
                    Center(
                        child: Text("Choose upto 3 quick filters",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))),
                    FutureBuilder(
                        future: getPreferences(),
                        builder: (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
                            return GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.length,
                                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: MultiSelectItem(
                                      isSelecting: controller.isSelecting,
                                      onSelected: () {
                                        setState(() {
                                          if (userPreferencesList.length < 3) {
                                            if (!controller.isSelected(index)) {
                                              userPreferencesList.add(snapshot.data[index].preferenceName);
                                            }
                                            controller.toggle(index);
                                            if (!controller.isSelected(index)) {
                                              userPreferencesList
                                                  .removeWhere((element) => element == snapshot.data[index].preferenceName);
                                            }
                                          } else if (userPreferencesList.length == 3) {
                                            if (!controller.isSelected(index)) {
                                              SnackBar snackBar =
                                                  SnackBar(content: Text("Deselect one option to select another"));
                                              Scaffold.of(context).showSnackBar(snackBar);
                                            }

                                            if (controller.isSelected(index)) {
                                              controller.toggle(index);
                                            }
                                            if (!controller.isSelected(index)) {
                                              userPreferencesList.removeWhere((element) {
                                                return element == snapshot.data[index].preferenceName;
                                              });
                                            }
                                          }
                                        });
                                      },
                                      child: Card(
                                        color: controller.isSelected(index) ? Color(0xfffdb602) : Color(0xfff1ead7),
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
                          } else {
                            return Loading2();
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text("Next"),
                          color: Colors.white,
                          elevation: 10,
                          onPressed: () {
                            if (userPreferencesList.length == 0) {
                              Fluttertoast.showToast(
                                  msg: "At least one preference required",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.black);
                            } else {
                              if (userPreferencesList.length == 3) {
                                newUser.Preference1 = userPreferencesList[0];
                                newUser.Preference2 = userPreferencesList[1];
                                newUser.Preference3 = userPreferencesList[2];
                              } else if (userPreferencesList.length == 2) {
                                newUser.Preference1 = userPreferencesList[0];
                                newUser.Preference2 = userPreferencesList[1];
                              } else if (userPreferencesList.length == 1) {
                                newUser.Preference1 = userPreferencesList[0];
                              }
                              Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) => TenthPage(newUser: newUser),
                                      transitionDuration: Duration(seconds: 0)));
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.white)),
                          padding: EdgeInsets.all(8.0),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
