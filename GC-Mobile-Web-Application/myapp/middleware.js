const jwt = require("jsonwebtoken");
const config = require("./config.js");

const checkToken = (req, res, next) => {
    let token = req.headers['authorization'];
    console.log(token);
    if(token){
        jwt.verify(token, config.key, (err, decoded) => {
            if(err){
                return res.json({
                    status: false,
                    msg: "token is invalid",
                    statusCode: 401
                })
            }else{
                req.decoded = decoded;
                next();
            }
        })
    }else{
        return res.json({
            status: false,
            msg: "Token is not provided",
            statusCode: 401
        })
    }
    
};
module.exports = {
    checkToken: checkToken,
};
