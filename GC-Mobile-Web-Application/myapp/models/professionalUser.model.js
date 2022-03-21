const sql = require("./db.js");
const config = require("../config.js");
const jwt = require("jsonwebtoken");
var bcrypt = require('bcrypt');

const User = function (user) {
    this.userID = user.userID;
    this.FirstName = user.FirstName;
    this.LastName = user.LastName;
    this.title = user.title;
    this.Email = user.Email;
    this.username = user.username;
    this.password = user.password;
    this.StreetAddress = user.StreetAddress;
    this.Country = user.Country;
    this.ZipCode = user.ZipCode;
    this.ContactNumber = user.ContactNumber;
    this.profilePictureLink = user.profilePictureLink;
    this.secondaryProfilePictureLink = user.secondaryProfilePictureLink;
    this.calenderViewLink = user.calenderViewLink;
    this.backStageCode = user.backStageCode;
    this.description = user.description;
    this.city = user.city;

};

function hashPassword(password){
    return bcrypt.hashSync(password, 10);
  }
  function isValid(inputPassword, hashPassword){
    return bcrypt.compareSync(inputPassword, hashPassword);
  }

User.editDescriptionFromApp = (userID, description, result) => {
    sql.query("UPDATE professionalusers SET description=? WHERE userID =? ",
        [description, userID],  (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(null, err);
                return;
            }
            if (res.affectedRows === 0) {
                // not found Customer with the id
                result({ kind: "not_found user" }, null);
                return;
            }
            result(null, { id: userID });
        }
    )
}


// Portal Functions

User.allProUsers = (result) => {
    sql.query("SELECT * FROM professionalusers",(err, res) => {
        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        }

        if (res.length) {
            result(null, res);
            return;
        }
        result(null, res);
    });
};

User.createProfessionalUserFromPortal = (newUser, result) => {

    sql.query("INSERT INTO professionalusers SET ?", newUser, (err, res) => {
        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else if (res) {
            result(null, newUser);
            return;
        }
    });
};


User.remove = (email, result) => {
    sql.query("DELETE FROM professionalusers WHERE email = ?", email, (err, res) => {
        if (err) {
            console.log("error: ", err);
            result(null, err);
            return;
        }

        if (res.affectedRows === 0) {
            // not found Customer with the id
            result({ kind: "not_found" }, null);
            return;
        }

        console.log("deleted user with id: ", email);
        result(null, res);
    });
};


User.updateUser = (userID, user, result) => {
    console.log("this is reached");
    sql.query("UPDATE professionalusers SET firstName =?,lastName =?,username=?,  email=?,  password = ?,title=?, streetAddress=?," +
        "backStageCode=?,country=?,zipCode=?,contactNumber=?, profilePictureLink=?, secondaryProfilePictureLink=?, calenderViewLink=?, description=? WHERE userID = ?",
        [user.firstName,user.lastName, user.username,user.email, user.password, user.title, user.streetAddress, user.backStageCode,
             user.country, user.zipCode, user.contactNumber, user.profilePictureLink, user.secondaryProfilePictureLink, user.calenderViewLink,user.description, userID], (err, res) => {
            if (err) {
                console.log("error: ", err);
                result(null, err);
                return;
            }
            if (res.affectedRows === 0) {
                // not found Customer with the id
                result({ kind: "not_found user" }, null);
                return;
            }

            console.log("updated user: ", { id: userID, ...user });
            result(null, { id: userID, ...user });
        }
    );
};


User.professionalUserLogin = (user, result) => {
    let query = `SELECT * FROM professionalusers WHERE email = '${user.email}'`;
    sql.query(query, (err, res) => {
      if (err) {
        console.log("error: ", err);
        result(err, null);
        return;
      }
      if(res.length){
        if (user.password === res[0].backStageCode) {
            let token = jwt.sign({email: user.email}, config.key, {
                expiresIn: "24h",
              });
              result(null, {userId: res[0].userID, username: res[0].username, location: res[0].city, token});
              return;
        }
        else {
            result(null, {message:"Invalid Password!"});
            return;
        }
      }
      else {
        result(null, {message:"Invalid Email!"});
      }
    });
};

User.addProfessionalStyles = (user, result) => {
    let query = ""
    if (user.styles.length <= 0) {
        query = `UPDATE professionalusers SET preference1 = ${null}, preference2 = ${null}, preference3 = ${null} WHERE UserID = '${user.userId}'`;
        sql.query(query, (err, res) => {
          if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
          }
          else {
              result(null, {status: true, message: "Styles Updated!"})
          }
        })
    }
    if (user.styles.length === 1) {
        query = `UPDATE professionalusers SET preference1 = '${user.styles[0]}', preference2 = ${null}, preference3 = ${null} WHERE UserID = '${user.userId}'`;
        sql.query(query, (err, res) => {
          if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
          }
          else {
              result(null, {status: true, message: "Styles Updated!"})
          }
        })
    }
    if (user.styles.length === 2) {
        query = `UPDATE professionalusers SET preference1 = '${user.styles[0]}', preference2 = '${user.styles[1]}', preference3 = ${null} WHERE UserID = '${user.userId}'`;
        sql.query(query, (err, res) => {
          if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
          }
          else {
              result(null, {status: true, message: "Styles Updated!"})
          }
        })
    }
    if (user.styles.length === 3) {
        query = `UPDATE professionalusers SET preference1 = '${user.styles[0]}', preference2 = '${user.styles[1]}', preference3 = '${user.styles[2]}' WHERE UserID = '${user.userId}'`;
        sql.query(query, (err, res) => {
          if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
          }
          else {
              result(null, {status: true, message: "Styles Updated!"})
          }
        })
    }
};

User.getProfessionalStyles = (userId, result) => {
    let query = `SELECT userID, preference1, preference2, preference3 FROM professionalusers WHERE UserID = '${userId}'`;
    sql.query(query, (err, res) => {
        if (err) {
        console.log("error: ", err);
        result(err, null);
        return;
        }
        else {
            result(null, {status: true, styles: res[0]})
        }
    })
};

User.getCalendarLink = (userId, result) => {
    let query = `SELECT calenderViewLink FROM professionalusers WHERE UserID = '${userId}'`;
    sql.query(query, (err, res) => {
        if (err) {
        console.log("error: ", err);
        result(err, null);
        return;
        }
        else {
            result(null, {status: true, calendar: res[0]})
        }
    })
};

User.updateUserLocation = (location, result) => {
    let query = `UPDATE professionalusers SET city = '${location.location}' WHERE UserID = '${location.userId}'`;
    sql.query(query, (err, res) => {
        if (err) {
        console.log("error: ", err);
        result(err, null);
        return;
        }
        else {
            result(null, {status: true, message: "Location Updated!"})
        }
    })
};

module.exports = User;
