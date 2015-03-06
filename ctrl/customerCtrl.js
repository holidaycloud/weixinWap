// Generated by CoffeeScript 1.8.0
(function() {
  var CustomerCtrl, config, request;

  request = require("request");

  config = require("./../config/config.json");

  CustomerCtrl = (function() {
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
            if ((res.error != null) === 1) {
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

    return CustomerCtrl;

  })();

  module.exports = CustomerCtrl;

}).call(this);
