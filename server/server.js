const express = require("express");
//routesフォルダのindex.jsファイルを呼び出し
const apiRoutes = require("./routes");
const cors = require("cors");

const setupServer = () => {
  //expressをインスタンス化
  const app = express();
  //JSON形式として認識する
  app.use(express.json());
  // app.use(bodyParser.json({ limit: "50mb" }));
  // app.use(bodyParser.urlencoded({ limit: "50mb", extended: true }));
  app.use(express.urlencoded({ extended: true }));
  //全てのHttpリクエストに対してcorsを許可する
  app.use(cors());

  app.get("/", (req, res) => {
    res.send("Herokuでデプロイできたよ");
  });

  //"/api/v1"に飛んできたらapiRoutesファイルに飛んでいく
  app.use("/api/v1", apiRoutes);
  return app;
};
module.exports = { setupServer };
