request = require "request"
config = require "./../config/config.json"
CustomerCtrl = require "./customerCtrl"
class WeixinCtrl
  @check:(signature,timestamp,nonce,echostr,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.ent}?signature=#{signature}&timestamp=#{timestamp}&nonce=#{nonce}&echostr=#{echostr}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        fn err
      else
        fn null,body

  @msg:(signature,timestamp,nonce,msg,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.ent}"
    request {url,timeout:3000,method:"POST",form: {signature,timestamp,nonce,msg}},(err,response,body) ->
      if err
        fn err
      else
        try
          res = JSON.parse(body)
          if res.error? is 1
            fn new Error(res.errMsg)
          else
            fn null,res
        catch error
          fn new Error("Parse Error")

  @event:(msgObj,fn) ->
    eventType = msgObj.xml.Event[0]
    console.log "#{eventType} event"
    switch eventType
      when "subscribe" then CustomerCtrl.weixinSubscribe msgObj.xml.FromUserName[0],(err,res) ->
        fn err,res
      else fn null,""

  @text:(msgObj,fn) ->
    console.log "say #{msgObj.xml.Content[0]}"
    fn null,""


module.exports = WeixinCtrl