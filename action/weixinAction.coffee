WeixinCtrl = require "./../ctrl/weixinCtrl"
exports.check = (req,res) ->
  signature = req.query.signature
  timestamp = req.query.timestamp
  nonce = req.query.nonce
  echostr = req.query.echostr
  WeixinCtrl.check signature,timestamp,nonce,echostr,(err,results) ->
    console.log "WeixinAction.check:",signature,timestamp,nonce,echostr,err,results if global.isDebug
    res.send results

exports.msg = (req,res) ->
  signature = req.body.signature
  timestamp = req.body.timestamp
  nonce = req.body.nonce
  msg = req.body.msg
  WeixinCtrl.msg signature,timestamp,nonce,msg,(err,results) ->
    console.log "WeixinAction.msg:",err,results if global.isDebug
    res.send results