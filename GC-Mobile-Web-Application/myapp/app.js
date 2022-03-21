var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
const bodyParser = require("body-parser");
const multer = require("multer");
const cors = require('cors');
var fileRouter = require('./routes/file');

var indexRouter = require('./routes/index');
var usersRouter = require('./routes/users');

var app = express();

// parse requests of content-type: application/json
app.use(bodyParser.json());
// parse requests of content-type: application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({ extended: true }));

app.use(cors({ credentials: true, origin: 'http://localhost:4200', preflightContinue: false }));

app.use('/file',fileRouter);

// host images
app.use("/uploads", express.static("uploads"));
app.use("/eventImages", express.static("eventImages"));
app.use("/promoImages", express.static("promoImages"));
app.use("/professionalCalendarView", express.static("professionalCalendarView"));


const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./" + req.body['folderName']);
  },
  filename: (req, file, cb) => {
    cb(null, req.body['fileName'] + ".jpg")
  }
});

const fileFilter = (req, file, cb) => {
  if(file.mimetype == "image/jpeg" || file.mimetype == "image/png"){
    cb(null, true);
  }else{
    cb(null, false);
  }
};

const upload = multer({
  storage: storage,
  limits:{
    fileSize: 1024 * 1024 * 6,
  },
  // fileFilter: fileFilter,
});

app.route("/addImage").patch(upload.single("img"), async (req, res) => {
  console.log(req.body['fileName']);
//   filePath = "http://192.168.100.14:3000/" +
//       req.body['folderName']+ "/" + req.body['fileName'] + ".jpg";

   filePath = "https://danceunited.eu/" +
       req.body['folderName']+ "/" + req.body['fileName'] + ".jpg";

  res.send(filePath);
});


// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'pug');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', indexRouter);
app.use('/users', usersRouter);

// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});

// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render('error');
});


module.exports = app;
