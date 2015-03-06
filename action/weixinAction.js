// Generated by CoffeeScript 1.8.0
(function() {
  var Q, WeixinCtrl;

  WeixinCtrl = require("./../ctrl/weixinCtrl");

  Q = require("q");

  exports.check = function(req, res) {
    var echostr, nonce, signature, timestamp;
    signature = req.query.signature;
    timestamp = req.query.timestamp;
    nonce = req.query.nonce;
    echostr = req.query.echostr;
    return WeixinCtrl.check(signature, timestamp, nonce, echostr, function(err, results) {
      return res.send(results);
    });
  };

  exports.msg = function(req, res) {
    var bodyReader, nonce, signature, timestamp;
    signature = req.query.signature;
    timestamp = req.query.timestamp;
    nonce = req.query.nonce;
    bodyReader = function() {
      var deferred, _data;
      deferred = Q.defer();
      _data = "";
      req.on("data", function(chunk) {
        return _data += chunk;
      });
      req.on("end", function() {
        return deferred.resolve(_data);
      });
      req.on("error", function(e) {
        return deferred.reject(e);
      });
      return deferred.promise;
    };
    return bodyReader().then(function(data) {
      var deferred;
      deferred = Q.defer();
      WeixinCtrl.msg(signature, timestamp, nonce, data, function(err, results) {
        if (err) {
          return deferred.reject(err);
        } else {
          return deferred.resolve(results);
        }
      });
      return deferred.promise;
    }).then(function(msgObj) {
      var deferred;
      console.log(msgObj);
      deferred = Q.defer();
      if (typeof WeixinCtrl[msgObj.xml.Event[0]] === "function") {
        WeixinCtrl[msgObj.xml.Event[0]](msgObj, function(err, results) {
          if (err) {
            return deferred.reject(err);
          } else {
            return deferred.resolve(results);
          }
        });
      } else {
        deferred.resolve("");
        deferred.reject("");
      }
      return deferred.promise;
    }).then(function(responseBody) {
      return res.send(responseBody);
    })["catch"](function(error) {
      console.log(error);
      return res.send("");
    });
  };

}).call(this);
