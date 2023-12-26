//("express").Router()を呼び出し
const router = require('express').Router();
const images = require('./images');
const albums = require('./albums');
const auth = require('./auth');

//"/api/v1/images"に飛んできたらimagesファイルに飛んでいく
router.use('/images', images);
router.use('/albums', albums);
router.use('/auth', auth);

//呼び出し先で{}で呼び出していないので、この書き方
//１個しか出力しない場合は、波括弧つけない方がいい（呼び出し先で名前を自由に決められる）
module.exports = router;
