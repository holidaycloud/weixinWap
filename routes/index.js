// Generated by CoffeeScript 1.8.0
(function() {
  var PageAction, express, router;

  PageAction = require("./../action/pageAction");

  express = require("express");

  router = express.Router();

  router.get("/coupons", PageAction.coupons);

  router.get("/couponDetail", PageAction.couponDetail);

  router.get("/couponuse", PageAction.couponuse);

  module.exports = router;

}).call(this);
