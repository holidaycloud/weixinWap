// Generated by CoffeeScript 1.8.0
(function() {
  var CustomerCtrl, Q, config, request;

  request = require("request");

  config = require("./../config/config.json");

  Q = require("q");

  CustomerCtrl = (function() {
    var _getCoupon, _getCustomerInfo;

    function CustomerCtrl() {}

    CustomerCtrl.weixinSubscribe = function(openid, fn) {
      var url;
      url = "" + config.inf.host + ":" + config.inf.port + "/api/customer/weixinSubscribe";
      return request({
        url: url,
        timeout: 3000,
        method: "POST",
        form: {
          ent: global.ent,
          openid: openid
        }
      }, function(err, response, body) {
        var error, res;
        if (err) {
          return fn(err);
        } else {
          try {
            res = JSON.parse(body);
            if (res.error === 1) {
              return fn(new Error(res.errMsg));
            } else {
              return fn(null, res);
            }
          } catch (_error) {
            error = _error;
            return fn(new Error("Parse Error"));
          }
        }
      });
    };

    CustomerCtrl.weixinCoupon = function(openid, form, sceneid, fn) {
      return _getCustomerInfo(openid).then(function(customer) {
        if (parseInt(sceneid) === 99999) {
          return _getCoupon(customer._id, "54fa5b5f7284d93d4a49a19a");
        } else {
          return _getCoupon(customer._id, "54fa82d751abf6d65a37dd37");
        }
      }, function(err) {
        return fn(err);
      }).then(function(coupon) {
        return fn(null, coupon);
      }, function(err) {
        return fn(err);
      })["catch"](function(err) {
        return fn(err);
      });
    };

    _getCustomerInfo = function(openid) {
      var deferred, url;
      deferred = Q.defer();
      url = "" + config.inf.host + ":" + config.inf.port + "/api/customer/weixinLogin?ent=" + global.ent + "&openId=" + openid;
      request({
        url: url,
        timeout: 3000,
        method: "GET"
      }, function(err, response, body) {
        var error, res;
        if (err) {
          return deferred.reject(err);
        } else {
          try {
            res = JSON.parse(body);
            if (res.error === 1) {
              console.log("有错", res.errMsg);
              return deferred.reject(new Error(res.errMsg));
            } else {
              console.log("没错", res);
              return deferred.resolve(res.data);
            }
          } catch (_error) {
            error = _error;
            return deferred.reject(new Error("Parse Error"));
          }
        }
      });
      return deferred.promise;
    };

    _getCoupon = function(customer, marketing) {
      var deferred, url;
      deferred = Q.defer();
      url = "" + config.inf.host + ":" + config.inf.port + "/api/coupon/give";
      request({
        url: url,
        timeout: 3000,
        method: "POST",
        form: {
          ent: global.ent,
          customer: customer,
          marketing: marketing
        }
      }, function(err, response, body) {
        var error, res;
        if (err) {
          return deferred.reject(err);
        } else {
          try {
            res = JSON.parse(body);
            if (res.error === 1) {
              console.log("有错", res.errMsg);
              return deferred.reject(new Error(res.errMsg));
            } else {
              console.log("没错", res);
              return deferred.resolve(res);
            }
          } catch (_error) {
            error = _error;
            return deferred.reject(new Error("Parse Error"));
          }
        }
      });
      return deferred.promise;
    };

    return CustomerCtrl;

  })();

  module.exports = CustomerCtrl;

}).call(this);
