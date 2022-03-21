const CanTakePart = require("../models/cantakepart.model.js");


exports.cannotTakePart = (req, res) => {

  console.log("This is the body");
  console.log(req.body);
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  var UserID = req.body.cannottakepart["UserID"];
  var EventID = req.body.cannottakepart["EventID"];

  console.log("This is what i am sending");
  console.log(UserID);
  console.log(EventID);

  CanTakePart.CannotTakePart(UserID,EventID, (err, data) => {
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


exports.registerEvent = (req, res) => {

  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  const cantakepart = new CanTakePart({
    UserID: req.body.cantakepart["UserID"],
    EventID: req.body.cantakepart["EventID"],
  });

  CanTakePart.register(cantakepart, (err, data) => {
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

exports.checkRegisteredEvent = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  CanTakePart.checkEvent(req.body['eventID'], req.body['userID'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Customer."
      });
    else {
      var statusCode;
      if (data.length == 0) {
        statusCode = 204;
      } else {
        statusCode = 200;
      }
      res.json({
        statusCode: statusCode,
        status: true,
      });
    }
  });
};

exports.getWhoIsGoing = (req, res) => {

  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  CanTakePart.whoIsGoing(req.body.eventID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Customer."
      });
    else {
      res.json({
        data: data,
        status: true,
      });
    }
  });
};

exports.getAllGoingEvents = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  CanTakePart.allGoingEvents((err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred while creating the Customer."
      });
    else {
      res.json({
        data: data,
        status: true,
      });
    }
  });
};
