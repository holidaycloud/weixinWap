PageAction = require "./../action/pageAction"
express = require "express"
router = express.Router()
router.get "/coupons",PageAction.coupons
router.get "/couponDetail",PageAction.couponDetail
module.exports = router