var express = require('express');
var router = express.Router();
const middleware = require("../middleware");
var path = require('path');
var fs = require('fs')
var multer = require('multer')

const users = require("../controllers/user.controller.js");
const events = require("../controllers/event.controller.js");
const preferences = require("../controllers/preferences.controller.js");
const cantakepart = require("../controllers/cantakepart.controller.js");
const newspromo = require("../controllers/promo.controller.js");
const prouser = require("../controllers/prouser.controller.js");
const creditCards = require("../controllers/creditcards.controller.js");
const links = require('../controllers/links.controller');
const professionalUsers = require('../controllers/professionalUser.controller.js');

/// ------ Multer - Image and File Uploader ------ ///

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      const imageDir = './public/images';
      if (!fs.existsSync(imageDir)) {
          fs.mkdirSync(imageDir);
      }
  
      if (file.fieldname === "eventImage") {
        cb(null, imageDir);
      }
    },
    filename: (req, file, cb) => {
      if (file.fieldname == "eventImage") {
        req.body.imageUrl = "Event - " + Date.now() + path.extname(file.originalname);
        cb(null, req.body.imageUrl)
      }
    }
  });
  
  const upload = multer({
    storage: storage,
    limits:{
      fileSize: 1024 * 1024 * 6,
    },
  });
  
  /// --------------------------------------------- ///


router.post('/marketingtoggle', middleware.checkToken, links.marketingToggle)


router.post("/validateEmail", users.validateEmailFromServer);

router.get("/events", middleware.checkToken, events.findAllEvents);
router.post("/userEvents", middleware.checkToken, events.getUserEvents);
router.get("/preferences", preferences.getAllPreferences);
router.post("/cantakepart", middleware.checkToken, cantakepart.registerEvent);
router.post("/cannottakepart", middleware.checkToken, cantakepart.cannotTakePart);

router.post("/proevents", middleware.checkToken, events.getProUserEvents);


router.post("/updateUsersMeta", users.updateUsersMeta);
router.post("/getUsersMeta", users.getUserMeta);



router.get("/specialEvents", middleware.checkToken, events.getSpecialEvents);
router.post("/checkRegisteredEvent", middleware.checkToken, cantakepart.checkRegisteredEvent);
router.post("/whoisgoing", middleware.checkToken, cantakepart.getWhoIsGoing);
router.post("/whoisgoingprofessional", cantakepart.getWhoIsGoing);

// Get Main Screen Promo Events
router.get("/mainScreenPromo", middleware.checkToken, events.getMainScreenEvents);

router.get("/fullScreenPromo", middleware.checkToken, events.getFullScreenEvents);

router.post("/professionalUser", prouser.getEventPublisher);
router.post("/saveCalendarViewLink", prouser.saveCalendarViewLink);

router.post("/profilePicture", prouser.saveProfilePicture);
router.post("/secondaryProfilePicture", prouser.saveSecondaryProfilePicture);
router.post("/updateTitle", prouser.saveTitle);
router.post("/updateName", prouser.saveName);
router.post("/updateProUserLocation", middleware.checkToken, prouser.updateProfessionalUserLocation);

router.post("/updateCounter", newspromo.saveCounter);
router.post("/updateCounterMainScreenPromos", newspromo.saveCounterMainScreenPromo);
router.post("/updateCounterFullScreenPromos", newspromo.saveCounterFullScreenPromo);
router.post("/updateCounterSpecialScreenPromos", newspromo.saveCounterSpecialScreenPromo);

router.post("/userPreferences", middleware.checkToken, users.getUserPreferences);

router.get("/allGoingEvents", middleware.checkToken, cantakepart.getAllGoingEvents);

router.post("/saveCardInfo", creditCards.saveCardInfo);
router.post("/creditCard", creditCards.getCreditCardInfo);

// Create a new User
router.post("/createNewUser", users.create);

// User Login
router.post("/userLogin", users.login);
// admin login route
router.post('/adminLogin', users.loginFromPortal);
router.post("/autoLogin", middleware.checkToken, users.autoLogin);
router.post('/updateUser', middleware.checkToken, users.update);
router.post('/deleteUser', middleware.checkToken, users.delete);

router.post("/createNewEvent", events.createEvent);
router.post("/specificEvent", events.getSpecificEventDetails);

router.post("/createNewEventFromPortal", events.createEventFromPortal);

router.post("/createNewNewsPromo", newspromo.create);
router.post("/createNewMainScreenPromo", newspromo.createMainScreenPromo);
router.post("/createNewFullScreenPromo", newspromo.createFullScreenPromo);

router.get("/externalPromos", middleware.checkToken, newspromo.getExternalPromos);

router.get("/getSpecialScreenPromo", middleware.checkToken, newspromo.getSpecialScreenPromo);
router.get("/getMainScreenPromo", middleware.checkToken, newspromo.getMainScreenPromos);
router.get("/getFullScreenPromo", middleware.checkToken, newspromo.getFullScreenPromos);

// Get Pro User Promos

router.post("/getProUserSpecialScreenPromo", middleware.checkToken, newspromo.getProUserSpecialScreenPromo);
router.post("/getProUserMainScreenPromo", middleware.checkToken, newspromo.getProUserMainScreenPromos);
router.post("/getProUserFullScreenPromo", middleware.checkToken, newspromo.getProUserFullScreenPromos);


// Portal Routes Promotions

router.post("/editPromotion", middleware.checkToken, newspromo.editPromotion);
router.post('/deletePromotion', middleware.checkToken, newspromo.deletePromo);

// Portal Router - Preferences

router.post('/addNewPreference', middleware.checkToken, preferences.addNewPreference);


// Get Pro User Promos

router.post("/getProfessionalUser", prouser.getProfessionalUser);
router.post("/professionalAutoLogin", middleware.checkToken, prouser.getProfessionalUser);

router.post("/userProfilePicture", middleware.checkToken, users.getUserProfilePicture);
router.post("/updateUserProfilePicture", middleware.checkToken, users.updateProfilePicture);
router.post("/updateUserName", middleware.checkToken, users.updateName);
router.post("/updateLocation", middleware.checkToken, users.updateLocation);

// Event Update Endpoints ------------------------------------------------------------------ //

router.post("/updateEventTitle", events.updateEventTitle);
router.post("/updateEventStartDate", events.updateEventStartDate);
router.post("/updateEventStartTime", events.updateEventStartTime);
router.post("/updateEventEndTime", events.updateEventEndTime);
router.post("/updateEventImage", events.updateEventImage);
router.post("/updateDescription", events.updateDescription);
router.post("/updateLocation", events.updateLocation);

// Added Event update and delete
router.post('/updateEvent',middleware.checkToken, events.updateEvent);

// Event Update Endpoints ------------------------------------------------------------------ //

// Link  Endpoints ------------------------------------------------------------------

router.get('/findAllLinks', links.findAllLinks);
router.post('/updateLink', middleware.checkToken, links.updateLink)

// Link  Endpoints ------------------------------------------------------------------ //

// Portal Routes //
router.get("/allUsers", middleware.checkToken, users.findAllUsers);
router.get("/getAllEvents", middleware.checkToken, events.findAllEvents);
router.post("/createNewUserFromPortal",middleware.checkToken, users.createUser);
router.get('/findAllProUsers', middleware.checkToken, professionalUsers.findAllProUsers);
router.post('/updatePromoPrice', middleware.checkToken, newspromo.updatePromoPrice);

//

// Delete Account //
router.post("/deleteAccount", middleware.checkToken, users.deleteAccount);
router.post("/deleteProfessionalAccount", middleware.checkToken, prouser.deleteProfessionalAccount);
router.get('/findAllProUsers', professionalUsers.findAllProUsers);
// For Professional Users
router.post('/createNewProfessionalUserFromPortal', middleware.checkToken, professionalUsers.createProfessionalUser);
router.post('/deleteProUser', middleware.checkToken, professionalUsers.deleteProUser);
router.post('/updateProUser',middleware.checkToken, professionalUsers.updateProUser);
router.post('/editDescription', middleware.checkToken, professionalUsers.editDescriptionFromApp);
router.post('/updatePreferences', users.updatePreferences);
router.post('/updateProfessionalUserPreferences', users.updateProfessionalUserPreferences);


router.post('/GetProIDofEvent', middleware.checkToken, events.FindProIDOfEvent);
router.post('/GetProfessionalObject', middleware.checkToken, events.GetProfessionalObject);




router.post('/forgotPasswordFromPortal', users.forgotPasswordPortal);

router.post('/addCountry', events.addCountry);
router.get('/getCountry', events.getCountry);


// ----------------- New APIs ----------------- //

// Add Events //

router.post('/addEvent', upload.fields(
    [{
      name: 'eventImage', maxCount: 1
      }
    ]), events.addEvent);

// Edit Event //

router.post('/editEvent', upload.fields(
  [{
    name: 'eventImage', maxCount: 1
    }
  ]), events.editEvent);

// Delete Event //

router.post('/deleteEvent', events.deleteEvent);

// Get Specific Event //

router.post('/getEvent', events.getEvent);

// Get User Events //

router.post('/getUserEvents', events.getUserEvent);

// Get Events By Filters //

router.post('/getEventsByFilters', events.getEventsByFilters);

// Get Events By Filters Mobile //

router.post('/getEventsByFiltersMobile', events.getEventsByFiltersMobile);

// Professional User Login //

router.post("/professionalLogin", professionalUsers.professionalUserLogin);

// Add Professional User Styles //

router.post("/addProfessionalStyles", professionalUsers.addProfessionalStyles);

// Get Professional User Styles //

router.post("/getProfessionalStyles", professionalUsers.getProfessionalStyles);

// Get Calendar Link //

router.post("/getCalendarLink", professionalUsers.getCalendarLink);

// Update User Location //

router.post("/updateUserLocation", professionalUsers.updateUserLocation);

// ------------------------------------------ //


router.get('*',(req,res) =>{
    res.sendFile('/opt/bitnami/apps/myapp/public/index.html');
});



module.exports = router;
