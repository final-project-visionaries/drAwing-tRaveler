/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function (knex) {
  return knex.schema.alterTable("albums", function (table) {
    table.double("album_latitude").alter();
    table.double("album_longitude").alter();
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function (knex) {
  return knex.schema.alterTable("user", function (table) {
    table.integer("album_latitude").alter();
    table.integer("album_longitude").alter();
  });
};
