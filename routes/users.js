var express = require('express');
var router = express.Router();

var user;
router.get('/', function(req, res, next) {
  user = req.session.user[0];
  res.send('respond with a resource');
});

/* POST get ticket list. */
router.post('/getTicketList', function(req, res, next) {
  // Connect to the database
  req.pool.getConnection(function(err, connection) {
    if (err) {
      res.sendStatus(500);
      return;
    }
    var query = "CALL view_ticket(?)"; //mark
    connection.query(query, [user.user_id], function(err, rows, fields) {
      connection.release(); // release connection
      if (err) {
        res.sendStatus(500);
        return;
      }
      res.json(rows); //send response
    });
  });
});

/* POST get ticket list. */
router.post('/buyTicket', function(req, res, next) {
  // Connect to the database
  req.pool.getConnection(function(err, connection) {
    if (err) {
      res.sendStatus(500);
      return;
    }
    var query = "CALL buy_ticket(?, ?, ?)"; //mark
    connection.query(query, [user.user_id, req.body.booking_id, req.body.seat_id], function(err, rows, fields) {
      connection.release(); // release connection
      if (err) {
        res.sendStatus(500);
        return;
      }
      res.json(rows); //send response
    });
  });
});

/* GET users logout. */
router.get('/logout', function(req, res, next) {
  user = null;
  res.send('respond with a resource');
});

module.exports = router;
