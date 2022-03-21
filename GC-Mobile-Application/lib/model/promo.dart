class Promo {
  String promoID;
  String EventID;
  String userID;
  String promoType;
  String offerTitle;
  String promoImageUrl;
  String destinationLink;
  String mainStyle;
  String relatedStyle1;
  String relatedStyle2;
  String relatedStyle3;
  String promoCity;
  String promoCountry;
  String promoAddress;
  int viewCounter;
  double percentage;

  Map<String, dynamic> toJson() => {
        'promoID': promoID,
        'eventID': EventID,
        'userID': userID,
        'promoType': promoType,
        'offerTitle': offerTitle,
        'promoImageUrl': promoImageUrl,
        'destinationLink': destinationLink,
        'mainStyle': mainStyle,
        'relatedStyle1': relatedStyle1,
        'relatedStyle2': relatedStyle2,
        'relatedStyle3': relatedStyle3,
        'promoCity': promoCity,
        'promoCountry' : promoCountry,
        'promoAddress' : promoAddress,
        'viewCounter': viewCounter
      };
}
