request = require "request"
config = require "./../config/config.json"
Q = require "q"

#private method
_getOpenid = (code) ->
  deferred = Q.defer()
  url = "#{config.weixin.host}:#{config.weixin.port}/weixin/codeAccesstoken/#{global.ent}?code=#{code}"
  request {url,timeout:3000,method:"GET"},(err,response,body) ->
    if err
      deferred.reject err
    else
      try
        res = JSON.parse(body)
        if res.error is 1
          deferred.reject new Error(res.errMsg)
        else
          deferred.resolve res.data
      catch error
        deferred.reject new Error("Parse Error")
  deferred.promise

_getCustomerInfo = (openid) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/customer/weixinLogin?ent=#{global.ent}&openId=#{openid}"
  request {url,timeout:3000,method:"GET"},(err,response,body) ->
    if err
      deferred.reject err
    else
      try
        res = JSON.parse(body)
        if res.error is 1
          deferred.reject new Error(res.errMsg)
        else
          deferred.resolve res.data
      catch error
        deferred.reject new Error("Parse Error")
  deferred.promise

_getCoupons = (customer) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/coupon/customerCoupons?ent=#{global.ent}&customer=#{customer}&status=0"
  request {url,timeout:3000,method:"GET"},(err,response,body) ->
    if err
      deferred.reject err
    else
      try
        res = JSON.parse(body)
        if res.error is 1
          deferred.reject new Error(res.errMsg)
        else
          deferred.resolve res.data
      catch error
        deferred.reject new Error("Parse Error")
  deferred.promise

_couponDetail = (id) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/coupon/detail?id=#{id}"
  request {url,timeout:3000,method:"GET"},(err,response,body) ->
    if err
      deferred.reject err
    else
      try
        res = JSON.parse(body)
        if res.error is 1
          deferred.reject new Error(res.errMsg)
        else
          deferred.resolve res.data
      catch error
        deferred.reject new Error("Parse Error")
  deferred.promise

_couponUse = (id) ->
  deferred = Q.defer()
  url = "#{config.inf.host}:#{config.inf.port}/api/coupon/scanUse"
  request {url,timeout:3000,method:"POST",form:{id}},(err,response,body) ->
    if err
      deferred.reject err
    else
      try
        res = JSON.parse(body)
        if res.error is 1
          deferred.reject new Error(res.errMsg)
        else
          deferred.resolve res.data
      catch error
        deferred.reject new Error("Parse Error")
  deferred.promise

exports.coupons = (req,res) ->
  code = req.query.code
  state = req.query.state
  _getOpenid(code).then(
    (openid) ->
      _getCustomerInfo(openid.openid)
    ,(err) ->
      console.log err
      res.status(500).end()
  ).then(
    (customer) ->
      _getCoupons(customer._id)
    ,(err) ->
      console.log err
      res.status(500).end()
  ).then(
    (coupons) ->
      res.render "coupons",{coupons}
    (err) ->
      console.log err
      res.status(500).end()
  ).catch (err) ->
    console.log err
    res.status(500).end()

exports.couponDetail = (req,res) ->
  id = req.query.id
  _couponDetail(id).then(
    (coupon) ->
      res.render "couponDetail",{coupon}
    ,(err) ->
      console.log err
      res.status(500).end()
  )

exports.couponuse = (req,res) ->
  id = req.query.id
  _couponUse(id).then(
    (coupon) ->
      console.log coupon
      res.render "useResult",{result:true,coupon}
    ,(err) ->
      res.render "useResult",{result:false,message:err.message}
  )


