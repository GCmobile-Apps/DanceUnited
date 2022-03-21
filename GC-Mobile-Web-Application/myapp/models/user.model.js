const sql = require("./db.js");
const config = require("../config.js");
const jwt = require("jsonwebtoken");
var bcrypt = require('bcrypt');
const nodemailer = require('nodemailer');

const User = function (user) {
  this.UserID = user.UserID;
  this.FirstName = user.FirstName;
  this.LastName = user.LastName;
  this.Email = user.Email;
  this.username = user.username;
  this.password = user.password;
  this.StreetAddress = user.StreetAddress;
  this.City = user.City;
  this.Country = user.Country;
  this.ZipCode = user.ZipCode;
  this.ContactNumber = user.ContactNumber;
  this.profilePictureLink = user.profilePictureLink;
  this.Preference1 = user.Preference1;
  this.Preference2 = user.Preference2;
  this.Preference3 = user.Preference3;
};


function hashPassword(password){
  return bcrypt.hashSync(password, 10);
}
function isValid(inputPassword, hashPassword){
  return bcrypt.compareSync(inputPassword, hashPassword);
}





User.create = (newUser, result) => {

  sql.query("INSERT INTO users SET ?", newUser, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    } else if (res) {
      let token = jwt.sign({email: newUser.Email}, config.key, {
        expiresIn: "24h",
      });
      result(null, newUser, token);
      return;
    }
  });
};

User.allUsers = (result) => {
  sql.query("SELECT * FROM users",(err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

User.signin = (email, result) => {
  sql.query("SELECT * FROM users WHERE email = ?", email, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      let token = jwt.sign({email: email}, config.key, {
        expiresIn: "24h",
      });
      result(null, res, token);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

User.validateEmail = (email, result) => {
  sql.query("SELECT * FROM users WHERE email = ?", email, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

User.userAutoLogin = (email, result) => {
  sql.query("SELECT * FROM users WHERE email = ?", email, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};


User.updateUsersMeta = (userID, MainScreenPromotions ,FullScreenPromotions, result) => {

  sql.query("SELECT * FROM user_meta WHERE UserID = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    else if (res.length == 0) {
      sql.query('INSERT INTO user_meta (UserID, MainScreenPromotions, FullScreenPromotions) VALUES(?,"?","?")',
          [userID,MainScreenPromotions,FullScreenPromotions], (err, res) => {
            if (err) {
              console.log("error: ", err);
              result(err, "False");
              return;
            } else {
              result(null, "True");
              return;
            }
          });
    }
    else if (res.length == 1) {
      console.log("Promos Updated");
      console.log(MainScreenPromotions);
      console.log(FullScreenPromotions);
      sql.query('UPDATE user_meta SET MainScreenPromotions = "?", FullScreenPromotions = "?" WHERE UserID = ?',
          [MainScreenPromotions,FullScreenPromotions,userID], (err, res) => {
            if (err) {
              console.log("error: ", err);
              result(err, "False");
              return;
            } else {
              result(null, "True");
              return;
            }
          });

    }

  });



}


User.getUserMeta = (userID, result) => {

  sql.query("SELECT * FROM user_meta WHERE UserID = ?", userID, (err, res) => {

    console.log(res);
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if(res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });



}


User.getPreferences = (userID, result) => {
  var preferenceIDs = [];
  var container = [];
  var subQueryResult;

  sql.query("SELECT * FROM userpreferences WHERE userId = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      for (var i = 0; i < res.length; i++) {
        preferenceIDs.push(res[i].preferenceID);
      }
      container.push(preferenceIDs);

      subQueryResult = sql.query("SELECT * FROM preferences WHERE preferenceID IN (?)", container, (err, res2) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }
        if (res2.length) {
          console.log(res2);
          result(null, res2);
          return;
        }

        result({ kind: "not_found" }, null);
      });
      return subQueryResult;
    }
    result({ kind: "not_found" }, null);
  });
};

User.profilePicture = (userID, result) => {
  sql.query("SELECT * FROM users WHERE UserID = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }

    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

User.updateProfilePictureInDb = (userID, profilePictureLink, result) => {

  sql.query("UPDATE users SET profilePictureLink = ? WHERE UserID = ?",
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

User.updateUserNameInDb = (userID, name, result) => {

  sql.query("UPDATE users SET FirstName = ? WHERE userID = ?",
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

User.updateProfessionalUserPreferencesInDb = (userID, pref1, pref2, pref3, result) => {
  sql.query("UPDATE professionalusers SET Preference1 = ?, Preference2 = ?, Preference3 = ? WHERE userID = ?",
      [pref1, pref2, pref3, userID], (err, res) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
        } else {
          result(null, res);
        }
      });

}

User.updatePreferencesInDb = (userID, pref1, pref2, pref3, result) => {
  sql.query("UPDATE users SET Preference1 = ?, Preference2 = ?, Preference3 = ? WHERE userID = ?",
      [pref1, pref2, pref3, userID], (err, res) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
        } else {
          result(null, res);
        }
      });

}


User.updateUserLocationInDb = (data, result) => {
  sql.query("UPDATE users SET City = ?, StreetAddress = ?, Country =?  WHERE userID = ?",
      [data.city, data.street, data.country, data.userID], (err, res) => {
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

User.updateByEmail = (email, user, result) => {
  console.log(user);
    sql.query("UPDATE users SET FirstName =?, LastName =?,username=?, password = ?,StreetAddress=?,City=?,Country=?,Zipcode=?,ContactNumber=?,Preference1=?" +
        ",Preference2=?, Preference3=?, profilePictureLink=? WHERE email = ?", [user.FirstName,user.LastName, user.username, user.password,user.StreetAddress,
          user.City, user.Country, user.ZipCode, user.ContactNumber, user.Preference1, user.Preference2, user.Preference3,user.profilePictureLink, user.Email], (err, res) => {
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

      console.log("updated user: ", { id: email, ...user });
      result(null, { id: email, ...user });
    }
  );
};

User.remove = (email, result) => {
  sql.query("DELETE FROM users WHERE Email = ?", email, (err, res) => {
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

    console.log("deleted customer with id: ", email);
    result(null, res);
  });
};

// Portal Functions

User.createUserFromPortal = (newUser, result) => {

  // console.log(newUser.password);
  // let hash = Base64.toString(SHA256("pass")).toString()
  // console.log(hash) ;
  // // const hash2 = crypto.createHash('sha256').update(newUser.password).digest('base64');
  // const hash2 = crypto.createHash('sha256').update(newUser.password).digest('base64');
  //
  // console.log("this is my custom hash          " + hash2);
  // newUser.password = hash2;

  sql.query("INSERT INTO users SET ?", newUser, (err, res) => {
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

// Delete Account
User.deleteUserAccount = (userID, result) => {

  sql.query("DELETE FROM users WHERE userId = ?", userID, (err, res) => {});

  sql.query("DELETE FROM cantakepart WHERE userId = ?", userID, (err, res) => {});

  sql.query("DELETE FROM userpreferences WHERE userId = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }else{
      result(null, res);
      return;
    }
  });
};
User.signinFromPortal = (user, result) => {
  let authResponse = false;
  let query = `SELECT * FROM users WHERE email = '${user.email}'`;
  sql.query(query, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if(res.length){
      authResponse = isValid(user.password, res[0].password);
      let token = jwt.sign({email: user.email}, config.key, {
        expiresIn: "24h",
      });
      result(null, {token, authResponse});
      return;
    }
    result(null, {authResponse});
  });
};



User.forgotPasswordPortal = (email, result) => {
  let query = `SELECT COUNT(*) as total FROM users WHERE email = '${email}'`;
  sql.query(query, async (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if(res[0].total > 0){
      let newPassword = generatePassword();
      await updatePasswordInDatabase(hashPassword(newPassword), email);
      let transporter = nodemailer.createTransport({
        host: "smtp.gmail.com",
        port: 587,
        secure: false, // true for 465, false for other ports
        auth: {
          user: "webtiqs@gmail.com", //  user
          pass: "Webtiqs_1", //  password
        },
      });
      transporter.sendMail({
        from: '"Dance United" <webtiqs@gmail.com>', // sender address
        to: `${email}`, // list of receivers
        subject: "Reset Password", // Subject line
        text: `You requested password reset. Your new Password is  ${newPassword}. You can now use it to log in to your account. Thanks `, // plain text body
      });
      result(null, {status: true});
    }
    else {
      result(null, {status: false});

    }
  });
}
function updatePasswordInDatabase(password, email){
  let query = `UPDATE users SET password = '${password}' WHERE email= '${email}'`;
  return new Promise((resolve, reject) => {
    sql.query(query, (err, result) => {
      if (err) {
        return reject(err);
      }
      resolve(result);
    });
  });
}
function generatePassword(){
  var length = 8,
      charset = "-_^.abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789",
      password = "";
      for (var i = 0, n = charset.length; i < length; ++i) {
        password += charset.charAt(Math.floor(Math.random() * n));
      }
  return password;
}
module.exports = User;
