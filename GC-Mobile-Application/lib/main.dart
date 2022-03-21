import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:united_app/explore.dart';
import 'package:united_app/model/professionalUser.dart';
import 'package:united_app/model/user.dart';
import 'package:united_app/professional/professional2.dart';
import 'ServerRequests/http.dart';
import 'first.dart';
import 'package:crypt/crypt.dart';

import 'homescreen.dart';
import 'model/loading.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  ); // To turn off landscape mode
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'United App',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final storage = new FlutterSecureStorage();
  User user = new User();

  continueLogin(email, password, token) async {
    var result = await autoLogin("autoLogin", token, {"email": email});
    if (result.data['status'] == true) {
      final h = Crypt(result.data['data'][0]['password']);
      if (h.match(password)) {
        user.UserID = result.data['data'][0]['UserID'];
        user.FirstName = result.data['data'][0]['FirstName'];
        user.LastName = result.data['data'][0]['LastName'];
        user.username = result.data['data'][0]['username'];
        user.password = result.data['data'][0]['password'];
        user.StreetAddress = result.data['data'][0]['StreetAddress'];
        user.City = result.data['data'][0]['City'];
        user.Country = result.data['data'][0]['Country'];
        user.ZipCode = result.data['data'][0]['Zipcode'];
        user.ContactNumber = result.data['data'][0]['ContactNumber'];
        user.Email = result.data['data'][0]['Email'];
        user.profilePictureLink = result.data['data'][0]['profilePictureLink'];
        user.Preference1 = result.data['data'][0]['Preference1'];
        user.Preference2 = result.data['data'][0]['Preference2'];
        user.Preference3 = result.data['data'][0]['Preference3'];
        Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => HomeScreen(newUser: user), transitionDuration: Duration(seconds: 0)));
        //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Explore(newUser: user)), (route) => false);
      }
    }
    else if (result.data['status'] == false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Fluttertoast.showToast(
          msg: "Session expired.Sign in again",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);

    }
  }

  continueProfessionalLogin(backStageCode, professionalToken) async {
    var result = await professionalUserAutoLogin("professionalAutoLogin", professionalToken, backStageCode);

    if (result.data['status'] == true) {
      await storage.write(key: "professionalToken", value: result.data['token']);
      ProfessionalUser proUser = new ProfessionalUser();
      proUser.UserID = result.data['data'][0]['userID'];
      proUser.FirstName = result.data['data'][0]['firstName'];
      proUser.LastName = result.data['data'][0]['lastName'];
      proUser.title = result.data['data'][0]['title'];
      proUser.username = result.data['data'][0]['username'];
      proUser.password = result.data['data'][0]['password'];
      proUser.Email = result.data['data'][0]['email'];
      proUser.City = result.data['data'][0]['city'];
      proUser.StreetAddress = result.data['data'][0]['streetAddress'];
      proUser.Country = result.data['data'][0]['country'];
      proUser.profilePictureLink = result.data['data'][0]['profilePictureLink'];
      proUser.secondaryProfilePictureLink = result.data['data'][0]['secondaryProfilePictureLink'];
      proUser.calenderViewLink = result.data['data'][0]['calenderViewLink'];
      proUser.backStageCode = result.data['data'][0]['backStageCode'];

      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => Professional2(proUser: proUser)), (route) => false);
    }
    else if (result.data['status'] == false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Fluttertoast.showToast(
          msg: "Session expired.Sign in again",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);

    }
  }

  checkSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    var password = prefs.getString('password');
    var token = prefs.getString('token');
    var backStageCode = prefs.getString('backStageCode');
    var professionalToken = prefs.getString('professionalToken');

    if (email != null && password != null && token != null) {
      continueLogin(email, password, token);
    } else if (backStageCode != null && professionalToken != null) {
      continueProfessionalLogin(backStageCode, professionalToken);
    } else {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainPage()), (route) => false);
    }
  }

  @override
  void initState() {
    checkSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xfffede71),
                const Color(0xffffc135),
                const Color(0xffffa901),
                const Color(0xffff7829),
                const Color(0xffff3f58),
              ], // red to yellow
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Lets Dance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                SizedBox(height: 10),
                SizedBox(
                  width: 100, height:100,
                    child: Loading2()
                ),
                //CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}