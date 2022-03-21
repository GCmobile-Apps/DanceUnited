const CreditCards = require("../models/creditcards.model.js");

exports.saveCardInfo = (req, res) => {
  if (!req.body) {
    res.status(400).send({
      message: "Content can not be empty!"
    });
  }
  const creditcards = new CreditCards({
    userID: req.body.userID,
    cardNumber: req.body.cardInfo["cardNumber"],
    cvc: req.body.cardInfo["cvc"],
  });

  CreditCards.saveCardInformation(creditcards, (err, data) => {
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

  exports.getCreditCardInfo = (req, res) => {
    if (!req.body) {
      res.status(400).send({
        message: "Content can not be empty!"
      });
    }
  
    CreditCards.getCreditCardInformation(req.body.userID, (err, data) => {
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
