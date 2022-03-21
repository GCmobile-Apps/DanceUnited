import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestResult{
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

const PROTOCOL = "https";
const DOMAIN = "danceunited.eu";

Future<RequestResult> userLogin(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> updateuserMeta(String route, [dynamic data]) async
{
  print("Sending request to the backend");
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}


Future<RequestResult> getuserMeta(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> validateEmailFromServer(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> autoLogin(String route, String token, [dynamic data]) async
{

  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getSingleUserDataFromServer(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getEventsFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> postRequestEventsToServer(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";

  var result = await http.post(url, body: jsonEncode({"filters": data}), headers:{"Content-Type":"application/json"});

  print("THis is the result");
  print(result.body);
  return RequestResult(true, jsonDecode(result.body));
}





Future<RequestResult> getAllUsersFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getAllUsersForAppleSignin(String route) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}


Future<RequestResult> getAllGoingEvents(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getProEventsFromServer(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getPromosFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  //var dataStr = jsonEncode(data);
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getUserEvents(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getUserPreferences(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getPreferencesFromServer(String route) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url,headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> createNewUser(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> registerEvent(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> UnGoingEvent(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  print("I have recieved the response");
  print(result);
  return RequestResult(true, jsonDecode(result.body));
}


Future<String> createNewEvent(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.body;
}

Future<int> postEventCountry(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  print(dataStr);
  print(url);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<RequestResult> getEventCountry(String route, [dynamic data]) async
{

  var queryParameters = {
    'eventId': data,
  };
  String queryString = Uri(queryParameters: queryParameters).query;
  var url = "$PROTOCOL://$DOMAIN/$route";
  var requestUrl = url + '?' + queryString;
  var result = await http.get(requestUrl, headers:{"Content-Type":"application/x-www-form-urlencoded"});
  return RequestResult(true, jsonDecode(result.body));
  //var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  //return RequestResult(true, jsonDecode(result.body));
}

Future<String> patchImage(String url, String filePath, String fileName, String folderName) async{
  var urlImage = "$PROTOCOL://$DOMAIN/$url";
  var request = http.MultipartRequest('PATCH', Uri.parse(urlImage));
  request.fields['fileName'] = fileName;
  request.fields['folderName'] = folderName;
  request.files.add(await http.MultipartFile.fromPath("img", filePath));
  request.headers.addAll({
    "Content-type": "multipart/form-data",
  });
  http.Response response = await http.Response.fromStream(await request.send());
  return response.body;
}

Future<int> createNewNewsPromo(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<RequestResult> getSpecialEventsFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getExternalPromosFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<int> createNewMainScreenPromo(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<RequestResult> getMainScreenPromoEventsFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getFullScreenPromoEventsFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<int> saveCardInformation(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<RequestResult> checkEvent(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> whoIsGoing(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> whoIsGoingForProfessional(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getEventPublisherFromServer(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<int> saveCalendarViewLink(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> saveProfilePicture(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  print(url);
  print(dataStr);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}
Future<int> saveSecondaryProfilePicture(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}
Future<int> saveTitle(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}
Future<int> saveName(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> saveDescription(String route,token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json","Authorization": token});
  return result.statusCode;
}

Future<int> updateProfessionalUserLocation(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}

Future<int> saveCounter(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}

Future<RequestResult> getCreditCardInformation(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getProfessionalUserFromServer(String route, [dynamic data]) async
{
  var queryParameters = {
    'backStageCode': data,
  };
  String queryString = Uri(queryParameters: queryParameters).query;
  var url = "$PROTOCOL://$DOMAIN/$route";
  var requestUrl = url + '?' + queryString;
  var dataStr = jsonEncode(data);
  var result = await http.post(requestUrl, body: null,encoding: Encoding.getByName("utf-8"), headers:{"Content-Type":"application/x-www-form-urlencoded"});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> professionalUserAutoLogin(String route, String token, [dynamic data]) async
{
  var queryParameters = {
    'backStageCode': data,
  };
  String queryString = Uri(queryParameters: queryParameters).query;
  var url = "$PROTOCOL://$DOMAIN/$route";
  var requestUrl = url + '?' + queryString;
  var dataStr = jsonEncode(data);
  var result = await http.post(requestUrl, body: null, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<RequestResult> getUserProfilePictureFromServer(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}

Future<int> updateUserProfilePicture(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}

Future<int> updateUserName(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}

Future<int> updatePreference(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}


Future<int> updateProfessionalUserPreference(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}
//
//
//
// Future<int> addProfessionalStyles(String route, String token, [dynamic data]) async
// {
//   var url = "$PROTOCOL://$DOMAIN/$route";
//   var dataStr = jsonEncode(data);
//   var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
//   return result.statusCode;
// }

Future<RequestResult> getprofessionalStyles(String route,String token,[dynamic data]) async
{

  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url,body: dataStr, headers:{"Content-Type":"application/json"});
print("professional style");
print(jsonDecode(result.body));
  return RequestResult(true, jsonDecode(result.body));

}


Future<RequestResult> postprofessionalStyles(String route, [dynamic data]) async
{


  var url = "$PROTOCOL://$DOMAIN/$route";

  var result = await http.post(url, body: jsonEncode({"user": data}), headers:{"Content-Type":"application/json"});
  print("postupdateProfessionalUserPreference");
  print(result.body);
  return RequestResult(true, jsonDecode(result.body));
}
//
//
//


Future<int> updateUserLocation(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}

Future<RequestResult> getSpecificEventFromServer(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}

// Event Update Functions ----------------------------------------------------------------------------------------------------//
Future<int> updateEventTitle(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> updateEventStartDate(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> updateEventStartTime(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> updateEventEndTime(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> updateEventImageInDb(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> updateEventDescription(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}

Future<int> updateEventLocation(String route, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json"});
  return result.statusCode;
}
// Event Update Functions ----------------------------------------------------------------------------------------------------//

// Delete Account ------------------------------------------------------------------------------------------------------------//
Future<int> deleteUserAccount(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}
Future<int> deleteProfessionalAccount(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return result.statusCode;
}
// Delete Account ------------------------------------------------------------------------------------------------------------//

// Get fullscreen promo and main screen promo --------------------------------------------------------------------------------//
Future<RequestResult> getSpecialScreenPromosFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getMainScreenPromosFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getFullScreenPromosFromServer(String route, String token) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
// Get fullscreen promo and main screen promo --------------------------------------------------------------------------------//

// Get pro user promos  -------------------------------------------------------------------------------------------------------//
Future<RequestResult> getProUserSpecialScreenPromosFromServer(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getProUserMainScreenPromosFromServer(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
Future<RequestResult> getProUserFullScreenPromosFromServer(String route, String token, [dynamic data]) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var dataStr = jsonEncode(data);
  var result = await http.post(url, body: dataStr, headers:{"Content-Type":"application/json", "Authorization": token});
  return RequestResult(true, jsonDecode(result.body));
}
// Get pro user promos  ------------------------------------------------------------------------------------------------------//

// Get Links -----------------------------------------------------------------------------------------------------------------//
Future<RequestResult> getLinksFromServer(String route) async
{
  var url = "$PROTOCOL://$DOMAIN/$route";
  var result = await http.get(url, headers:{"Content-Type":"application/json"});
  return RequestResult(true, jsonDecode(result.body));
}
// Get Links -----------------------------------------------------------------------------------------------------------------//