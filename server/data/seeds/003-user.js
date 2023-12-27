/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.seed = async function (knex) {
  // Deletes ALL existing entries
  await knex('users').del();
  await knex('users').insert([
    {
      user_name: 'sad',
      salt: '866502afcd83',
      hashed_password:
        'e3fbaab3183a6edab4a7ca4de701a793217c04a9df11f76ba42d80e402094080',
    },
    {
      user_name: 'abc',
      salt: '68435568ecbe',
      hashed_password:
        '874d91c275758ce6cd4171af2a7d9f8564db0f281ba44c01385233ad68bb1589',
    },
  ]);
};
