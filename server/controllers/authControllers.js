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
// let users = [{ id: 1, user_name: 'sad', hashed_password: '1234' }];
let users = [];
// Passportの設定

//local-login
passport.use(
  'local-login',
  new LocalStrategy((username, password, done) => {
    // console.log('localログイン来ています');
    // console.log('username :', username);
    // console.log('password :', password);
    // console.log('typeof password :', typeof password);
    // console.log('users :', users);

    const user = users.find((u) => {
      // console.log('u.hashed_password : ', u.hashed_password);
      // console.log('password : ', password);
      // if (u.user_name === username && u.hashed_password === password)
      if (
        u.user_name === username &&
        u.hashed_password === enhash(`${u.salt}${password}`)
      )
        return true;
    });
    // const user = users.find(
    //   (u) =>
    //     u.user_name === username &&
    //     // u.hashed_password === password
    //     //DBのハッシュ化されたPWとDBのsaltとユーザーから送られたPWが一致するか確認
    //     u.hashed_password === password
    //   // u.hashed_password === enhash(`${u.salt}${password}`)
    // );
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
};

module.exports = authController;
