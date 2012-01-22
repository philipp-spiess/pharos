/**
 * Pharos Push & Tracking Engine
 * @package Pharos
 * @author Philipp Spieß <philipp.spiess@myxcode.at>
 */

var io = require('socket.io').listen(1337);
io.enable('browser client minification');
io.set('resource', '/pharos');

var mysql = require('mysql');
var http  = require('http');
var qs    = require('querystring');

/**
 * DB Connect
 */
var db = mysql.createClient({
  user: 'root',
  host: 'localhost',
  password: ''
});
db.query('USE gamboo');



// ###################### PUBLIC ##############################

/**
 * Authorization (based on socket.io's handshake protocol)
 */
io.configure(function (){
  io.set('authorization', function (handshakeData, callback) {
    db.query("select userID from access_token where access_token = ?",
	 [handshakeData.query.token], function(err, results, fields) {
	  if(err) {
	  	callback(err, false);
	  } else if(typeof results[0] != 'undefined' && results[0].userID > 0) {
	  	handshakeData.userID = results[0].userID;
	  	callback(null, true);
	  } else {
	  	callback(null, false);
	  }
	  	
	});
  });
});

/**
 * User Storage
 *
 * user : {
 *   '1' : [
 *     socket,
 *     socket
 *   ],
 *   '2' : [
 *     socket
 *   ]
 * }
 */
var user = {};

io.sockets.on('connection', function (socket) {
  var id = socket.handshake.userID;

  if(typeof user[id] == 'undefined') {
  	user[id] = [ socket ];
  } else {
  	user[id].push(socket);
  }

  socket.on('disconnect', function(socket) {
  	if(user[id].length > 1) {
  	  var index = user[id].indexOf(socket);
  	  user[id].splice(index, 1);
  	} else {
  	  delete user[id];
  	}
  });
});


// ###################### PRIVATE ##############################

/**
 * API Server
 */

http.createServer(function(req, res){

  res.writeHead(200, {
	  'Content-Type': 'application/json'
  });
  if(req.url == '/push' && req.method.toLowerCase().indexOf("post") != -1) {

    var body = '';
    req.on('data', function(data) {
      body += data;
    });
    req.on('end', function() {

      var o = JSON.parse(body);

      console.log('##########################################');
      console.log(o);
      console.log('##########################################');


      var sent = [];
      var sent_cnt = 0;
      var offline = [];
      var offline_cnt = 0;

      for(var i = 0; i < o.ids.length; i++) {
        var id = o.ids[i];
        if(typeof user[id] != 'undefined') {
          //console.log('Starting Broadcast to #'+ id + typeof user[id]);
          for(var j = 0; j < user[id].length; j++) {
            user[id][j].emit(o.channel, o.msg);
          }

          sent.push(id);
          sent_cnt++;
        }else{
          //console.log('User #' + id + ' seems to be offline.');
          offline.push(id);
          offline_cnt++;
        }
      }

      res.end( JSON.stringify( {
        'channel' : o.channel,
        'msg' : o.msg,
        'offline' : offline,
        'sent' : sent,
        'count' : {
          'offline' : offline_cnt,
          'sent' : sent_cnt
        }
      }));
    });
  } else {
  	res.end("{error:'wrong request'}");
  }
}).listen(7331, '127.0.0.1'); // just listen to local server