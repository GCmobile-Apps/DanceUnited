// Added this model

const sql = require("./db.js");

const Link = function (link) {
    this.idlinks = link.idlinks;
    this.link_title = link.link_title;
    this.link_value = link.link_value;
};


Link.updatemarketingtoggle = (result, value) => {
    sql.query("UPDATE admin_options SET MarketingToggle =?  WHERE ID = 1",value,(err, res) => {
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


Link.find = (result) => {
    sql.query("SELECT * FROM links",(err, res) => {
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

Link.update = (link, result) => {
    sql.query("UPDATE links SET link_value =?  WHERE idlinks = ?", [link.link_value, link.idlinks], (err, res) => {
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

            console.log("updated event: ", { id: link.idlinks, ...link });
            result(null, { id: link.idlinks, ...link });
        }
    );
};
module.exports = Link;
