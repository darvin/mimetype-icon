request = require 'request'

SITE_HOME = "http://darvin.github.com/mimetype-icon/"
BASE_ICONS_URL = "http://darvin.github.com/mimetype-icon/Icons/Icons/"
ICONS_MANIFEST_URL = \
  "http://darvin.github.com/mimetype-icon/Icons/FileTypeIcons.json"

http = require("http")
ICONS_MANIFEST = null
fetchIconsManifest = ()->
  request.get {url:ICONS_MANIFEST_URL, json:true}, (e, r, result) ->
    ICONS_MANIFEST = result
    console.error "Icons manifest fetched"
    console.error result
    if e? or not result?
      fetchIconsManifest()



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

  initialize: fetchIconsManifest
