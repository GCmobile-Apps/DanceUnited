var express = require('express');
var router = express.Router();
const multer = require('multer');
const middleware = require('../middleware')

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, "./" + req.query.folderName);
    },
    filename: (req, file, cb) => {
        cb(null, req.query.Id + file.originalname.replace(/\s/g, ''));
    }
});
const upload = multer({
    storage: storage,
    limits:{
        fileSize: 1024 * 1024 * 6,
    }
});
router.post('/upload',middleware.checkToken, upload.single('file'), (req, res, next) => {
    try {
        return res.status(201).json({
            message: 'File uploaded successfully'
        });
    } catch (error) {
        console.log(error);
    }
});



module.exports = router;
