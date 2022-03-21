import 'package:flutter/material.dart';
import 'package:united_app/Custom%20Classes/Gradient_Border.dart';
import 'package:united_app/model/event.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/professional/eventdate.dart';
import 'package:united_app/professional/professional2.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EventHost extends StatefulWidget{
  final ProfessionalUser proUser;
  final Event newEvent;
  EventHost({this.newEvent, this.proUser});

  @override
  State<StatefulWidget> createState() {
    return EventHostState(newEvent, proUser);
  }
}

class EventHostState extends State<EventHost>{
  Event newEvent;
  ProfessionalUser proUser;
  EventHostState(this.newEvent, this.proUser);
  List<String> hostType = List<String>();
  String color;
  String eventId;

  @override
  void initState() {
    hostType.add("Social");
    hostType.add("Festival");
    hostType.add("Classes");
    hostType.add("Party");


    setState(() {
      if(newEvent != null){
        color = newEvent.Type;
      }else if(newEvent == null){
        newEvent = new Event();
      }
    });


    var uuid = Uuid();
    eventId = uuid.v1();

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
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text("What will you host", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: hostType.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                itemBuilder: (context, index){
                  return Padding(
                    padding: const EdgeInsets.all(30),
                    child: GestureDetector(
                      // onTap: (){
                      //   newEvent.Type = hostType[index];
                      //   setState(() {
                      //     color = hostType[index];
                      //   });
                      // },
                      child: Container(
                        child: UnicornOutlineButton(
                          strokeWidth: 2,
                          radius: 100,
                          gradient: hostType[index] == color ? LinearGradient(
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                              colors: [Color(0xfffdb602), Color(0xfffdb602)]
                          ) :
                          LinearGradient(
                              end: const Alignment(0.0, -1),
                              begin: const Alignment(0.0, 0.6),
                              colors: [Color.fromRGBO(255,0,0,1), Color.fromRGBO(250, 238, 198, 1)]
                          ),
                          child: Text(hostType[index]),
                          onPressed: () {
                            setState(() {
                              newEvent.Type = hostType[index];
                              setState(() {
                                color = hostType[index];
                              });
                            });
                          },
                        ),
                      ),
                      // child: Card(
                      //   color: hostType[index] == color ? Color(0xfffdb602) : Color(0xfff1ead7),
                      //   elevation: 10,
                      //   child: Center(child: Text(hostType[index], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      //     textAlign: TextAlign.center)),
                      //   shape: RoundedRectangleBorder(
                      //     side: BorderSide(color: Colors.white70, width: 1),
                      //     borderRadius: BorderRadius.circular(100),
                      //   ),
                      // ),
                    ),
                  );
                }),
          ],
        ),
      ),

      floatingActionButton: Align(
        alignment: FractionalOffset.bottomLeft,
        child: Padding(
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context){
                          return Professional2(proUser: proUser);
                        }
                    ));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.amber)
                  ),
                  padding: EdgeInsets.all(8.0),
                ),
              ),
              RaisedButton(
                child: Text("Next"),
                color: Colors.amber,
                onPressed: () {
                  newEvent.EventID = eventId;
                  if(newEvent.Type != null) {
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>
                        EventDate(newEvent: newEvent, proUser: proUser)), (route) => false);
                  }else if(newEvent.Type == null){
                    Fluttertoast.showToast(
                        msg: "Select one option",
                        toastLength: Toast.LENGTH_SHORT,
                        backgroundColor: Colors.black);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.amber)
                ),
                padding: EdgeInsets.all(8.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}