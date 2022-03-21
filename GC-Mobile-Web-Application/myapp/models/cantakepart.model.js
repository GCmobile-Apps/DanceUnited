const sql = require("./db.js");

const CanTakePart = function (cantakepart) {
    this.UserID = cantakepart.UserID;
    this.EventID = cantakepart.EventID;
};

CanTakePart.CannotTakePart = (UserId , EventID , result) => {

    console.log("This is what i recieved");
    console.log(UserId);
    console.log(EventID);
    sql.query("DELETE FROM cantakepart WHERE UserId =  ? && EventID = ?",[ UserId, EventID ], (err, res) => {
        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else if (res) {
            result(null, res);
            return;
        }
    });
};


CanTakePart.register = (registerEvent, result) => {
    sql.query("INSERT INTO cantakepart SET ?", registerEvent, (err, res) => {

        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else if (res) {
            result(null, res);
            return;
        }
    });
};

CanTakePart.checkEvent = (eventID, userID, result) => {

    sql.query("Select * FROM cantakepart WHERE EventID = ? AND UserId = ?", [eventID, userID], (err, res) => {

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

CanTakePart.whoIsGoing = (eventID, result) => {
    var userIds = [];
    var container = [];
    var subQueryResult;

    sql.query("Select * FROM cantakepart WHERE EventID = ?", eventID, (err, res) => {

        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else {
            for (var i = 0; i < res.length; i++) {
                userIds.push(res[i].UserId);
            }
            container.push(userIds);
            
            subQueryResult = sql.query("SELECT * FROM users WHERE UserID IN (?)", container, 
            (err, res2) => {
                if (err) {
                  console.log("error: ", err);
                  result(err, null);
                  return;
                }
            
                if (res2.length) {
                  result(null, res2);
                  return;
                }
                result({ kind: "not_found" }, null);
              });
            return subQueryResult;
        }
    });
};

CanTakePart.allGoingEvents = (result) => {

    sql.query("Select * FROM cantakepart", (err, res) => {

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


module.exports = CanTakePart;
