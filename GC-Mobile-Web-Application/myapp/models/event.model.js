const EventEmitter = require("events");
const { getAllGoingEvents } = require("../controllers/cantakepart.controller.js");
const sql = require("./db.js");
const short = require('short-uuid');
const config = require("../config/hostConfig");

const Event = function (event) {
  this.EventID = event.EventID;
  this.Title = event.Title;
  this.Description = event.Description;
  this.StartDate = event.StartDate;
  this.EndDate = event.EndDate;
  this.Location = event.Location;
  this.Prize = event.Prize;
  this.Type = event.Type;
  this.ImageUrl = event.ImageUrl;
  this.notRepeat = event.notRepeat;
  this.Tags = event.Tags;
  this.startTime = event.startTime;
  this.endTime = event.endTime;
  this.relatedStyle1 = event.relatedStyle1;
  this.relatedStyle2 = event.relatedStyle2;
  this.relatedStyle3 = event.relatedStyle3;
  this.viewCounter = event.viewCounter;
  this.country = event.country;
  this.SeriesEndDate = event.SeriesEndDate;
  this.CompleteAddress = event.CompleteAddress;
};



Event.FindProIdOfEvent = (eventID,result) => {
  console.log("I have reached here" + eventID);
  sql.query("SELECT userID FROM professionaluserevents WHERE eventID=?",eventID, (err, res) => {

    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }else if (res.length) {
      result(null, res);
      return;
    }

    result(null, res);
  });
};

Event.GetProfessionalObject = (userID, result) => {
  sql.query("SELECT * FROM professionalusers WHERE userID=?", userID,
      (err, res) => {

        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }else if (res.length) {
          console.log(res);
          result(null, res);
          return;
        }
        result(null, res);
      });
}

Event.find = (result) => {
  sql.query("SELECT * FROM event", (err, res) => {

    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }else if (res.length) {
      result(null, res);
      return;
    }

    result(null, res);
  });
};

Event.specialEvents = (result) => {
  var eventIds = [];
  var container = [];
  var subQueryResult;

  sql.query("SELECT * FROM newspromo WHERE promoType = 'Internal Promo'", (err, res) => {
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

      subQueryResult = sql.query("SELECT * FROM event WHERE EventID IN (?)", container, (err, res2) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }
        if (res2.length) {
          // for (var i = 0; i < res2.length; i++) {
          //   res2[i].StartDate = res2[i].StartDate.toLocaleDateString("se-SE");
          //   res2[i].EndDate = res2[i].EndDate.toLocaleDateString("se-SE");
          // }

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

Event.mainScreenEvents = (result) => {
  var eventIds = [];
  var container = [];
  var subQueryResult;

  sql.query("SELECT * FROM mainscreenpromo", (err, res) => {
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

      subQueryResult = sql.query("SELECT * FROM event WHERE EventID IN (?)", container, (err, res2) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }
        if (res2.length) {
          // for (var i = 0; i < res2.length; i++) {
          //   res2[i].StartDate = res2[i].StartDate.toLocaleDateString("se-SE");
          //   res2[i].EndDate = res2[i].EndDate.toLocaleDateString("se-SE");
          // }
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

Event.fullScreenEvents = (result) => {
  var eventIds = [];
  var container = [];
  var subQueryResult;

  sql.query("SELECT * FROM fullscreenpromo", (err, res) => {
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

      subQueryResult = sql.query("SELECT * FROM event WHERE EventID IN (?)", container, (err, res2) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }
        if (res2.length) {
          // for (var i = 0; i < res2.length; i++) {
          //   res2[i].StartDate = res2[i].StartDate.toLocaleDateString("se-SE");
          //   res2[i].EndDate = res2[i].EndDate.toLocaleDateString("se-SE");
          // }
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

Event.create = (event, userID, result) => {

  console.log("I am in model thing");

  sql.query("INSERT INTO event SET ?", event, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
  });

  sql.query("INSERT INTO professionaluserevents (userID, eventID) VALUES (?, ?)",
    [userID, event.EventID], (err, res) => {
      if (err) {
        console.log("error: ", err);
        result(err, null);
        return;
      }else if (res) {
      result(null, res);
      return;
    }
    });
};

Event.createFromPortal = (event,userID, result) => {

  event.StartDate = new Date(event.StartDate);
  event.EndDate = new Date(event.EndDate);

  console.log(event);

  sql.query("INSERT INTO event SET ?", event, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null, res);
    }
  });
  sql.query("INSERT INTO professionaluserevents (userID, eventID) VALUES (?, ?)",
      [userID, event.EventID], (err, res) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }else if (res) {
          result(null, res);
          return;
        }
      });
};

Event.getEvents = (userID, result) => {
  var eventIds = [];
  var container = [];
  var subQueryResult;

  sql.query("SELECT * FROM cantakepart WHERE userId = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      for (var i = 0; i < res.length; i++) {
        eventIds.push(res[i].EventID);
      }
      container.push(eventIds);

      subQueryResult = sql.query("SELECT * FROM event WHERE EventID IN (?)", container, (err, res2) => {
        if (err) {
          console.log("error: ", err);
          result(err, null);
          return;
        }
        if (res2.length) {
          // for (var i = 0; i < res2.length; i++) {
          //   res2[i].StartDate = res2[i].StartDate.toLocaleDateString("se-SE");
          //   res2[i].EndDate = res2[i].EndDate.toLocaleDateString("se-SE");
          // }
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

Event.getProEvents = (userID, result) => {
  var eventIds = [];
  var container = [];
  var subQueryResult;

  sql.query("SELECT * FROM professionaluserevents WHERE userId = ?", userID, (err, res) => {
    if (err) {
      result(err, null);
      return;
    }
    if (res.length) {
      for (var i = 0; i < res.length; i++) {
        eventIds.push(res[i].eventID);
      }
      container.push(eventIds);
      subQueryResult = sql.query("SELECT * FROM event WHERE EventID IN (?)", container, (err, res2) => {
        if (err) {
          result(err, null);
          return;
        }
        if (res2.length) {
          // for (var i = 0; i < res2.length; i++) {
          //   res2[i].StartDate = res2[i].StartDate.toLocaleDateString("se-SE");
          //   res2[i].EndDate = res2[i].EndDate.toLocaleDateString("se-SE");
          // }
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

Event.saveCounterInDb = (eventID, counter, result) => {

  sql.query("UPDATE event SET viewCounter = ? WHERE EventID = ?",
      [counter, eventID], (err, res) => {
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

Event.getSpecificEvent = (eventID, result) => {
  sql.query("SELECT * FROM event WHERE EventID = ?", eventID, (err, res2) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res2.length) {
      // for (var i = 0; i < res2.length; i++) {
      //   res2[i].StartDate = res2[i].StartDate.toLocaleDateString("se-SE");
      //   res2[i].EndDate = res2[i].EndDate.toLocaleDateString("se-SE");
      // }
      result(null, res2);
      return;
    }

    result({ kind: "not_found" }, null);
  });
};

// Event Update Functions --------------------------------------------------------------- //

Event.updateEventTitleInDb = (eventID, title, result) => {

  sql.query("UPDATE event SET Title = ? WHERE EventID = ?",
      [title, eventID], (err, res) => {
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

Event.updateEventStartDateInDb = (eventID, startDate, result) => {

  sql.query("UPDATE event SET StartDate = ? WHERE EventID = ?",
      [startDate, eventID], (err, res) => {
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

Event.updateEventStartTimeInDb = (eventID, startTime, result) => {

  sql.query("UPDATE event SET startTime = ? WHERE EventID = ?",
      [startTime, eventID], (err, res) => {
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

Event.updateEventEndTimeInDb = (eventID, endTime, result) => {

  sql.query("UPDATE event SET endTime = ? WHERE EventID = ?",
      [endTime, eventID], (err, res) => {
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

Event.updateEventImageInDb = (eventID, eventImageLink, result) => {

  sql.query("UPDATE event SET ImageUrl = ? WHERE EventID = ?",
      [eventImageLink, eventID], (err, res) => {
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

Event.updateDescriptionInDb = (eventID, description, result) => {

  sql.query("UPDATE event SET Description = ? WHERE EventID = ?",
      [description, eventID], (err, res) => {
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

Event.updateLocationInDb = (eventID, location, result) => {

  sql.query("UPDATE event SET Location = ? WHERE EventID = ?",
      [location, eventID], (err, res) => {
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

// Event Update Functions --------------------------------------------------------------- //

Event.remove = (eventId, result) => {
  sql.query("DELETE FROM event WHERE EventID = ?", eventId, (err, res) => {
    if (err) {
      console.log("error in deleting event: ", err);
      result(null, err);
      return;
    }

    if (res.affectedRows === 0) {
      // not found Event with the id
      result({ kind: "not_found" }, null);
      return;
    }

    console.log("deleted event with id: ", eventId);
    result(null, res);
  });
};

// Added this query

Event.updateEvent = (EventID, event, result) => {
  sql.query("UPDATE event SET Title =?, Description =?,StartDate=?, EndDate = ?,Location=?,Prize=?,Type=?,Tags=?,notRepeat=?,startTime=?" +
      ",endTime=?, relatedStyle1=?, relatedStyle2=?, relatedStyle3=?, viewCounter=?, ImageUrl=?, SeriesEndDate=? WHERE EventID = ?", [event.Title, event.Description,
        event.StartDate,event.EndDate, event.Location, event.Prize, event.Type, event.Tags, event.notRepeat, event.startTime, event.endTime,
        event.relatedStyle1, event.relatedStyle2, event.relatedStyle3, event.viewCounter, event.ImageUrl, event.SeriesEndDate, event.EventID], (err, res) => {
        if (err) {
          console.log("error: ", err);
          result(null, err);
          return;
        }
        if (res.affectedRows === 0) {
          // not found Event with the id
          result({ kind: "not_found" }, null);
          return;
        }

        result(null, { id: EventID, ...event });
      }
  );
};
Event.addCountry  = (event, result) => {
  let query = `UPDATE event SET country = '${event.country}' WHERE EventID='${event.eventId}'`;
  sql.query(query, (err, res) => {
    if (err) {
      result(null, err);
      return;
    }
    if (res.affectedRows === 0) {
      // not found Event with the id
      result({ kind: "not_found" }, null);
      return;
    }

    result(null, {  ...event });
  })
}
Event.getCountry = (eventId, result) => {
  let query = `SELECT country FROM event WHERE EventID = '${eventId}'`;
  sql.query(query, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(null, err);
      return;
    }
    if (res.affectedRows === 0) {
      // not found Event with the id
      result({ kind: "not_found" }, null);
      return;
    }

    result(null, { country: res[0].country });
  })
}

Event.addEvent = async(event, result) => {
  try {
    event.imageUrl = config.host + '/images'+ "/" + event.imageUrl;

    const unique_EventID = short.generate();
    event.ID = unique_EventID
    let eventQuery = await addEvent(event)
    if (eventQuery.status === true) {
      let eventProfessionalQuery = await addProfessionalEvent(event)
      if (eventProfessionalQuery.status === true) {
        result(null, {status: true, message: "Event Added!"})
      }
    }
    else {
      result(null, {status: false})
    }
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

Event.editEvent = async(event, result) => {
  try {
    if (event.eventUrl === 'null') {
      event.imageUrl = config.host + '/images'+ "/" + event.imageUrl;
    }
    else {
      event.imageUrl = event.eventUrl
    }

    let eventQuery = await editEvent(event)
    if (eventQuery.status === true) {
      result(null, {status: true, message: "Event Edited!"})
    }
    else {
      result(null, {status: false})
    }
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

Event.deleteEvent = async(eventId, result) => {
  try {
    let eventQuery = await deleteEvent(eventId)
    let eventUserQuery = await deleteEventFromProfessionalUserEvents(eventId)
    result(null, {status: true, message: 'Event Deleted!'})
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

Event.getEvent = async(eventId, result) => {
  try {
    let eventQuery = await getEvent(eventId)
    if (eventQuery.length > 0) {
      result(null, {status: true, event: eventQuery[0]})
    }
    else {
      result(null, {status: false, event: 'No Event Found'})
    }
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

Event.getUserEvent = async(userId, result) => {
  try {
    let eventQuery = await getUserEvent(userId)
    if (eventQuery.length > 0) {
      result(null, {status: true, event: eventQuery})
    }
    else {
      result(null, {status: false, event: 'No Event Found'})
    }
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

Event.getEventsByFilters = async (filters, result) => {
  try {
    let eventQuery = ""
    let allEvents = [], dateEvents = [], locationEvents = [], tagEvents = [], upcomingEvents = []

    const formatYmd = date => date.toISOString().slice(0, 10);

    var curr = new Date;
    var firstWeekday = new Date(curr.setDate(curr.getDate() - curr.getDay()+1));
    var lastWeekday = new Date(curr.setDate(curr.getDate() - curr.getDay()+7));

    var date = new Date();
    var firstMonthDay = new Date(date.getFullYear(), date.getMonth(), 2);
    var lastMonthDay = new Date(date.getFullYear(), date.getMonth() + 1, 1);

    let todayDate = formatYmd(new Date())
    let weekFirstDate = formatYmd(firstWeekday)
    let weekLastDate = formatYmd(lastWeekday)
    let monthFirstDate = formatYmd(firstMonthDay)
    let monthLastDate = formatYmd(lastMonthDay)

    eventQuery = await getAllEvents()
    allEvents = eventQuery.events

    if (allEvents.length > 0) {

      if (filters.date !== "") {
        eventQuery = await getEventsByDate(filters.date, todayDate, weekFirstDate, weekLastDate, monthFirstDate, monthLastDate)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              dateEvents.push(allEvents[i])
            }
          }
        }
        allEvents = dateEvents;
      }

      if (filters.location !== "") {
        eventQuery = await getEventsByLocation(filters.location)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              locationEvents.push(allEvents[i])
            }
          }
        }
        allEvents = locationEvents;
      }

      if (filters.tag !== "") {
        eventQuery = await getEventsByTag(filters.tag)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              tagEvents.push(allEvents[i])
            }
          }
        }
        allEvents = tagEvents;
      }

      if (filters.date === "") {
        eventQuery = await getEventsByUpcomingDate(todayDate)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              upcomingEvents.push(allEvents[i])
            }
          }
        }
        allEvents = upcomingEvents;
      }

      result(null, {status: true, events: allEvents})
    }
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

Event.getEventsByFiltersMobile = async (filters, result) => {
  try {
    let eventQuery = ""
    let allEvents = [], dateEvents = [], locationEvents = [], tagEvents = [], typeEvents = [], upcomingEvents = []

    const formatYmd = date => date.toISOString().slice(0, 10);

    var curr = new Date;
    var lastWeekday = new Date(curr.setDate(curr.getDate() - curr.getDay()+7));

    var date = new Date();
    var lastMonthDay = new Date(date.getFullYear(), date.getMonth() + 1, 1);

    let currentDate = new Date();
    currentDate.setDate(currentDate.getDate() + 1);

    let todayDate = formatYmd(new Date())
    let tomarrowDate = formatYmd(currentDate)
    let weekLastDate = formatYmd(lastWeekday)
    let monthLastDate = formatYmd(lastMonthDay)

    eventQuery = await getAllEvents()
    allEvents = eventQuery.events

    if (allEvents.length > 0) {

      if (filters.date !== "") {
        eventQuery = await getEventsByDateMobile(filters.date, todayDate, tomarrowDate, weekLastDate, monthLastDate)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              dateEvents.push(allEvents[i])
            }
          }
        }
        allEvents = dateEvents;
      }

      if (filters.location !== "") {
        eventQuery = await getEventsByLocation(filters.location)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              locationEvents.push(allEvents[i])
            }
          }
        }
        allEvents = locationEvents;
      }

      if (filters.tag !== "") {
        eventQuery = await getEventsByTag(filters.tag)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              tagEvents.push(allEvents[i])
            }
          }
        }
        allEvents = tagEvents;
      }

      if (filters.type !== "") {
        eventQuery = await getEventsByType(filters.type)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              typeEvents.push(allEvents[i])
            }
          }
        }
        allEvents = typeEvents;
      }

      if (filters.date === "") {
        eventQuery = await getEventsByUpcomingDate(todayDate)
        for (let i = 0; i < allEvents.length; i++) {
          for (let j = 0; j < eventQuery.events.length; j++) {
            if (allEvents[i].EventID === eventQuery.events[j].EventID) {
              upcomingEvents.push(allEvents[i])
            }
          }
        }
        allEvents = upcomingEvents;
      }

      result(null, {status: true, events: allEvents})
    }
  }
  catch (e) {
    console.error(e)
    result({status: false}, null)
  }
}

function getMonth(monthStr){
  return new Date(monthStr+'-1-01').getMonth()+1
}

function getEventsByDateMobile(date, todayDate, tomarrowDate, weekLastDate, monthLastDate) {
  let query = ""
  if (date === "Today") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (DATE(a.SeriesEndDate) = '${todayDate}' OR DATE(a.EndDate) = '${todayDate}')`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  else if (date === "Tomarrow") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (DATE(a.SeriesEndDate) = '${tomarrowDate}' OR DATE(a.EndDate) = '${tomarrowDate}')`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  else if (date === "Week") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND ((DATE(a.SeriesEndDate) >= '${todayDate}'
             AND DATE(a.SeriesEndDate) <= '${weekLastDate}') OR (DATE(a.EndDate) >= '${todayDate}' AND DATE(a.EndDate) <= '${weekLastDate}'))`;
             console.log(query)
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  else if (date === "Month") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND ((DATE(a.SeriesEndDate) >= '${todayDate}'
    AND DATE(a.SeriesEndDate) <= '${monthLastDate}') OR (DATE(a.EndDate) >= '${todayDate}' AND DATE(a.EndDate) <= '${monthLastDate}'))`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  else {
    let month = getMonth(date)
    if (month <= 9) {
      query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (SeriesEndDate LIKE '2021-0${month}-%' OR EndDate LIKE '2021-0${month}-%')`;
      return new Promise((resolve, reject) => {
          sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
          resolve({status: true, events: response})
        })
      });
    }
    else {
      query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (SeriesEndDate LIKE '2021-${month}-%' OR EndDate LIKE '2021-0${month}-%')`;
      return new Promise((resolve, reject) => {
          sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
          resolve({status: true, events: response})
        })
      });
    }
  }
}

function getEventsByDate(date, todayDate, weekFirstDate, weekLastDate, monthFirstDate, monthLastDate) {
  let query = ""
  if (date === "Today") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (DATE(a.SeriesEndDate) = '${todayDate}' OR DATE(a.EndDate) = '${todayDate}')`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  if (date === "Week") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND ((DATE(a.SeriesEndDate) >= '${todayDate}'
    AND DATE(a.SeriesEndDate) <= '${weekLastDate}') OR (DATE(a.EndDate) >= '${todayDate}' AND DATE(a.EndDate) <= '${weekLastDate}'))`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  if (date === "Month") {
    query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.profilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND ((DATE(a.SeriesEndDate) >= '${todayDate}'
    AND DATE(a.SeriesEndDate) <= '${monthLastDate}') OR (DATE(a.EndDate) >= '${todayDate}' AND DATE(a.EndDate) <= '${monthLastDate}'))`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
}

function getEventsByLocation(location) {
  let query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.secondaryProfilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND a.Location = '${location}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true, events: response})
      })
  });
}

function getEventsByTag(tag) {
  let query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.secondaryProfilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (a.Tags = '${tag}' OR a.relatedStyle1 = '${tag}' OR a.relatedStyle2 = '${tag}' OR a.relatedStyle3 = '${tag}')`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true, events: response})
      })
  });
}

function getEventsByType(type) {
  if (type === 'Social,Party') {
    let query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.secondaryProfilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND (a.Type = 'Social' OR a.Type = 'Party')`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
  else {
    let query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.secondaryProfilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND a.Type = '${type}'`;
    return new Promise((resolve, reject) => {
        sql.query(query, (err, response) => {
            if(err) {
                reject({status: false})
            }
            resolve({status: true, events: response})
        })
    });
  }
}

function getAllEvents() {
  let query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.secondaryProfilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true, events: response})
      })
  });
}

function getEventsByUpcomingDate(todayDate) {
  let query = `SELECT a.*, DATE_FORMAT(a.StartDate,"%e-%m-%Y") AS StartDate, DATE_FORMAT(a.EndDate,"%e-%m-%Y") AS EndDate, c.title as OrganizerName, c.secondaryProfilePictureLink as ProfilePicture FROM event a, professionaluserevents b, professionalusers c WHERE a.EventID = b.eventID AND c.userID = b.userID AND DATE(a.SeriesEndDate) >= '${todayDate}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true, events: response})
      })
  });
}

function addEvent(event) {
  let query = `INSERT INTO event (EventID, Title, Description, StartDate, EndDate, Location, Prize, Type, ImageUrl, Tags, notRepeat, startTime, endTime, relatedStyle1, relatedStyle2, relatedStyle3, viewCounter, country, SeriesEndDate, CompleteAddress)
  VALUES ('${event.ID}', '${event.title}', '${event.description}', '${event.startDate}', '${event.endDate}', '${event.location}', null, '${event.dancetype}', '${event.imageUrl}', '${event.style}', '${event.notRepeat}', '${event.startTime}', '${event.endTime}', '${event.relatedStyle1}', '${event.relatedStyle2}', '${event.relatedStyle3}', 0, '${event.country}', null, null)`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
            console.log(err);
              reject({status: false})
          }
          resolve({status: true, response})
      })
  });
}

function addProfessionalEvent(event) {
  let query = `INSERT INTO professionaluserevents (userID, eventID)
  VALUES ('${event.userId}', '${event.ID}')`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true, response})
      })
  });
}

function editEvent(event) {
  let query = `UPDATE event SET Title = '${event.title}', Description = '${event.description}', StartDate = '${event.startDate}', EndDate = '${event.endDate}', Location = '${event.location}', Type = '${event.dancetype}', ImageUrl = '${event.imageUrl}', Tags = '${event.style}', notRepeat = '${event.notRepeat}', startTime = '${event.startTime}', endTime = '${event.endTime}', relatedStyle1 = '${event.relatedStyle1}', relatedStyle2 = '${event.relatedStyle2}', relatedStyle3 = '${event.relatedStyle3}', country = '${event.country}' WHERE EventID = '${event.ID}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true})
      })
  });
}

function deleteEvent(eventId) {
  let query = `DELETE FROM event WHERE EventID = '${eventId}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true})
      })
  });
}

function deleteEventFromProfessionalUserEvents(eventId) {
  let query = `DELETE FROM professionaluserevents WHERE eventID = '${eventId}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve({status: true})
      })
  });
}

function getEvent(eventId) {
  let query = `SELECT * FROM event WHERE EventID = '${eventId}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve(response)
      })
  });
}

function getUserEvent(userId) {
  let query = `SELECT a.* FROM event a, professionaluserevents b WHERE a.EventID = b.eventID AND b.userID = '${userId}'`;
  return new Promise((resolve, reject) => {
      sql.query(query, (err, response) => {
          if(err) {
              reject({status: false})
          }
          resolve(response)
      })
  });
}

module.exports = Event;
