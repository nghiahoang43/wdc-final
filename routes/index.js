var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Express' });
});

router.post('/login', function(req, res, next) {
  if ('email' in req.body && 'password' in req.body) {
    // Connect to the database
    req.pool.getConnection(function(err, connection) {
      if (err) {
        res.sendStatus(500);
        return;
      }
      var query = "CALL login(?, ?)";
      connection.query(query, [req.body.email, req.body.password], function(err, rows, fields) {
        connection.release(); // release connection
        if (err) {
          res.sendStatus(500);
          return;
        }

        if (rows[0].length > 0) {
          req.session.user = rows[0];
          res.json(rows[0]); //send response
        } else {
          res.sendStatus(401);
        }
      });
    });
  }
});

router.post('/signup', function(req, res, next) {
  if ('username' in req.body && 'email' in req.body && 'password' in req.body) {
    // Connect to the database
    req.pool.getConnection(function(err, connection) {
      if (err) {
        res.sendStatus(500);
        return;
      }
      var query = "CALL sign_up(?, ?, ?)";
      connection.query(query, [req.body.username, req.body.email, req.body.password], function(err, rows, fields) {
        connection.release(); // release connection
        if (err) {
          res.sendStatus(500);
          return;
        }
        if (rows[0].length > 0) {
          req.session.user = rows[0];
          res.json(rows[0]); //send response
        } else {
          res.sendStatus(401);
        }
      });
    });
  }
});

/* GET logout. */
router.get('/logout', function(req, res, next) {
  if ('user' in req.session) {
    delete req.session.user;
  }
  res.end();
});

router.get('/home', function(req, res) {
  res.render('home');
});

/* POST get movie list. */
router.post('/getMovieList', function(req, res, next) {
  // Connect to the database
  req.pool.getConnection(function(err, connection) {
    if (err) {
      res.sendStatus(500);
      return;
    }
    var query = "SELECT * FROM Movie"; //mark
    connection.query(query, [], function(err, rows, fields) {
      connection.release(); // release connection
      if (err) {
        res.sendStatus(500);
        return;
      }
      res.json(rows); //send response
    });
  });
});

/* POST get booking list. */
router.post('/getBookingList', function(req, res, next) {
  // Connect to the database
  req.pool.getConnection(function(err, connection) {
    if (err) {
      res.sendStatus(500);
      return;
    }
    var query = "CALL get_bookings(?)"; //mark
    connection.query(query, [req.body.movie_id], function(err, rows, fields) {
      connection.release(); // release connection
      if (err) {
        res.sendStatus(500);
        return;
      }
      res.json(rows); //send response
    });
  });
});

/* POST get avail seat list. */
router.post('/getAvailSeat', function(req, res, next) {
  // Connect to the database
  req.pool.getConnection(function(err, connection) {
    if (err) {
      res.sendStatus(500);
      return;
    }
    var query = "CALL show_avail(?)"; //mark
    connection.query(query, [req.body.booking_id], function(err, rows, fields) {
      connection.release(); // release connection
      if (err) {
        res.sendStatus(500);
        return;
      }
      res.json(rows); //send response
    });
  });
});

router.post('/filterMovie', function(req, res, next) {
  // Connect to the database
  req.pool.getConnection(function(err, connection) {
    if (err) {
      res.sendStatus(500);
      return;
    }
    var id = req.body.id;
    var date = req.body.date;
    var time = req.body.time;
    var arr = [];
    var query = "SELECT DISTINCT Movie.movie_id, Movie.movie_name, Movie.duration, Movie.imgUrl, Movie.about FROM Movie INNER JOIN Booking ON Movie.movie_id = Booking.movie_id WHERE ";
    if (id) {
      query += "Booking.movie_id = ? AND "
      arr.push(id);
    }
    else {
      query += "Booking.movie_id = Booking.movie_id AND "
    }

    if (date) {
      query += "Booking.date = ? AND "
      arr.push(date);
    }
    else {
      query += "Booking.date = Booking.date AND "
    }

    if (time) {
      query += "Booking.startTime = ?;"
      arr.push(time);
    }
    else {
      query += "Booking.startTime = Booking.startTime;"
    }
    connection.query(query, arr, function(err, rows, fields) {
      connection.release(); // release connection
      if (err) {
        res.sendStatus(500);
        return;
      }
      res.json(rows); //send response
    });
  });
});

module.exports = router;
