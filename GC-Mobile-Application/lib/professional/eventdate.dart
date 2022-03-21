import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/eventhost.dart';
import 'package:united_app/professional/eventname.dart';

class EventDate extends StatefulWidget {
  final Event newEvent;
  final ProfessionalUser proUser;
  EventDate({this.newEvent, this.proUser});

  @override
  State<StatefulWidget> createState() {
    return EventDateState(newEvent, proUser);
  }
}

class EventDateState extends State<EventDate> {
  Event newEvent;
  ProfessionalUser proUser;
  EventDateState(this.newEvent, this.proUser);

  CalendarController calendarController;
  DateTime now;

  @override
  void initState() {
    calendarController = CalendarController();
    now = new DateTime.now();

    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print("Testing = ");
    print(newEvent.EventID);

    newEvent.StartDate = formattedDate;

    DateTime tomorrow = new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day + 1);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    Text(now.year.toString(), style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(DateFormat('E').format(now),
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(", ", style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(DateFormat('MMM').format(now),
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(" "),
                    Text(now.day.toString(), style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(now.year.toString(),
                        style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),

                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(DateFormat('E').format(now),
                        style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(", ", style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(DateFormat('MMM').format(now),
                        style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),
                    Text(" "),
                    Text(now.day.toString(), style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold)),

                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.white,
                  child: TableCalendar(
                      enabledDayPredicate: (date) {
                        return (date
                            .isAfter(new DateTime(new DateTime.now().year, new DateTime.now().month, new DateTime.now().day)));
                      },
                      onDaySelected: (date, events, holidays) {
                        setState(() {
                          now = date;
                        });
                        var formatter = new DateFormat('yyyy-MM-dd');
                        String formattedDate = formatter.format(date);
                        newEvent.StartDate = formattedDate;
                      },
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      calendarController: calendarController),
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
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                      EventHost(newEvent: newEvent, proUser: proUser)), (route) => false);
                },
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0), side: BorderSide(color: Colors.amber)),
                padding: EdgeInsets.all(8.0),
              ),
            ),
            RaisedButton(
              child: Text("Next"),
              color: Colors.amber,
              onPressed: () {
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                    EventName(newEvent: newEvent, proUser: proUser)), (route) => false);
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
