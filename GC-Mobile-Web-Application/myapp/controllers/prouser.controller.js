const ProUser = require("../models/prouser.model.js");

exports.getEventPublisher = (req, res) => {

    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.getPublisher(req.body['eventID'], (err, data) => {
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

exports.saveCalendarViewLink = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.saveCalendarView(req.body['userID'], req.body['calendarViewLink'], (err, data) => {
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

exports.saveProfilePicture = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.saveProfilePictureInDb(req.body['userID'], req.body['profilePictureLink'], (err, data) => {
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

exports.saveSecondaryProfilePicture = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.saveSecondaryProfilePictureInDb(req.body['userID'], req.body['secondaryProfilePictureLink'], (err, data) => {
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

exports.saveTitle = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.saveTitleInDb(req.body['userID'], req.body['title'], (err, data) => {
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

exports.saveName = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.saveNameInDb(req.body['userID'], req.body['name'], (err, data) => {
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

// login

exports.getProfessionalUser = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }
    ProUser.getProfessionalUserFromServer(req.query.backStageCode, (err, data, token) => {
        if (err)
            res.status(500).send({
                message:
                    err.message || "Some error occurred."
            });
            else if(data == null){
                res.json({
                status: false
            });
            }
            else {
            res.json({
                data: data,
                token: token,
                status: true
            });
            }

    });
};

exports.updateProfessionalUserLocation = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }

    ProUser.updateProUserLocationInDb(req.body['userID'], req.body['location'], req.body['Country'], req.body['City'] ,(err, data) => {
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

exports.deleteProfessionalAccount = (req, res) => {
    if (!req.body) {
        res.status(400).send({ message: "Content can not be empty!" });
    }

    ProUser.deleteProfessionalUserAccount(req.body['userID'], (err, data) => {
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
