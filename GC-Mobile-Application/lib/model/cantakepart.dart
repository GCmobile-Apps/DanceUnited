class CanTakePart {
  String UserID;
  String EventID;
  int Preference;
  int Attending;

  Map<String, dynamic> toJson() => {
    'UserID'  : UserID,
    'EventID' : EventID
  };
}