const knex = require("knex");
const knexConfig = require("./knexfile");
require("dotenv").config();
//ローカル環境では4242、render上では環境変数にproductionを入れる
const enviroment = process.env.NODE_ENV;
console.log("NODE_ENV : ", enviroment);
console.log("knex_config :", knexConfig[enviroment]);

module.exports = knex(knexConfig[enviroment]);
