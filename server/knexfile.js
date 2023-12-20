// Update with your config settings.
require("dotenv").config();
/**
 * @type { Object.<string, import("knex").Knex.Config> }
 */
module.exports = {
  //brewでpostgresを管理しているので、POSTGRES_USERとPOSTGRES_DBだけ指定すればいい
  development: {
    client: "pg",
    connection: {
      user: process.env.POSTGRES_USER || "postgres",
      database: process.env.POSTGRES_DB || "ccpixels",
    },
    migrations: {
      directory: "./data/migrations",
    },
    seeds: { directory: "./data/seeds" },
  },

  production: {
    client: "pg",
    //render側のサーバーのURL指定すれば、usernameとDB名は解釈してくれる
    connection: process.env.DATABASE_URL,
    migrations: {
      directory: "./data/migrations",
    },
    seeds: { directory: "./data/seeds" },
  },
};
