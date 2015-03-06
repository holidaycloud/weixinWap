WeixinCtrl = require "./../ctrl/weixinCtrl"
Q = require "q"
exports.check = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce
  echostr = req.query.echostr
  WeixinCtrl.check signature,timestamp,nonce,echostr,(err,results) ->
    res.send results

exports.msg = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce

  bodyReader = () ->
    deferred = Q.defer()
    _data = ""
    req.on "data",(chunk) ->
      _data += chunk
    req.on "end",() ->
      deferred.resolve _data
    req.on "error",(e) ->
      deferred.reject e
    deferred.promise;

  bodyReader().then(
    (data) ->
      deferred = Q.defer()
      WeixinCtrl.msg signature,timestamp,nonce,data,(err,results) ->
        if err
          deferred.reject err
        else
          deferred.resolve results
      deferred.promise
  ).then(
    (msgObj) ->
      deferred = Q.defer()
      if WeixinCtrl[msgObj.xml.Event[0]] is "function"
        WeixinCtrl[msgObj.xml.Event[0]] msgObj,(err,results) ->
          if err
            deferred.reject err
          else
            deferred.resolve results
      else
        deferred.resolve ""
      deferred.promise
  ).then(
    (responseBody) ->
      res.send responseBody
  )
