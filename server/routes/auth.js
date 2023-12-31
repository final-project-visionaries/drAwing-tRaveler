//("express").Router()を呼び出し
const router = require('express').Router();
const authController = require('../controllers/authControllers');
const knex = require('../knexIndex');
const userTable = 'users';

// ログイン時のエンドポイント
router.post(
  '/login',
  authController.getAllUser,
  authController.passportAuth,
  authController.login
);
router.get('/', async (req, res) => {
  const result = await knex(userTable).select('*');
  res.status(200).send(result);
});
//新規登録用のエンドポイント
router.post(
  '/signup',
  authController.getAllUser,
  authController.passportSignup,
  authController.signup
);

module.exports = router;
