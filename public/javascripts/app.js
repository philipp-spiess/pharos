!function($) {
  $(function() {

    if (typeof prettyPrint == 'function')
      prettyPrint()

    // Le awesome push :)
    var push = function( channel, to, message ) {
      if(typeof to === 'undefined') {
        $.post('/push/' + channel, { message: message })
      } else {
        $.post('/push/' + channel, { to : to, message: message })
      }
    }

    // The sidebar
    $.get('/api/stats', function(o) {
      $('.sidebar .pushed') .html(o.pushed)
      $('.sidebar .user')   .html(o.user)
      $('.sidebar .sockets').html(o.sockets)
    })

    // The /log page
    if($('.content .log').length) {
      $.get('/api/log/20', function(o) {
        $('.content .log .loading').remove()
        var count = o.length
        for(var i = 0; i < count; i++) {
          var row = o[i]

          row.receiver = ''
          if(typeof row.to !== 'undefined') {
            row.receiver = row.to.join(', ')
          }

          if(typeof row.message !== 'string') {
            row.message = JSON.stringify(row.message, null, '  ')
          }

          row.date = new Date(row.date)

          var view = $(
            '<tr>'
              + '<td>' + row.channel + '</td>'
              + '<td>' + row.type.toLowerCase() + '</td>'
              + '<td>' + row.receiver + '</td>'
              + '<td><pre>' + row.message + '</pre></td>'
              + '<td class="date">' + $r.strftime(row.date, '%Y-%m-%d') + '</td>'
              + '<td><button class="btn btn-mini">Push again</button></td>'
            + '</tr>'
          ) 

          view.find('.date').html( $r( view.find('.date') ) )
          view.find('button').click($.proxy(function() {
            push(this.channel, this.to, this.message)
          }, row))

          $('.content .log tbody').append(view)
        }
      })
    }


    // The /user page
    if($('.content .user').length) {
      $.get('/api/user', function(o) {
        $('.content .user .loading').remove()
        var count = o.length
        for(var i = 0; i < count; i++) {
          var row = o[i]

          var view = $(
            '<tr>'
              + '<td>' + row.id + '</td>'
              + '<td><img src="' + row.avatar + '" class="avatar">' + row.name + '</td>'
              + '<td>' + row.sockets + '</td>'
            + '</tr>'
          ) 

          $('.content .user tbody').append(view)
        }
      })
    }

    pharos.on('snitch', function(message) {
      console.log('Snitch received: ', message)
    })


  })
}(window.jQuery);