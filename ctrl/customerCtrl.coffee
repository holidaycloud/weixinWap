request = require "request"
config = require "./../config/config.json"
class CustomerCtrl
  @weixinSubscribe:(openid,fn) ->
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinSubscribe"
    request {url,timeout:3000,method:"POST",form: {ent:global.ent,openid}},(err,response,body) ->
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

module.exports = CustomerCtrl