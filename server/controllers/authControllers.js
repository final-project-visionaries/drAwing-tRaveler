const crypto = require('crypto');
const knex = require('../knexIndex.js');
const passport = require('passport');
const LocalStrategy = require('passport-local').Strategy;

//ハッシュ化するための関数
const enhash = (str) => {
  //ハッシュ化するためのインスタンス
  const hash = crypto.createHash('sha256');
  //ハッシュ化
  return hash.update(str).digest('hex');
};
//salt作成
const enSalt = () => crypto.randomBytes(6).toString('hex');

//最初にuser情報取得した結果を格納する配列を用意
let users = [];
// Passportの設定

//local-signup
passport.use(
  'local-signup',
  new LocalStrategy(
    { passReqToCallback: true },
    async (req, username, password, done) => {
      // 新規登録時にはユーザーの存在チェックなどを行う
      const existingUser = users.find((u) => u.user_name === username);
      if (existingUser) {
        return done(null, false, { message: 'Username already exists.' });
      }

      const salt = enSalt();
      const hashed = enhash(`${salt}${password}`);
      const createUser = {
        user_name: username,
        salt: salt,
        hashed_password: hashed,
      };

      const newId = await knex('users')
        .insert(createUser)
        .returning('id')
        .then((elm) => elm[0].id);
      console.log('newId : ', newId);

      const newUser = {
        id: newId,
        user_name: username,
        salt: salt,
        hashed_password: password,
      };
      //ローカルのusers配列に新規登録したユーザーを追加
      users.push(newUser);
      //新しいユーザーをローカルストラテジーに登録
      return done(null, newUser);
    }
  )
);

//local-login
passport.use(
  'local-login',
  new LocalStrategy((username, password, done) => {
    const user = users.find((u) => {
      if (
        u.user_name === username &&
        u.hashed_password === enhash(`${u.salt}${password}`)
      )
        return true;
    });
    console.log('user : ', user);
    if (user) {
      //一致したuserがいれば(=第二引数がtruety)doneで次に進む
      console.log('user一致しました');
      return done(null, user);
    } else {
      console.log('user一致しませんでした');
      return done(null, false, { message: 'Incorrect username or password.' });
    }
  })
);

//cookieの生成？？
passport.serializeUser((user, done) => {
  //一致したuserのidを取得
  done(null, user.id);
});

passport.deserializeUser((id, done) => {
  //cookie情報を入れる際に返却するuser情報。ソルト化されたPWなどは落とすようにする。
  const user = users.find((u) => u.id === id);
  const sendUser = {
    // id: user.id,
    user_name: user.user_name,
  };
  //user_nameだけをセッション情報に入れる
  done(null, sendUser);
});

const authController = {
  getAllUser: async (req, res, next) => {
    try {
      const tempUsers = await knex.select('*').from('users').orderBy('id');
      //結果を格納
      users = tempUsers;
      //格納後に次のミドルウェアに飛ぶためのコード
      next();
    } catch (err) {
      console.log(`err : ${err}`);
      //うまくいかなかった時はエラーで返して、next()しない
      res.status(500).send({ error: err });
    }
  },
  passportAuth: passport.authenticate('local-login'),
  passportSignup: passport.authenticate('local-signup'),
  login: (req, res) => {
    res.json({ message: 'ログイン成功' });
  },
  logout: (req, res) => {
    req.logout(function (err) {
      if (err) {
        return next(err);
      }
      res.json({ message: 'Logout successful' });
    });
    res;
  },
  signup: (req, res) => {
    res.json({ message: '新規登録完了' });
  },
};

module.exports = authController;
