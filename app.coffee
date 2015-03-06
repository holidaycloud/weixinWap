express = require "express"
session = require "cookie-session"
path = require "path"
favicon = require "serve-favicon"
cookieParser = require "cookie-parser"
bodyParser = require "body-parser"
config = require "./config/config.json"
flash = require "connect-flash"
compression = require "compression"
require("./tools/dateExtend")()

log4js = require "log4js"
log4js.configure appenders:[type:"console"],replaceConsole:true
logger = log4js.getLogger "normal"

index = require "./routes/index"
weixin = require "./routes/weixin"
app = express()

app.set "views",path.join __dirname,"views"
app.set "view engine","ejs"

app.enable "trust proxy"
#uncomment after placing your favicon in /public
#app.use(favicon(__dirname + '/public/favicon.ico'));
app.use compression()
app.use bodyParser.json()
app.use(bodyParser.urlencoded({ extended: false }));
app.use cookieParser()
app.use express.static path.join __dirname,"public"
app.use log4js.connectLogger logger,level:log4js.levels.INFO
app.use session({secret:"holidaycloud"})
app.use (req,res,next) ->
  res.set "X-Powered-By","Server"
  next()
app.use flash()

app.use "/",index
app.use "/weixin",weixin

app.use (req,res,next) ->
  res.status(404).end()
if (app.get "env") is "development"
  app.use (err,req,res,next) ->
    console.log err
    res.status(err.status or 500).end()

app.use (err,req,res,next) ->
  console.log err
  res.status(err.status or 500).end()

app.set "port",process.env.PORT or 3333

server = app.listen (app.get "port"),() ->
  console.log "Express server listening on port #{server.address().port}"
global.ent = "54124f09e07fa9341ba90cf3"
global.isDebug = true
module.exports = app