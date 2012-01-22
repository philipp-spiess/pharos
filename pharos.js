var io = require('socket.io').listen(1337);
io.enable('browser client minification');
//io.set('resource', '');

var mysql = require('mysql');
var gamboo = {};
var http = require('http');
var qs = require('querystring');


var db = mysql.createClient({
  user: 'root',
  host: 'localhost',
  password: ''
});
db.query('USE gamboo');



// ###################### PUBLIC ##############################

/**
 *
 * Authorization
 *
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
  //console.log('####### CONNECTION #######');
  //console.log(user);
  socket.on('disconnect', function(socket) {
  	if(user[id].length > 1) {
  	  var index = user[id].indexOf(socket);
  	  user[id].splice(index, 1);
  	} else {
  	  delete user[id];
  	}
  	//console.log('####### DISCONNECT #######');
    //console.log(user);
  });
});


/**
 * Broadcast
 */

gamboo.broadcast = function(channel, id,  msg) {
	console.log('broadcasting to user ' + id);
}


// ###################### PRIVATE ##############################



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
    });


  } else {
  	res.end("{error:'wrong request'}");
  }
}).listen(7331, '127.0.0.1'); // just listen to local server