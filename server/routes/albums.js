//("express").Router()を呼び出し
const router = require('express').Router();
const knex = require('../knexIndex');
const albumTable = 'albums';

// table.double("album_latitude").alter();
// table.double("album_longitude").alter();
router.get('/', async (req, res) => {
  console.log('getメソッド届いています');
  try {
    const getAllData = await knex(albumTable)
      .select(
        'id',
        'album_name',
        'album_data',
        'album_latitude',
        'album_longitude',
        'updated_at'
      )
      .orderBy('updated_at', 'desc');
    // .limit(10);
    res.status(200).send(getAllData);
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});
router.post('/', async (req, res) => {
  console.log('post届いています');
  const body = req.body;
  console.log('body :', body);
  try {
    await knex(albumTable).insert(body);
    res.status(201).send({ message: '新規登録完了' });
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});

router.patch('/:id', async (req, res) => {
  const albumId = Number(req.params.id);
  const body = req.body;
  body.updated_at = new Date();

  try {
    await knex(albumTable).where({ id: albumId }).update(body);
    res.status(200).send({ message: '修正完了' });
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});

router.delete('/:id', async (req, res) => {
  const albumId = Number(req.params.id);
  try {
    await knex(albumTable).where({ id: albumId }).delete();
    res.status(200).send({ message: '削除完了' });
  } catch (error) {
    res.status(500).send({ error: `${error}` });
  }
});

module.exports = router;
