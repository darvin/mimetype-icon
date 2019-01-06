request = require 'request'

SITE_HOME = "https://darvin.github.com/mimetype-icon/"
BASE_ICONS_URL = "https://darvin.github.com/mimetype-icon/Icons/Icons/"
ICONS_MANIFEST_URL = \
  "https://darvin.github.com/mimetype-icon/Icons/FileTypeIcons.json"
DIRECTORY_ICON_NAMES = [
  "directory",
  "dir",
  "folder",
  "text/directory",
  "application/folder"
]
http = require("http")
ICONS_MANIFEST = null
fetchIconsManifest = ()->
  request.get {url:ICONS_MANIFEST_URL, json:true}, (e, r, result) ->
    ICONS_MANIFEST = result
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
    if icon in DIRECTORY_ICON_NAMES
      iconname = "text-directory"
    else
      mimetype = mime.lookup icon
      iconname = mimetype.replace "/", "-"
      if iconname not in ICONS_MANIFEST.Names
        mimetype = mime.default_type
      
      iconname = mimetype.replace "/", "-"


    if size not in ICONS_MANIFEST.Info.Sizes
      size = ICONS_MANIFEST.Info.Sizes.reduce (i1, i2) ->
        s1 = parseInt(i1)
        s2 = parseInt(i2)
        if s1>s2 and s1<size then s1 else s2

    iconUrl = "#{BASE_ICONS_URL}#{size}_#{iconname}.png"
    #res.send [mimetype, size, iconUrl]
    res.redirect iconUrl

  initialize: fetchIconsManifest
