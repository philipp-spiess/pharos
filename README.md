# Welcome to Pharos #

**Pharos** is a full-featured, simple-to-install and highly secure push and tracking engine written with node.js and socket.io. 

## Push objects to users ##

**Pharos** features a lightweight API to push messages directly to a user. No matter on how many browsers he is logged in.

**Pharos** connects to a database to verfiy a user's *Auth Token*. Based on this token, the user will get indexed to allow pushing as fast as possible.

## Track current user counter ##

**Pharos** makes it possible to get the *most current* number of currently online users. **Pharos** will instantly notice if a user closes his browser!

## Dependency ##

For [CodeSup](http://codesup.com "CodeSup") we use a mongodb backend which stores the *Auth Token* of every user, therefore you need to install the npm dependencies:

    npm install

**Pharos** needs to be public on port 1337 (this is where socket.io runs on) and can be private on port 7331, this is the port where the API runs on.

## Usage ##

Check out the demo directory for a little preview on how to use **Pharos**.
