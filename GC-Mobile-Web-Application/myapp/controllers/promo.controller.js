const Promo = require("../models/promo.model.js");

exports.create = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  const newsPromo = new Promo({
    promoID: req.body["newspromo"].promoID,
    eventID: req.body["newspromo"].eventID,
    userID: req.body["newspromo"].userID,
    offerTitle: req.body["newspromo"].offerTitle,
    promoImageUrl: req.body["newspromo"].promoImageUrl,
    destinationLink: req.body["newspromo"].destinationLink,
    promoType: req.body["newspromo"].promoType,
    mainStyle: req.body["newspromo"].mainStyle,
    relatedStyle1: req.body["newspromo"].relatedStyle1,
    relatedStyle2: req.body["newspromo"].relatedStyle2,
    relatedStyle3: req.body["newspromo"].relatedStyle3,
    promoCity: req.body["newspromo"].promoCity
  });

  Promo.create(newsPromo, (err, data) => {
    if (err) {
      res.status(500).send({
        message: err.message || "Some error occurred"
      });
    } else {
      res.send(data);
    }
  });
};

exports.createMainScreenPromo = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  const fullScreenPromo = new Promo({
      promoID: req.body["mainscreenpromo"].promoID,
    eventID: req.body["mainscreenpromo"].eventID,
    userID: req.body["mainscreenpromo"].userID,
    offerTitle: req.body["mainscreenpromo"].offerTitle,
    promoImageUrl: req.body["mainscreenpromo"].promoImageUrl,
    destinationLink: req.body["mainscreenpromo"].destinationLink,
    promoType: req.body["mainscreenpromo"].promoType,
    mainStyle: req.body["mainscreenpromo"].mainStyle,
    relatedStyle1: req.body["mainscreenpromo"].relatedStyle1,
    relatedStyle2: req.body["mainscreenpromo"].relatedStyle2,
    relatedStyle3: req.body["mainscreenpromo"].relatedStyle3,
    promoCity: req.body["mainscreenpromo"].promoCity
  });

  Promo.createMSPromo(fullScreenPromo, (err, data) => {
    if (err) {
      res.status(500).send({
        message: err.message || "Some error occurred"
      });
    } else {
      res.send(data);
    }
  });
};

exports.createFullScreenPromo = (req, res) => {
  if (!req.body) {
    res.status(400).send({ message: "Content can not be empty!" });
  }

  const fullScreenPromo = new Promo({
      promoID: req.body["fullscreenpromo"].promoID,
    eventID: req.body["fullscreenpromo"].eventID,
    userID: req.body["fullscreenpromo"].userID,
    offerTitle: req.body["fullscreenpromo"].offerTitle,
    promoImageUrl: req.body["fullscreenpromo"].promoImageUrl,
    destinationLink: req.body["fullscreenpromo"].destinationLink,
    promoType: req.body["fullscreenpromo"].promoType,
    mainStyle: req.body["fullscreenpromo"].mainStyle,
    relatedStyle1: req.body["fullscreenpromo"].relatedStyle1,
    relatedStyle2: req.body["fullscreenpromo"].relatedStyle2,
    relatedStyle3: req.body["fullscreenpromo"].relatedStyle3,
    promoCity: req.body["fullscreenpromo"].promoCity
  });

  Promo.createFSPromo(fullScreenPromo, (err, data) => {
    if (err) {
      res.status(500).send({
        message: err.message || "Some error occurred"
      });
    } else {
      res.send(data);
    }
  });
};

exports.getSpecialScreenPromo = (req, res) => {
  Promo.specialScreenPromos((err, data) => {
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

exports.getExternalPromos = (req, res) => {
  Promo.externalPromos((err, data) => {
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

exports.getMainScreenPromos = (req, res) => {
  Promo.mainScreenPromos((err, data) => {
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

exports.getFullScreenPromos = (req, res) => {
  Promo.fullScreenPromos((err, data) => {
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

exports.saveCounter = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  Promo.saveCounterInDb(req.body['promoID'], req.body['counter'], (err, data) => {
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

exports.saveCounterMainScreenPromo = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  Promo.saveCounterMainScreenPromoInDb(req.body['eventID'], req.body['counter'], (err, data) => {
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

exports.saveCounterFullScreenPromo = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  Promo.saveCounterFullScreenPromoInDb(req.body['eventID'], req.body['counter'], (err, data) => {
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

exports.saveCounterSpecialScreenPromo = (req, res) => {
  if (!req.body) {
      res.status(400).send({ message: "Content can not be empty!" });
  }
  Promo.saveCounterSpecialScreenPromoInDb(req.body['eventID'], req.body['counter'], (err, data) => {
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

// Get Pro User Promos 

exports.getProUserSpecialScreenPromo = (req, res) => {
  Promo.proUserSpecialScreenPromos(req.body['userID'], (err, data) => {
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

exports.getProUserMainScreenPromos = (req, res) => {
  Promo.proUserMainScreenPromos(req.body['userID'], (err, data) => {
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

exports.getProUserFullScreenPromos = (req, res) => {
  Promo.proUserFullScreenPromos(req.body['userID'], (err, data) => {
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

// Get Pro User Promos


exports.editPromotion = (req,res) => {
  Promo.editPromotion(req.body.promotion.promoID, req.body.promotion,req.body.parent, (err, data) => {
    if(err){
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found.`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    }
    else{
      res.json({
        data: data,
        status: true
      })
    }
  } )
}
exports.deletePromo = (req, res) => {
  Promo.deletePromotion(req.body.promotionId, req.body.tableName, (err, data) => {
    if(err){
      if (err.kind === "not_found") {
        res.status(404).send({
          message: `Not found.`
        });
      } else {
        res.status(500).send({
          message: "Error retrieving"
        });
      }
    }
    else{
      res.json({
        data: data,
        status: true
      })
    }
  } )
}

exports.updatePromoPrice = (req, res) => {
  Promo.updatePrice(req.body.promoName, req.body.price, (err, data) => {
    if(err){
      console.log(err);
      res.json({
        status: false
      })
    }
    else{
      res.json({
        data: data,
        status: true
      })
    }
  })
}
