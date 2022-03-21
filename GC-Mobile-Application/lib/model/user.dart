class User {
  String UserID;
  String FirstName;
  String LastName;
  String Email;
  String username;
  String password;
  String StreetAddress;
  String City;
  String Country;
  String ZipCode;
  String ContactNumber;
  String profilePictureLink;
  String type;
  String Preference1;
  String Preference2;
  String Preference3;

  Map<String, dynamic> toJson() => {
    'UserID'             : UserID,
    'FirstName'          : FirstName,
    'LastName'           : LastName,
    'Email'              : Email,
    'username'           : username,
    'password'           : password,
    'StreetAddress'      : StreetAddress,
    'City'               : City,
    'Country'            : Country,
    'ZipCode'            : ZipCode,
    'ContactNumber'      : ContactNumber,
    'profilePictureLink' : profilePictureLink,
    'type'               : type,
    'Preference1'        : Preference1,
    'Preference2'        : Preference2,
    'Preference3'        : Preference3
  };
}