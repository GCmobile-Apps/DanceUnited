const sql = require("./db.js");

const Promo = function (promo) {
  this.promoID = promo.promoID;
  this.eventID = promo.eventID;
  this.userID = promo.userID;
  this.offerTitle = promo.offerTitle;
  this.promoImageUrl = promo.promoImageUrl;
  this.destinationLink = promo.destinationLink;
  this.promoType = promo.promoType;
  this.mainStyle = promo.mainStyle,
  this.relatedStyle1 = promo.relatedStyle1,
  this.relatedStyle2 = promo.relatedStyle2,
  this.relatedStyle3 = promo.relatedStyle3,
  this.promoCity = promo.promoCity
};

Promo.create = (newPromo, result) => {
  sql.query("INSERT INTO newspromo SET ?", newPromo, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    } else if (res) {
      console.log(res);
      result(null, res);
      return;
    }
  });
};

Promo.createMSPromo = (newPromo, result) => {
  sql.query("INSERT INTO mainscreenpromo SET ?", newPromo, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    } else if (res) {
      console.log(res);
      result(null, res);
      return;
    }
  });
};

Promo.createFSPromo = (newPromo, result) => {
  sql.query("INSERT INTO fullscreenpromo SET ?", newPromo, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    } else if (res) {
      console.log(res);
      result(null, res);
      return;
    }
  });
};

Promo.externalPromos = (result) => {
  sql.query("SELECT * FROM newspromo", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Promo.specialScreenPromos = (result) => {
  sql.query("SELECT * FROM newspromo", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result(null, res);
  });
};

Promo.mainScreenPromos = (result) => {
  sql.query("SELECT * FROM mainscreenpromo", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result(null, res);
  });
};

Promo.fullScreenPromos = (result) => {
  sql.query("SELECT * FROM fullscreenpromo", (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result(null, res);
  });
};

Promo.saveCounterInDb = (promoID, counter, result) => {

  sql.query("UPDATE newspromo SET viewCounter = ? WHERE promoID = ?",
      [counter, promoID], (err, res) => {
          if (err) {
              result(err, null);
              return;
          } else {
              result(null, res);
              return;
          }
      });
};

Promo.saveCounterMainScreenPromoInDb = (eventID, counter, result) => {

  sql.query("UPDATE mainscreenpromo SET viewCounter = ? WHERE eventID = ?",
      [counter, eventID], (err, res) => {
          if (err) {
              result(err, null);
              return;
          } else {
              result(null, res);
              return;
          }
      });
};

Promo.saveCounterFullScreenPromoInDb = (eventID, counter, result) => {

  sql.query("UPDATE fullscreenpromo SET viewCounter = ? WHERE eventID = ?",
      [counter, eventID], (err, res) => {
          if (err) {
              result(err, null);
              return;
          } else {
              result(null, res);
              return;
          }
      });
};

Promo.saveCounterSpecialScreenPromoInDb = (eventID, counter, result) => {

  sql.query("UPDATE newspromo SET viewCounter = ? WHERE eventID = ?",
      [counter, eventID], (err, res) => {
          if (err) {
              result(err, null);
              return;
          } else {
              result(null, res);
              return;
          }
      });
};

// Get Pro User Promos

Promo.proUserSpecialScreenPromos = (userID, result) => {
  sql.query("SELECT * FROM newspromo WHERE userID = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Promo.proUserMainScreenPromos = (userID, result) => {
  sql.query("SELECT * FROM mainscreenpromo WHERE userID = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

Promo.proUserFullScreenPromos = (userID, result) => {
  sql.query("SELECT * FROM fullscreenpromo WHERE userID = ?", userID, (err, res) => {
    if (err) {
      console.log("error: ", err);
      result(err, null);
      return;
    }
    if (res.length) {
      result(null, res);
      return;
    }
    result({ kind: "not_found" }, null);
  });
};

// Get Pro User Promos

Promo.editPromotion = (promoID, promotion,table, result) => {
  console.log(promotion);
  sql.query("UPDATE "+ table +" SET offerTitle=?, userID=?, destinationLink=?, mainStyle=?, promoCity=?, relatedStyle1=?, " +
      "relatedStyle2=?, relatedStyle3=?, promoImageUrl=? WHERE promoID=?",
      [promotion.offerTitle, promotion.userID, promotion.destinationLink, promotion.mainStyle, promotion.promoCity,
      promotion.relatedStyle1, promotion.relatedStyle2, promotion.relatedStyle3, promotion.promoImageUrl, promoID], (err, res)=>{
        if (err) {
          console.log("error: ", err);
          result(null, err);
          return;
        }
        if (res.affectedRows === 0) {
          result({ kind: "not_found promotion" }, null);
          return;
        }
        result(null, { id: promoID, ...promotion });
      }
      )
}

Promo.deletePromotion = (promotionId,table, result) => {
  sql.query("DELETE FROM " + table + " WHERE promoID=?", [promotionId], (err,res) => {
    if(err)
      throw err;
    if (res.affectedRows === 0) {
      result({ kind: "not_found promotion" }, null);
      return;
    }
    result(null, { id: promotionId });
  })
}

Promo.updatePrice = (promoName, price, result) => {
  sql.query("UPDATE promoprices SET promo_price=? WHERE promo_type=?", [price,promoName], (err, res) => {
    if(err)
      throw err;
    if (res.affectedRows === 0) {
      result({ kind: "not_found promotion" }, null);
      return;
    }
    result(null, { status: true });
  })
}
module.exports = Promo;
