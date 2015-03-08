PageAction = require "./../action/pageAction"
express = require "express"
router = express.Router()
router.get "/coupons",PageAction.coupons
router.get "/couponDetail",PageAction.couponDetail
router.get "/couponuse",PageAction.couponuse
module.exports = router