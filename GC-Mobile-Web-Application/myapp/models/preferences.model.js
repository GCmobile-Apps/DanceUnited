const sql = require("./db.js");

// constructor
const Preferences = function(event) {
    this.PreferenceID  = event.PreferenceID;
    this.PreferenceName = event.PreferenceName;
};

Preferences.find = (result) => {
  sql.query(`SELECT * FROM preferences`, (err, res) => {
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



Preferences.addNewPreference = (newPref, result) => {
  console.log(newPref);
  sql.query("INSERT INTO preferences SET ?", newPref, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
    } else if (res) {
      console.log(res);
      result(null, res);
    }
  });
};
''
module.exports = Preferences;
