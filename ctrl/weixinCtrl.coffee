request = require "request"
config = require "./../config/config.json"
class WeixinCtrl
  @check:(signature,timestamp,nonce,echostr,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.ent}?signature=#{signature}&timestamp=#{timestamp}&nonce=#{nonce}&echostr=#{echostr}"
    console.log "WeixinCtrl.check:",url,signature,timestamp,nonce,echostr if global.isDebug
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      console.log "WeixinCtrl.check cb:",err,body if global.isDebug
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

  @msg:(signature,timestamp,nonce,msg,fn) ->
    url = "#{config.weixin.host}:#{config.weixin.port}/weixin/#{global.ent}"
    request {url,timeout:3000,method:"POST",form: {signature,timestamp,nonce,msg}},(err,response,body) ->
      console.log "WeixinCtrl.check:",err,body if global.isDebug
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

module.exports = WeixinCtrl