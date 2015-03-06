WeixinCtrl = require "./../ctrl/weixinCtrl"
Q = require "q"
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
  bodyReader = (req) ->
    deferred = Q.defer()
    _data = ""
    req.on "data",(chunk) ->
      _data += chunk
    req.on "end",() ->
      deferred.resolve _data
    req.on "error",(e) ->
      deferred.reject e

    return deferred.promise;

  bodyReader(req).then (results) ->
    msg = results
    WeixinCtrl.msg signature,timestamp,nonce,msg,(err,results) ->
      console.log "WeixinAction.msg:",signature,timestamp,nonce,msg,err,results if global.isDebug
      res.send results
