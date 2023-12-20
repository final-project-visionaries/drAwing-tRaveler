//server.jsを呼び出し
const { setupServer } = require("./server");
//.envファイルを使える状態にする
require("dotenv").config();
//デプロイ後はprocess.env.PORTで開発環境ではhttp://localhost:4242/
const port = process.env.PORT || 4242;
//setupServerをインスタンス化
const server = setupServer();
//サーバー立ち上げ
server.listen(port, () => {
  console.log("server is running!");
});
