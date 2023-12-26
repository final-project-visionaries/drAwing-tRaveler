const crypto = require('crypto');

//ハッシュ化するための関数
const enhash = (str) => {
  //ハッシュ化するためのインスタンス
  const hash = crypto.createHash('sha256');
  //ハッシュ化
  return hash.update(str).digest('hex');
};
//salt作成
const enSalt = () => crypto.randomBytes(6).toString('hex');
const salt = enSalt();
console.log(`enSalt : ${salt}`);
const hashedPass = enhash(`${salt}${'abcd'}`);
console.log(`hashed_pass : ${hashedPass}`);

// username : sad
// salt : 866502afcd83
// enhashed_pass : e3fbaab3183a6edab4a7ca4de701a793217c04a9df11f76ba42d80e402094080
// password : 1234

// username : abc
// salt : 68435568ecbe
// enhashed_pass : 874d91c275758ce6cd4171af2a7d9f8564db0f281ba44c01385233ad68bb1589
// password : abcd
