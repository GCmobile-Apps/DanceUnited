const User = require("../models/user.model.js");
const UserPreferences = require("../models/userPreferences.model.js");

exports.create = (req, res) => {

  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }


  const user = new User({
    UserID: req.body["user"].UserID,
    FirstName: req.body["user"].FirstName,
    LastName: req.body["user"].LastName,
    Email: req.body["user"].Email,
    username: req.body["user"].username,
    password: req.body["user"].password,
    StreetAddress: req.body["user"].StreetAddress,
    City: req.body["user"].City,
    Country: req.body["user"].Country,
    ZipCode: req.body["user"].ZipCode,
    ContactNumber: req.body["user"].ContactNumber,
    profilePictureLink: req.body["user"].profilePictureLink,
    Preference1: req.body["user"].Preference1,
    Preference2: req.body["user"].Preference2,
    Preference3: req.body["user"].Preference3
  });

  User.create(user, (err, data, token) => {
    if (err) {
      console.log(err);
      res.status(500).send({
        message:
            err.message || "Some error occurred."
      });
    }
    else res.json({
      data: data,
      token: token,
      status: true
    });
  });
};

exports.updateUsersMeta = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  else{
    console.log(req.body);
    User.updateUsersMeta(req.body.UserID, req.body.MainScreenPromotions, req.body.FullScreenPromotions, (err, data) => {
      if (err)
        res.status(500).send({
          message:
              err.message || "Some error occurred while creating the Customer."
        });
      else {
        res.json({
          status: true
        });
      }
    });
  }


}

exports.getUserMeta = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  console.log(req.body);
  console.log(req.body.UserID);


  User.getUserMeta(req.body.UserID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred while creating the Customer."
      });
    else {
      res.json({
        data: data
      });
    }
  });
}


exports.findAllUsers = (req, res) => {

  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.allUsers((err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Customer."
      });
    else {
      let users = data.filter(x => x.username !== 'Admin');
      res.json({
        data: users,
        status: true
      });
    }
  });
};

exports.login = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.signin(req.body.email, (err, data, token) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred."
      });
    else res.json({
      data: data,
      token: token,
      status: true
    });
  });
};

exports.validateEmailFromServer = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.validateEmail(req.body.email, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred."
      });
    else res.json({
      data: data,
      status: true
    });
  });
};

exports.autoLogin = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.userAutoLogin(req.body.email, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred"
      });
    else res.json({
      data: data,
      status: true
    });
  });
};

exports.getUserPreferences = (req, res) => {

  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.getPreferences(req.body['userID'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Customer."
      });
    else res.json({
      data: data,
      status: true,
    });
  });
};

exports.getUserProfilePicture = (req, res) => {

  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.profilePicture(req.body.userID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Customer."
      });
    else res.json({
      data: data,
      status: true
    });
  });
};

exports.updateProfilePicture = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  User.updateProfilePictureInDb(req.body['userID'], req.body['profilePictureLink'], (err, data) => {
      if (err)
          res.status(500).send({
              message:
                  err.message || "Some error occurred while creating the Customer."
          });
      else {
          res.send(data);
      }
  });
};

exports.updateName = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  User.updateUserNameInDb(req.body['userID'], req.body['firstname'], (err, data) => {
      if (err)
          res.status(500).send({
              message:
                  err.message || "Some error occurred while creating the Customer."
          });
      else {
          res.send(data);
      }
  });
};

exports.updateLocation = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  const data = {
    userID : req.body['userID'],
    city: req.body['location'],
    street: req.body['street'],
    country: req.body['country']
  };
  User.updateUserLocationInDb(data, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred."
      });
    else {
      res.send(data);
    }
  });
};

exports.update = (req, res) => {
  // Validate Request
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  User.updateByEmail(req.query.email, new User(req.body), (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found Customer with id ${req.query.email}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating Customer with id " + req.query.email
            });
          }
        } else res.send(data);
      }
  );
};

exports.updateProfessionalUserPreferences = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  let u = req.body;
  User.updateProfessionalUserPreferencesInDb(u.userID, u.preference1, u.preference2, u.preference3, (err, data) => {
    if(err) throw err;
    else res.json({
      data: data,
      status: true
    });
  })
}

exports.updatePreferences = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  let u = req.body;
  User.updatePreferencesInDb(u.userID, u.preference1, u.preference2, u.preference3, (err, data) => {
    if(err) throw err;
    else res.json({
      data: data,
      status: true
    });
  })

}
// Delete a Customer with the specified customerId in the request

// Changed req.params.email to req.query.email
exports.delete = (req, res) => {
  User.remove(req.query.email, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found Customer with id ${req.query.email}.`
        });
      } else {
        res.status(500).send({
          message: "Could not delete Customer with id " + req.query.email
        });
      }
    } else res.send({ message: `Customer was deleted successfully!` });
  });
};

// Portal Functions

exports.createUser = (req, res) => {

  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  const user = new User({
    UserID: req.body["user"].UserID,
    FirstName: req.body["user"].FirstName,
    LastName: req.body["user"].LastName,
    Email: req.body["user"].Email,
    username: req.body["user"].username,
    password: req.body["user"].password,
    StreetAddress: req.body["user"].StreetAddress,
    City: req.body["user"].City,
    Country: req.body["user"].Country,
    ZipCode: req.body["user"].ZipCode,
    ContactNumber: req.body["user"].ContactNumber,
    profilePictureLink: req.body["user"].profilePictureLink,
    Preference1: req.body['user'].Preference1,
    Preference2: req.body['user'].Preference2,
    Preference3: req.body['user'].Preference3,
  });

  User.createUserFromPortal(user, (err, data) => {
    if (err) {
      console.log(err);
      res.status(500).send({
        message:
            err.message || "Some error occurred while creating the Customer."
      });
    }
    else res.json({
      data: data,
      status: true
    });
  });
};

// Delete Account ---------------------------------------------------------------------------------------------//
exports.deleteAccount = (req, res) => {

  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  User.deleteUserAccount(req.body['userID'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred."
      });
    else res.json({
      data: data,
      status: true,
    });
  });
};
// Delete Account ---------------------------------------------------------------------------------------------//


// Sign in from portal -------------
exports.loginFromPortal = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  const user = req.body.user;
  User.signinFromPortal(user, (err, data, token) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred."
      });
    else {
      if(data.authResponse){
        res.json({
          data: data,
          token: token,
          status: true
        });
      }
      else {
        res.json({
          data: data,
          status: false
        });
      }

    }
  });
};

// Forgot password from portal ---------------------


exports.forgotPasswordPortal = (req, res) => {
  if(!req.body){
    res.status(400).send({ message: "Content can not be empty!" });
  }
  User.forgotPasswordPortal(req.body.email, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred."
      });
    else {
      if(data.status){
        res.json({
          data: data,
          status: true
        });
      }
      else {
        res.json({
          data: data,
          status: false
        });
      }

    }
  });
}
