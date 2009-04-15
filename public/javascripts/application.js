function refresh_feed(link) {
  new Ajax.Request('/feeds/' + link.getAttribute('feed_id') + '/refresh', { method: 'post' })
  spin_and_wait(link)
}

function refresh_all() {
  new Ajax.Request('/feeds/refresh', { method: 'post' })
  $$('.feed .refresh a').each(function(link) {
    spin_and_wait(link)
  })
}

function spin_and_wait(link) {
  link.addClassName('refreshing')
  poll_for_update(link.getAttribute('feed_id'), link.getAttribute('last_modified'), link)
}

function poll_for_update(feed_id, last_modified, link) {
  setTimeout(function() {
    new Ajax.Request('/feeds/' + feed_id, {
      method: 'get',
      requestHeaders: { 'If-Modified-Since': last_modified },
      onComplete: function(transport) {
        if (transport.status == 304) {
          poll_for_update(feed_id, last_modified, link);
        } else if (transport.status == 200) {
          $('feed_' + feed_id).innerHTML = transport.responseText
        } else {
          link.innerHTML = 'error'
        }
      }
    }) },
    1000
  )
}
