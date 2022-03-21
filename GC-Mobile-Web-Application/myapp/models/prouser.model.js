const sql = require("./db.js");
const config = require("../config.js");
const jwt = require("jsonwebtoken");

const ProUser = function (prouser) {
    this.UserID = prouser.UserID;
    this.FirstName = prouser.FirstName;
    this.LastName = prouser.LastName;
    this.Email = prouser.Email;
    this.username = prouser.username;
    this.password = prouser.password;
    this.StreetAddress = prouser.StreetAddress;
    this.City = prouser.City;
    this.Country = prouser.Country;
    this.ZipCode = prouser.ZipCode;
    this.ContactNumber = prouser.ContactNumber;
    this.profilePictureLink = prouser.profilePictureLink;
};

var professionalUser;
ProUser.getPublisher = (eventID, result) => {
    sql.query("SELECT * FROM professionaluserevents WHERE eventID =  ?", eventID, (err, res) => {
        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else {
            professionalUser = sql.query("SELECT * FROM professionalusers WHERE userID =  ?", res[0].userID, (err2, res2) => {
                if (err) {
                    console.log("error: ", err2);
                    result(err, null);
                    return;
                } else {
                    result(null, res2);
                    return;
                }
            });
            return professionalUser;
        }
    });
};

ProUser.saveCalendarView = (userID, calendarViewLink, result) => {

    sql.query("UPDATE professionalusers SET calenderViewLink = ? WHERE userID = ?",
        [calendarViewLink, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(err, null);
                return;
            } else {
                result(null, res);
                return;
            }
        });
};

ProUser.saveProfilePictureInDb = (userID, profilePictureLink, result) => {

    sql.query("UPDATE professionalusers SET profilePictureLink = ? WHERE userID = ?",
        [profilePictureLink, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(err, null);
                return;
            } else {
                result(null, res);
                return;
            }
        });
};

ProUser.saveSecondaryProfilePictureInDb = (userID, secondaryProfilePictureLink, result) => {

    sql.query("UPDATE professionalusers SET secondaryProfilePictureLink = ? WHERE userID = ?",
        [secondaryProfilePictureLink, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(err, null);
                return;
            } else {
                result(null, res);
                return;
            }
        });
};

ProUser.saveTitleInDb = (userID, title, result) => {

    sql.query("UPDATE professionalusers SET title = ? WHERE userID = ?",
        [title, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(err, null);
                return;
            } else {
                result(null, res);
                return;
            }
        });
};

ProUser.saveNameInDb = (userID, name, result) => {

    sql.query("UPDATE professionalusers SET firstName = ? WHERE userID = ?",
        [name, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(err, null);
                return;
            } else {
                result(null, res);
                return;
            }
        });
};


ProUser.getProfessionalUserFromServer = (backStageCode, result) => {
    sql.query("SELECT * FROM professionalusers WHERE backStageCode = ?", backStageCode, (err2, res2) => {
            if (err2) {
                console.log("error: ", err2);
                result(err, null);
                return;
            } else if(res2.length){
                let token = jwt.sign({backStageCode: backStageCode}, config.key, {
                    expiresIn: "24h",
                });
                result(null, res2, token);
                return;
            }else{
                result(null, null, null);
                return;
            }
        });
};

ProUser.updateProUserLocationInDb = (userID, address, country, city, result) => {

    console.log('Heres the address');
    console.log(address);
    console.log(country);
    console.log(city);

    sql.query("UPDATE professionalusers SET streetAddress = ?, country=?, city=? WHERE userID = ?",
        [address,country,city, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(err, null);
                return;
            } else {
                result(null, res);
                return;
            }
        });
};

ProUser.deleteProfessionalUserAccount = (userID, result) => {
    var eventIds = [];
    var container = [];

    sql.query("DELETE FROM professionalusers WHERE userID = ?", userID, (err, res) => {});
    sql.query("SELECT * FROM professionaluserevents WHERE userID = ?", userID, (err, res) => {
        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }
        if (res.length) {
            for (var i = 0; i < res.length; i++) {
                eventIds.push(res[i].eventID);
            }
            container.push(eventIds);
            sql.query("DELETE FROM event WHERE EventID IN (?)", container, (err, res2) => {});
        }
    });
    sql.query("DELETE FROM professionaluserevents WHERE userID = ?", userID, (err, res) => {});
    sql.query("DELETE FROM newspromo WHERE userID = ?", userID, (err, res) => {});
    sql.query("DELETE FROM mainscreenpromo WHERE userID = ?", userID, (err, res) => {});
    sql.query("DELETE FROM fullscreenpromo WHERE userID = ?", userID, (err, res) => {
        if (err) {
            result(err, null);
            return;
        }
        if (res) {
            result(null, res);
            return;
        }
    });
    console.log("Reached = ");
};


module.exports = ProUser;
