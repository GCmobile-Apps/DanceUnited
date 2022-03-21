//Added this controller
const link = require('../models/link.model');

// Marketing Toggle
exports.marketingToggle = (req, res) => {

    console.log(req.body);
   link.updatemarketingtoggle((err, data) => {
       if (err) {
           if (err.kind === "not_found") {
               res.status(404).send({
                   message: `Not found Link`
               });
           } else {
               res.status(500).send({
                   message: "Error retrieving Link "
               });
           }
       } else res.json({
           data: data,
           status: true
       });
   });
};



// Get all events
exports.findAllLinks = (req, res) => {
    link.find((err, data) => {
        if (err) {
            if (err.kind === "not_found") {
                res.status(404).send({
                    message: `Not found Link`
                });
            } else {
                res.status(500).send({
                    message: "Error retrieving Link "
                });
            }
        } else res.json({
            data: data,
            status: true
        });
    });
};
exports.updateLink = (req, res) => {
    // Validate Request
    console.log(req.body);
    if (!req.body) {
        res.status(400).send({
            message: "Content can not be empty!"
        });
    }
    link.update(new link(req.body),(err, data) => {
            if (err) {
                if (err.kind === "not_found") {
                    res.status(404).send({
                        message: `Not found Link with id ${req.body.idlinks}.`
                    });
                } else {
                    res.status(500).send({
                        message: "Error updating Link with id " + req.body.idlinks
                    });
                }
            } else res.send(data);
        }
    );
};
