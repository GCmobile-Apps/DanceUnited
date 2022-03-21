import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/eventpreferences.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/eventdate.dart';
import 'package:united_app/professional/neweventdetails.dart';
import 'package:united_app/professional/professionalpreferences.dart';

class EventName extends StatefulWidget {
  final Event newEvent;
  final ProfessionalUser proUser;
  EventName({this.newEvent, this.proUser});

  @override
  State<StatefulWidget> createState() {
    return EventNameState(newEvent, proUser);
  }
}

class EventNameState extends State<EventName> {
  Event newEvent;
  ProfessionalUser proUser;
  EventNameState(this.newEvent, this.proUser);
  TextEditingController controller = new TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool validateForm = false;

  validateFormAndSave() {
    if (formKey.currentState.validate()) {
      setState(() {
        validateForm = true;
      });
    }
  }

  @override
  void initState() {
    controller.text = newEvent.Title;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xffffffff),
              const Color(0xffffffff),
              const Color(0xffffffff),
              const Color(0xffffffff),
              const Color(0xffffffff),
            ], // red to yellow
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(now.year.toString(), style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(DateFormat('E').format(now),
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(", ", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(DateFormat('MMM').format(now),
                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(" "),
                    Text(now.day.toString(), style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Name required";
                        } else {
                          return null;
                        }
                      },
                      controller: controller,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
                      cursorColor: Colors.black,
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          hintText: "Event Name",
                          hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40))),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RaisedButton(
                child: Text("back"),
                color: Colors.amber,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => EventDate(newEvent: newEvent, proUser: proUser)),
                      (route) => false);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                padding: EdgeInsets.all(8.0),
              ),
            ),
            RaisedButton(
              child: Text("Next"),
              color: Colors.amber,
              onPressed: () {
                validateFormAndSave();

                if (validateForm) {
                  newEvent.Title = controller.text;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => ProfessionalPreferences(newEvent: newEvent, proUser: proUser)),
                      (route) => false);
                }
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
              padding: EdgeInsets.all(8.0),
            ),
          ],
        ),
      ),
    );
  }
}
