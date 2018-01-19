-- +micrate Up
CREATE TABLE routes (
  id INTEGER NOT NULL PRIMARY KEY,
  path VARCHAR,
  response VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS routes;
