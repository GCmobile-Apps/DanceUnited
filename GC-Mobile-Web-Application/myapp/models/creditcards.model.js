const sql = require("./db.js");

const CreditCards = function (creditCards) {
    this.userID = creditCards.userID;
    this.cardNumber = creditCards.cardNumber;
    this.cvc = creditCards.cvc;
};

CreditCards.saveCardInformation = (cardInfo, result) => {

    console.log(cardInfo);

    sql.query("UPDATE creditcards SET cardNumber = ?, cvc = ? WHERE userID = ?", 
    [cardInfo.cardNumber, cardInfo.cvc, cardInfo.userID], (err, res) => {

        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else if (res) {
            result(null, res);
            return;
        }
    });
};

CreditCards.getCreditCardInformation = (userID, result) => {

    sql.query("SELECT * FROM creditcards WHERE userID = ?", userID, (err, res) => {

        if (err) {
            console.log("error: ", err);
            result(err, null);
            return;
        } else if (res) {
            result(null, res);
            return;
        }
    });
};

module.exports = CreditCards;