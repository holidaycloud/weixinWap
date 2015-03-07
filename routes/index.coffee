PageAction = require "./../action/pageAction"
express = require "express"
router = express.Router()
router.get "/coupons",PageAction.coupons
module.exports = router