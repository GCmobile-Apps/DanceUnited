class EventPreferences {
  String EventID;
  String PreferenceID;

  Map<String, dynamic> toJson() => {
    'EventID'      : EventID,
    'PreferenceID' : PreferenceID,
  };
}