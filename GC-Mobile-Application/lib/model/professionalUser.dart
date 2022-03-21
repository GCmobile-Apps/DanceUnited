class ProfessionalUser {
  String UserID;
  String FirstName;
  String LastName;
  String title;
  String Email;
  String username;
  String password;
  String StreetAddress;
  String City;
  String Country;
  String type;
  String ZipCode;
  String ContactNumber;
  String profilePictureLink;
  String secondaryProfilePictureLink;
  String calenderViewLink;
  String backStageCode;
  String description;
  String Preference1;
  String Preference2;
  String Preference3;


  Map<String, dynamic> toJson() => {
        'UserID': UserID,
        'FirstName': FirstName,
        'LastName': LastName,
        'title': title,
        'Email': Email,
        'username': username,
        'password': password,
        'StreetAddress': StreetAddress,
        'City': City,
        'Country': Country,
        'type': type,
        'ZipCode': ZipCode,
        'ContactNumber': ContactNumber,
        'profilePictureLink': profilePictureLink,
        'secondaryProfilePictureLink': secondaryProfilePictureLink,
        'calenderViewLink': calenderViewLink,
        'backStageCode': backStageCode,
        'preference1': Preference1,
        'preference2': Preference2,
        'preference3': Preference3,

  };
}
