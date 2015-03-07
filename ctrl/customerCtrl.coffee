request = require "request"
config = require "./../config/config.json"
Q = require "q"
class CustomerCtrl
#public static method
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

  @weixinCoupon:(openid,form,sceneid,fn) ->
#    fn null,"""
#            <xml>
#            <ToUserName><![CDATA[#{openid}]]></ToUserName>
#            <FromUserName><![CDATA[#{form}]]></FromUserName>
#            <CreateTime>#{Date.now()}</CreateTime>
#            <MsgType><![CDATA[text]]></MsgType>
#            <Content><![CDATA[你好#{sceneid}]]></Content>
#            </xml>
#            """
    _getCustomerInfo openid
    .then(
      (customer) ->
        if parseInt(sceneid) is 99999
          _getCoupon customer._id,"54fa5b5f7284d93d4a49a19a"
        else
          _getCoupon customer._id,"54fa82d751abf6d65a37dd37"
      ,(err) ->
        fn err
    )
    .then(
      (coupon) ->
        fn null,coupon
      ,(err) ->
        fn err
    )
    .catch (err) ->
      fn err

#private method
  _getCustomerInfo = (openid) ->
    deferred = Q.defer()
    url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinLogin?ent=#{global.ent}&openId=#{openid}"
    request {url,timeout:3000,method:"GET"},(err,response,body) ->
      if err
        deferred.reject err
      else
        try
          res = JSON.parse(body)
          if res.error? is 1
            console.log "有错",res.errMsg
            deferred.reject new Error(res.errMsg)
          else
            console.log "没错",res
            deferred.resolve res.data
        catch error
          deferred.reject new Error("Parse Error")
    deferred.promise

  _getCoupon = (customer,marketing) ->
    deferred = Q.defer()
    url = "#{config.inf.host}:#{config.inf.port}/api/coupon/give"
    request {url,timeout:3000,method:"POST",form:{ent:global.ent,customer,marketing}},(err,response,body) ->
      if err
        deferred.reject err
      else
        try
          res = JSON.parse(body)
          if res.error? is 1
            console.log "有错",res.errMsg
            deferred.reject new Error(res.errMsg)
          else
            console.log "没错",res
            deferred.resolve res
        catch error
          deferred.reject new Error("Parse Error")
    deferred.promise

module.exports = CustomerCtrl