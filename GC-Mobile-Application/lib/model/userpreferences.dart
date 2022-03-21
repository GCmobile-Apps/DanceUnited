class UserPreferences {
  String userID;
  String preferenceID;

  Map<String, dynamic> toJson() => {
    'userID'      : userID,
    'preferenceID' : preferenceID,
  };
}