( (opt) ->
  # console.log opt

  @pharos = {}
  pharos.io = io.connect opt.base_url + '?token=' + opt.token

  pharos.on = (room, callback) ->
    if callback?
      pharos.io.on room, callback
    else
      pharos.io.on room, (msg) ->
        if typeof msg == 'string'
          eval msg
        else
          console.log '[Pharos] Expected a string to eval, but got an object.'
          console.log msg

  pharos.on 'foo', (msg) ->
    console.log msg

  pharos.on 'bar'

)(:opt)
