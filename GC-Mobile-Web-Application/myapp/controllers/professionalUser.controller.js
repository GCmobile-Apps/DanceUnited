const User = require('../models/professionalUser.model');


exports.findAllProUsers = (req, res) => {

    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }

    User.allProUsers((err, data) => {
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


exports.createProfessionalUser = (req, res) => {

    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    const user = new User({
        userID: req.body.userID,
        FirstName: req.body.firstName,
        LastName: req.body.lastName,
        title: req.body.title,
        Email: req.body.email,
        username: req.body.username,
        password: req.body.password,
        StreetAddress: req.body.streetAddress,
        Country: req.body.country,
        ZipCode: req.body.zipCode,
        ContactNumber: req.body.contactNumber,
        profilePictureLink: req.body.profilePictureLink,
        secondaryProfilePictureLink: req.body.secondaryProfilePictureLink,
        calenderViewLink: req.body.calenderViewLink,
        backStageCode: req.body.backStageCode,
        description: req.body.description,
        city: ''

    });

    User.createProfessionalUserFromPortal(user, (err, data) => {
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


// Changed req.params.email to req.query.email
exports.deleteProUser = (req, res) => {
    User.remove(req.query.email, (err, data) => {
        if (err) {
            if (err.kind === "not_found") {
                res.status(404).send({
                    message: `Not found User with id ${req.query.email}.`
                });
            } else {
                res.status(500).send({
                    message: "Could not delete User with id " + req.query.email
                });
            }
        } else res.send({ message: `User was deleted successfully!` });
    });
};



exports.updateProUser = (req, res) => {
    if (!req.body) {
        res.status(400).send({
            message: "Content can not be empty!"
        });
    }

    console.log("this is the point");
    User.updateUser(req.query.userID, req.body, (err, data) => {
            if (err)
            {
                if (err.kind === "not_found") {
                    res.status(404).send({
                        message: `Not found User with id ${req.query.email}.`
                    });
                } else {
                    res.status(500).send({
                        message: "Error updating User with id " + req.query.email
                    });
                }
            }
            else res.send(data);
        }
    );
};


//app rout

exports.editDescriptionFromApp =(req, res) => {
    if (!req.body) {
        res.status(400).send({
            message: "Content can not be empty!"
        });
    }
    User.editDescriptionFromApp(req.body.userID, req.body.description, (err, data) => {
        if (err)
        {
            if (err.kind === "not_found") {
                res.status(404).send({
                    message: `Not found User`
                });
            } else {
                res.status(500).send({
                    message: "Error updating User "
                });
            }
        }
        else res.send(data);
    })


}

exports.professionalUserLogin = (req, res) => {
    if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
    }
  
    User.professionalUserLogin(req.body.user, (err, data) => {
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

exports.addProfessionalStyles = (req, res) => {
    if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
    }
  
    User.addProfessionalStyles(req.body.user, (err, data) => {
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

exports.getProfessionalStyles = (req, res) => {
    if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
    }
  
    User.getProfessionalStyles(req.body.userId, (err, data) => {
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

exports.getCalendarLink = (req, res) => {
    if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
    }
  
    User.getCalendarLink(req.body.userId, (err, data) => {
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

exports.updateUserLocation = (req, res) => {
    if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
    }
  
    User.updateUserLocation(req.body.location, (err, data) => {
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