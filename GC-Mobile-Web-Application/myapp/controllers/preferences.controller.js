const Preferences = require("../models/preferences.model.js");

exports.getAllPreferences = (req, res) => {
    Preferences.find((err, data) => {
      if (err) {
        if (err.kind === "not_found") {
          res.status(404).send({
            message: `Not found Preferences.`
          });
        } else {
          res.status(500).send({
            message: "Error retrieving Preferences"
          });
        }
      } else {
        res.send({list: data});
      }
    });
  };
  
//  commnt
exports.addNewPreference = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  console.log(req.body.preference);
  const preference = new Preferences({
    // PreferenceID: req.body['preference'].PreferenceID,
    PreferenceName: req.body["preference"].PreferenceName,
  });

  Preferences.addNewPreference(preference, (err, data) => {
    if (err) {
      res.status(500).send({
        message: err.message || "Some error occurred while creating the Preference."
      });
    } else {
      res.send(data);
    }
  });
};
