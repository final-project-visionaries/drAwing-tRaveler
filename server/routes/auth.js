//("express").Router()を呼び出し
const router = require('express').Router();
const authController = require('../controllers/authControllers');

// router.get('/', async (req, res) => {});
// ログイン時のエンドポイント
router.post(
  '/login',
  authController.getAllUser,
  authController.passportAuth,
  authController.login
);

module.exports = router;
