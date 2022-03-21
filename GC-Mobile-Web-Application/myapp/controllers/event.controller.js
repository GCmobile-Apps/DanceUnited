const Event = require("../models/event.model.js");
const EventPreferences = require("../models/eventpreferences.model.js");

// Get all events
exports.findAllEvents = (req, res) => {

  Event.find((err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving" 
        });
      }
    } else res.json({
      data: data,
      status: true
    });
  });
};

//Get Professional ID of Event
exports.FindProIDOfEvent = (req, res) => {

  Event.FindProIdOfEvent(req.body['EventID'], (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    } else{
      res.json({
        data: data,
        status: true
      });
    }
  });
};


//Get Professional Object
exports.GetProfessionalObject = (req, res) => {

  Event.GetProfessionalObject(req.body['UserID'], (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    } else{
      res.json({
        data: data,
        status: true
      });
    }
  });
};

// Get Special Events
exports.getSpecialEvents = (req, res) => {
  Event.specialEvents((err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    } else res.json({
      data: data,
      status: true,
    });
  });
};

// Get Main Screen Events
exports.getMainScreenEvents = (req, res) => {
  Event.mainScreenEvents((err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found.`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    } else res.json({
      data: data,
      status: true,
    });
  });
};

// Get Main Screen Events
exports.getFullScreenEvents = (req, res) => {
  console.log(req);
  Event.fullScreenEvents((err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    } else res.send(data);
  });
};

// Create New Event
exports.createEvent = (req, res) => {

  console.log("Testing = ");
  console.log(req.body);

  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  const event = new Event({
    EventID: req.body['event'].EventID,
    Title: req.body['event'].Title,
    Description: req.body['event'].Description,
    StartDate: req.body['event'].StartDate,
    EndDate: req.body['event'].EndDate,
    Location: req.body['event'].Location,
    Prize: req.body['event'].Prize,
    Type: req.body['event'].Type,
    ImageUrl: req.body['event'].ImageUrl,
    notRepeat: req.body['event'].notRepeat,
    Tags: req.body['event'].Tags,
    startTime: req.body['event'].startTime,
    endTime: req.body['event'].endTime,
    relatedStyle1: req.body['event'].relatedStyle1,
    relatedStyle2: req.body['event'].relatedStyle2,
    relatedStyle3: req.body['event'].relatedStyle3,
    viewCounter: req.body['event'].viewCounter,
    CompleteAddress: req.body['event'].CompleteAddress,
  });

  console.log("This is event instance");
  console.log(event);
  Event.create(event, req.body['userID'], (err, data) => {
    if (err) {
      console.log(err);
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    }
    else res.send({data, ID:event.EventID} );
  });
};

// Create New Event
exports.createEventFromPortal = (req, res) => {

  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  console.log("This is event sending from frontend");
  console.log(req.body['event']);

  const event = new Event({
    EventID: req.body['event'].EventID,
    Title: req.body['event'].Title,
    Description: req.body['event'].Description,
    StartDate: req.body['event'].StartDate,
    EndDate: req.body['event'].EndDate,
    Location: req.body['event'].Location,
    Prize: req.body['event'].Prize,
    Type: req.body['event'].Type,
    ImageUrl: req.body['event'].ImageUrl,
    notRepeat: req.body['event'].notRepeat,
    Tags: req.body['event'].Tags,
    startTime: req.body['event'].startTime,
    endTime: req.body['event'].endTime,
    relatedStyle1: req.body['event'].relatedStyle1,
    relatedStyle2: req.body['event'].relatedStyle2,
    relatedStyle3: req.body['event'].relatedStyle3,
    viewCounter: req.body['event'].viewCounter,
    country: req.body['event'].country,
    SeriesEndDate: req.body['event'].SeriesEndDate,
  });
  let userID = req.body.userID;
console.log(event);
  Event.createFromPortal(event, userID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else res.send(data);
  });
};

// Get User Events
exports.getUserEvents = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  Event.getEvents(req.body.userID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred"
      });
    else {
      res.json({
        data: data,
        status: true,
      });
    }
  });
};

// Get professional user events
exports.getProUserEvents = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  Event.getProEvents(req.body.userID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
          err.message || "Some error occurred"
      });
    else res.send(data);
  });
};

exports.saveCounter = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.saveCounterInDb(req.body['eventID'], req.body['counter'], (err, data) => {
      if (err)
          res.status(500).send({
              message:
                  err.message || "Some error occurred"
          });
      else {
          res.send(data);
      }
  });
};

exports.getSpecificEventDetails = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }

  Event.getSpecificEvent(req.body.eventID, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.json({
        data: data,
        status: true,
      });
    }
  });
};

// Event Update Functions ---------------------------------------------------------- //

exports.updateEventTitle = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.updateEventTitleInDb(req.body['eventID'], req.body['title'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.updateEventStartDate = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.updateEventStartDateInDb(req.body['eventID'], req.body['startDate'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.updateEventStartTime = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.updateEventStartTimeInDb(req.body['eventID'], req.body['startTime'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.updateEventEndTime = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.updateEventEndTimeInDb(req.body['eventID'], req.body['endTime'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.updateEventImage = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.updateEventImageInDb(req.body['eventID'], req.body['eventImageLink'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.updateDescription = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.updateDescriptionInDb(req.body['eventID'], req.body['description'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
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

  console.log("Testing Update Location = ");
  console.log(req.body['eventID']);
  console.log(req.body['location']);
  Event.updateLocationInDb(req.body['eventID'], req.body['location'], (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

// Event Update Functions ---------------------------------------------------------- //

exports.updateEvent = (req, res) => {
  // Validate Request
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  Event.updateEvent(req.query.eventId, new Event(req.body), (err, data) => {
        if (err) {
          if (err.kind === "not_found") {
            res.status(404).send({
              message: `Not found Event with id ${req.query.eventId}.`
            });
          } else {
            res.status(500).send({
              message: "Error updating Event with id " + req.query.eventId
            });
          }
        } else res.send(data);
      }
  );
};

// Added this function
exports.deleteEvent = (req, res) => {
  Event.remove(req.query.eventId, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found Event with id ${req.query.eventId}.`
        });
      } else {
        res.status(500).send({
          message: "Could not delete Event with id " + req.query.eventId
        });
      }
    } else res.send({ message: `Event was deleted successfully!` });
  });
};


exports.addCountry = (req, res) => {
  Event.addCountry(req.body.event, (err, data) => {
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found Event with id ${req.body.eventId}.`
        });
      } else {
        res.status(500).send({
          message: "Could not update Event with id " + req.body.eventId
        });
      }
    } else res.send({ message: `Event was updated successfully!` });
  });
}
exports.getCountry = (req, res) => {
  Event.getCountry(req.query.eventId, (err, data) =>{
    if (err) {
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found Event with id ${req.query.eventId}.`
        });
      } else {
        res.status(500).send({
          message: "Could not update Event with id " + req.query.eventId
        });
      }
    } else res.send({ data });
  });
}

exports.addEvent = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.addEvent(req.body, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.editEvent = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.editEvent(req.body, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.deleteEvent = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.deleteEvent(req.body.eventId, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.getEvent = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.getEvent(req.body.eventId, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.getUserEvent = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.getUserEvent(req.body.userId, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.getEventsByFilters = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.getEventsByFilters(req.body.filters, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};

exports.getEventsByFiltersMobile = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }
  Event.getEventsByFiltersMobile(req.body.filters, (err, data) => {
    if (err)
      res.status(500).send({
        message:
            err.message || "Some error occurred"
      });
    else {
      res.send(data);
    }
  });
};