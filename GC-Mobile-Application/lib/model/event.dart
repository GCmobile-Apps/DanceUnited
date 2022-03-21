class Event {
  String EventID;
  String Title;
  String Description;
  String StartDate;
  String EndDate;
  String Location;
  String Prize;
  String Type;
  String ImageUrl;
  String Tags;
  String notRepeat;
  String startTime;
  String endTime;
  String relatedStyle1;
  String relatedStyle2;
  String relatedStyle3;
  int viewCounter;
  String SeriesEndDate;
  String CompleteAddress;

  Map<String, dynamic> toJson() => {
        'EventID': EventID,
        'Title': Title,
        'Description': Description,
        'StartDate': StartDate,
        'EndDate': EndDate,
        'Location': Location,
        'Prize': Prize,
        'Type': Type,
        'ImageUrl': ImageUrl,
        'Tags': Tags,
        'notRepeat': notRepeat,
        'startTime': startTime,
        'endTime': endTime,
        'relatedStyle1': relatedStyle1,
        'relatedStyle2': relatedStyle2,
        'relatedStyle3': relatedStyle3,
        'viewCounter': viewCounter,
        'SeriesEndDate':SeriesEndDate,
        'CompleteAddress':CompleteAddress
      };
}
