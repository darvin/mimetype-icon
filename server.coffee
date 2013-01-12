fs = require 'fs'
express = require 'express'
routes = require './routes'



PORT = process.env.PORT or 3000
SITE_ADDRESS = process.env.URL or "http://localhost:#{PORT}/"


app = module.exports = express()



app.configure () ->
  app.use express.bodyParser()
  app.use express.methodOverride()

  app.use (req,res,next) ->
    res.locals.baseUrl = SITE_ADDRESS
    next()
  app.use app.router

app.configure 'development', () ->
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.configure 'production', () ->
  app.use express.errorHandler()



app.get '/',  routes.home
app.get "/:icon", routes.icon
routes.initialize()

app.routes.get[1].regexp = /^\/(?:(.+?))\/?$/i

app.listen PORT, ()->
  return console.log "Listening on #{PORT}\nPress CTRL-C to stop server."
  

