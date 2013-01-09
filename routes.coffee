SITE_HOME = "http://darvin.github.com/mimetype-icon/"
BASE_ICONS_URL = "http://darvin.github.com/mimetype-icon/Icons/Icons/"

mime = require('mime')
module.exports =
  home: (req, res, next)->
    res.redirect SITE_HOME
    
  icon: (req, res, next)->
    icon = req.params.icon
    size = req.query.size
    size ?= 32
    defaultMime = req.query.default
    defaultMime ?= ".bin"
    mime.default_type = mime.lookup defaultMime
    mimetype = mime.lookup icon
    iconUrl = "#{BASE_ICONS_URL}#{size}_#{mimetype.replace "/", "-"}.png"
    #res.send [mimetype, size, iconUrl]
    res.redirect iconUrl
