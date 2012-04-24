# Pharos #
[![Build Status](https://secure.travis-ci.org/philipp-spiess/pharos.png?branch=master)](http://travis-ci.org/philipp-spiess/pharos)

Pharos is a real-time pushing alternative to [Pusher](http://pusher.com/) which is easy to deploy on [dotCloud](https://www.dotcloud.com/) for free (I usually prefer Heroku, but having no WebSocket support sucks).

These are some of the features I want to implement:

- **Authenticating** users via an auth-token and several strategies.
- **Multiple Workers** who push your data to the users. Connect to the master via Redis pub/sub.
- **Logging** ALL the messages.
- **Sexy Web Interface** to check the logs and emit or resend messages.
- **Pipes** created either via the server or the client itself. Should be a private room for multiple users to send messages without reaching your app to relieve your load.
- **RESTful API** to push messages to the folks.
- **Public and Private Channels**. For example a channel named "notification" may be private. You may push a message to user XYZ in this channel and only this user should receive the message. A public channel could be something like a global chat, where you push the message without specifying special users.
- **Stats** for analytical reasons.

Read more about it on [my blog-post](http://philippspiess.com/pharos/).

## Licence

MIT, of course!

## How to contribute?

Fork bro, fork!
