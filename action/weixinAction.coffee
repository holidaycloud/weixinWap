WeixinCtrl = require "./../ctrl/weixinCtrl"
Promise = require "promise"
exports.check = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce
  echostr = req.query.echostr
  WeixinCtrl.check signature,timestamp,nonce,echostr,(err,results) ->
    console.log "WeixinAction.check:",signature,timestamp,nonce,echostr,err,results if global.isDebug
    res.send results

exports.msg = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce
  bodyReader = new Promise (resolve, reject) ->
    _data = ""
    req.on "data",(chunk) ->
      _data += chunk
    req.on "end",() ->
      resolve _data
    req.on "error",(e) ->
      reject e
  bodyReader().then (res) ->
    msg = res
    WeixinCtrl.msg signature,timestamp,nonce,msg,(err,results) ->
    console.log "WeixinAction.msg:",signature,timestamp,nonce,msg,err,results if global.isDebug
    res.send results
