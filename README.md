# Pharos #
[![Build Status](https://secure.travis-ci.org/philipp-spiess/pharos.png?branch=master)](http://travis-ci.org/philipp-spiess/pharos)

Pharos is a real-time pushing alternative to [Pusher](http://pusher.com/) which is easy to deploy on [dotCloud](https://www.dotcloud.com/) for free (I usually prefer Heroku, but having no WebSocket support sucks).

These are some of the features I want to implement:

- <del>**Authenticating** users via an auth-token and several strategies.</del>
- **Multiple Workers** who push your data to the users. Connect to the master via Redis pub/sub.
- <del>**Logging** ALL the messages</del>.
- <del>**Sexy Web Interface** to check the logs and emit or repush messages.</del>
- **Pipes** created either via the server or the client itself. Should be a private room for multiple users to send messages without reaching your app to relieve your load.
- <del>**RESTful API** to push messages to the folks.</del>
- <del>**Public and Private Channels**. For example a channel named "notification" may be private. You may push a message to user XYZ in this channel and only this user should receive the message. A public channel could be something like a global chat, where you push the message without specifying special users.</del>
- <del>**Stats** for analytical reasons.</del>
- **Tests** to run the whole thing in production.
- **Resend Messages** when a client disconnects for ~5 seconds -> reloading the page. 

Read more about it on my blog [post](http://philippspiess.com/pharos/).

## Licence

MIT, of course!

## API

    # Push an object to a single user.
    curl -d "to=1&message={\"foo\":\"bar\"}" \
         http://:PASSWORD@example.com/push/CHANNEL
    # Push an object to multiple users.
    curl -d "to[]=1&to[]=2&message={\"foo\":\"bar\"}" \
         http://:PASSWORD@example.com/push/CHANNEL
    # Broadcast some JavaScript to get evaluated.
    curl -d "message=alert('Hello World');" \
         http://:PASSWORD@example.com/push/CHANNEL

## Installing

Coming soon.

## How to contribute?

Fork bro, fork!
