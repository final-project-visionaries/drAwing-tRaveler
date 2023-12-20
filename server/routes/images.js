//("express").Router()を呼び出し
const router = require("express").Router();
const knex = require("../knexIndex");
const imageTable = "images";

router.get("/", async (req, res) => {
  console.log("getメソッド届いています");
  try {
    const getAllData = await knex(imageTable).select(
      "id",
      "image_name",
      "image_data",
      "updated_at"
    );
    res.status(200).send(getAllData);
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});
router.post("/", async (req, res) => {
  console.log("post届いています");
  const body = req.body;
  console.log("body :", body);
  try {
    await knex(imageTable).insert(body);
    res.status(201).send({ message: "新規登録完了" });
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});

router.patch("/:id", async (req, res) => {
  const imageId = Number(req.params.id);
  const body = req.body;
  body.updated_at = new Date();

  try {
    await knex(imageTable).where({ id: imageId }).update(body);
    res.status(200).send({ message: "修正完了" });
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});

router.delete("/:id", async (req, res) => {
  const imageId = Number(req.params.id);
  try {
    await knex(imageTable).where({ id: imageId }).delete();
    res.status(200).send({ message: "削除完了" });
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});

module.exports = router;
