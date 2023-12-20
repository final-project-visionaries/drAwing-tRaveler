//("express").Router()を呼び出し
const router = require("express").Router();
const images = require("./images");

//"/api/v1/images"に飛んできたらimagesファイルに飛んでいく
router.use("/images", images);

//呼び出し先で{}で呼び出していないので、この書き方
//１個しか出力しない場合は、波括弧つけない方がいい（呼び出し先で名前を自由に決められる）
module.exports = router;
