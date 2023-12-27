const express = require('express');
//routesフォルダのindex.jsファイルを呼び出し
const apiRoutes = require('./routes');
const cors = require('cors');
const cookieParser = require('cookie-parser');
const passport = require('passport');
const session = require('express-session');

const setupServer = () => {
  //expressをインスタンス化
  const app = express();
  //JSON形式として認識する
  app.use(express.json());

  app.use(cookieParser());

  app.use(
    session({
      secret: 'your-secret-key2',
      resave: false,
      saveUninitialized: true,
      // cookie: {
      //   maxAge: 5 * 1000, // 5 seconds
      // },
    })
  );
  app.use(passport.initialize());
  app.use(passport.session());

  app.use(express.urlencoded({ extended: true }));
  //全てのHttpリクエストに対してcorsを許可する
  app.use(
    cors({
      origin: true,
      //cookieのやり取りするための設定
      credentials: true,
    })
  );
  // app.use(cors());

  app.get('/', (req, res) => {
    res.send('Herokuのアプリ名変更後');
  });

  //"/api/v1"に飛んできたらapiRoutesファイルに飛んでいく
  app.use('/api/v1', apiRoutes);
  return app;
};
module.exports = { setupServer };
