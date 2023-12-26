/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.up = function (knex) {
  return knex.schema.createTable("albums", function (table) {
    table.increments("id").primary();
    table.integer("user_id");
    table.text("album_data").notNullable();
    table.string("album_name").notNullable();
    table.integer("album_latitude");
    table.integer("album_longitude");
    table.timestamp("created_at").defaultTo(knex.fn.now());
    table.timestamp("updated_at").defaultTo(knex.fn.now());
  });
};

/**
 * @param { import("knex").Knex } knex
 * @returns { Promise<void> }
 */
exports.down = function (knex) {
  return knex.schema.dropTable("albums");
};
