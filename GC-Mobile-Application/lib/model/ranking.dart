class Ranking {
  String userID;
  int numberOfEventsGoing;

  Map<String, dynamic> toJson() => {
    'userID'  : userID,
    'numberOfEventsGoing' : numberOfEventsGoing
  };
}