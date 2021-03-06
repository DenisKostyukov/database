DROP TABLE IF EXISTS users CASCADE;
/*
 Используя документацию добавьте поля birthday, isMale
 */
/* */
CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  firstname VARCHAR(64) NOT NULL CHECK(firstname != ''),
  lastname VARCHAR(64) NOT NULL CHECK(lastname != ''),
  email VARCHAR(256) NOT NULL CHECK(email != ''),
  is_male BOOLEAN NOT NULL,
  birthday DATE NOT NULL CHECK(birthday < CURRENT_DATE),
  height NUMERIC(3, 2) CHECK(
    height > 0.2
    AND height < 3
  )
);
/* */
ALTER TABLE "users"
ADD UNIQUE("email");
/* */
ALTER TABLE "users"
ADD CONSTRAINT "custom_check" CHECK("height" > 0.5);
/* */
ALTER TABLE "users" DROP CONSTRAINT "custom_check";
/* */
ALTER TABLE "users"
ADD "weight" NUMERIC(5, 2) CHECK(
    "weight" > 0
    AND "weight" < 500
  );
INSERT INTO users (
    firstname,
    lastname,
    email,
    is_male,
    birthday,
    height,
    weight
  )
VALUES (
    'Test',
    'Testovich',
    'test1@mail.com',
    TRUE,
    '1980-01-01',
    2,
    15
  ),
  (
    'Test',
    'Testovich',
    'test2@mail.com',
    TRUE,
    '1980-01-01',
    1.5,
    150
  ),
  (
    'Test',
    'Testovich',
    'test3@mail.com',
    TRUE,
    '1980-01-01',
    1,
    200
  );
/* */
DROP TABLE IF EXISTS a;
/* */
CREATE TABLE a (b INT, c INT, PRIMARY KEY (b, c));
INSERT INTO a
VALUES (1, 1),
  (1, 2),
  (2, 1),
  (1, 3);
/* */
DROP TABLE IF EXISTS "products" CASCADE;
/* */
CREATE TABLE "products" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(256) NOT NULL CHECK("name" != ''),
  "category" VARCHAR(128) NOT NULL CHECK("category" != ''),
  "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
  UNIQUE ("name", "category")
);
/* */
DROP TABLE IF EXISTS "orders" CASCADE;
CREATE TABLE "orders" (
  "id" BIGSERIAL PRIMARY KEY,
  "customer_id" INTEGER NOT NULL CHECK("customer_id" > 0) REFERENCES "users" ("id"),
  "is_done" BOOLEAN NOT NULL DEFAULT FALSE,
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
/* */
DROP TABLE IF EXISTS "products_to_orders";
/* */
CREATE TABLE "products_to_orders" (
  "order_id" BIGINT REFERENCES "orders" ("id"),
  "product_id" INTEGER REFERENCES "products" ("id"),
  "quantity" INTEGER CHECK("quantity" > 0),
  PRIMARY KEY ("order_id", "product_id")
);
/*
 chats:
 chat_name,
 description
 
 users,
 
 users_to_chats
 */
/* */
DROP TABLE IF EXISTS "chats" CASCADE;
/* */
CREATE TABLE "chats" (
  "id" BIGSERIAL PRIMARY KEY,
  "owner_id" INTEGER NOT NULL REFERENCES "users" ("id"),
  "name" VARCHAR(64) NOT NULL CHECK("name" != ''),
  "description" VARCHAR(512) CHECK("description" != '')
);
/* */
DROP TABLE IF EXISTS "users_to_chats" CASCADE;
/* */
CREATE TABLE "users_to_chats" (
  "chat_id" BIGINT REFERENCES "chats"("id"),
  "user_id" INTEGER REFERENCES "users"("id"),
  "created_at" TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY ("chat_id", "user_id")
);
/* */
DROP TABLE IF EXISTS "messages" CASCADE;
/* */
CREATE TABLE "messages" (
  "id" BIGSERIAL PRIMARY KEY,
  "body" VARCHAR(2048) NOT NULL CHECK("body" != ''),
  "author_id" INTEGER NOT NULL,
  "chat_id" BIGINT NOT NULL,
  "createdAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "isRead" BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY ("chat_id", "author_id") REFERENCES "users_to_chats" ("chat_id", "user_id")
);
/*
 КОНТЕНТ: имя, описание,
 РЕАКЦИИ: isLiked
 */
DROP TABLE IF EXISTS "content" CASCADE;
CREATE TABLE "content" (
  "id" SERIAL PRIMARY KEY,
  "owner_id" INTEGER NOT NULL REFERENCES "users"("id"),
  "name" VARCHAR(255) NOT NULL CHECK("name" != ''),
  "description" TEXT
);
/* */
DROP TABLE IF EXISTS "reactions" CASCADE;
CREATE TABLE "reactions" (
  "content_id" INTEGER REFERENCES "content"("id"),
  "user_id" INTEGER REFERENCES "users"("id"),
  "is_liked" BOOLEAN,
  PRIMARY KEY ("content_id", "user_id")
);
/*1:1*/
DROP TABLE IF EXISTS "coach" CASCADE;
CREATE TABLE "coach" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(128)
);
DROP TABLE IF EXISTS "teams" CASCADE;
CREATE TABLE "teams" (
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR(128),
  "coach_id" INTEGER NOT NULL REFERENCES "coach"("id")
);
ALTER TABLE "coach"
ADD COLUMN "team_id" INTEGER REFERENCES "teams"("id");
/* */
SELECT *
FROM "users";
/* */
UPDATE "users"
SET "height" = 1.75
  /* */
UPDATE "users"
SET "height" = 1.9
WHERE "id" % 2 = 0
  /* 1 */
SELECT *
FROM "users"
WHERE "is_male" = TRUE
  /* 2 */
SELECT *
FROM "users"
WHERE "is_male" = FALSE
  /* 3 */
SELECT *
FROM "users"
WHERE AGE("birthday") > MAKE_INTERVAL(30)
  /* 4 */
SELECT *
FROM "users"
WHERE "is_male" = FALSE
  AND AGE("birthday") > MAKE_INTERVAL(30)
  /* 5 */
SELECT *
FROM "users"
WHERE AGE("birthday") BETWEEN MAKE_INTERVAL(20) AND MAKE_INTERVAL(40)
  /* 6 */
SELECT *
FROM "users"
WHERE AGE("birthday") > MAKE_INTERVAL(20)
  AND "height" > 1.8
  /* 7 */
SELECT *
FROM "users"
WHERE EXTRACT(
    month
    from "birthday"
  ) = 9;
/* 8 */
SELECT *
FROM "users"
WHERE EXTRACT(
    day
    from "birthday"
  ) = 1
  AND EXTRACT(
    month
    from "birthday"
  ) = 11;
/* 9 */
DELETE FROM "users"
WHERE AGE("birthday") < MAKE_INTERVAL(30)
  /*PAGINATION*/
SELECT "id",
  CONCAT("firstname", ' ', "lastname") AS "Full name",
  "email"
FROM "users"
LIMIT 15 OFFSET 15;
/* */
SELECT "is_male",
  MIN("height") AS "min height",
  MAX("height") AS "max height",
  AVG("height") AS "avg height"
FROM "users"
GROUP BY "is_male";
/* */
SELECT COUNT("id")
FROM "users"
WHERE "birthday" = '1970-01-01';
/* */
SELECT "firstname",
  COUNT("id") AS "count"
FROM "users"
WHERE "firstname" IN('Sophia', 'Arno', 'Don')
GROUP BY "firstname";
/* */
SELECT "is_male",
  COUNT("id") AS "count"
FROM "users"
WHERE AGE("birthday") BETWEEN MAKE_INTERVAL(20) AND MAKE_INTERVAL(30)
GROUP BY "is_male";
/* ----------------------------------------*/
/* 1 */
SELECT *
FROM "users"
ORDER BY "birthday" DESC,
  "weight" ASC,
  "height" DESC;
/* 2 */
SELECT *
FROM "users"
ORDER BY "lastname" ASC,
  "firstname" ASC,
  "id" DESC;
/* 3 */
SELECT "id",
  CONCAT("firstname", ' ', "lastname") AS "full_name",
  "email",
  "birthday"
FROM "users"
ORDER BY CHAR_LENGTH("email");
/* 4 */
SELECT "is_male",
  AVG("weight")
FROM "users"
WHERE "height" > 2
GROUP BY "is_male";
/* ------------------------------------------ */
SELECT "brand",
  SUM("quantity")
FROM "phones"
GROUP BY "brand"
HAVING SUM("quantity") > 3000;
/* */
SELECT "age",
  COUNT("id") AS "count"
FROM (
    SELECT EXTRACT(
        "year"
        from AGE("birthday")
      ) AS "age",
      *
    FROM "users"
  ) AS "users"
GROUP BY age
HAVING COUNT("id") > 5;
/* -------------------------------*/
SELECT "firstname"
FROM "users"
WHERE "firstname" ~ 'M.*e{2}.*n';
/* */
SELECT o.id, o."createdAt", p.brand FROM orders AS o
JOIN phones_to_orders AS pto 
ON o.id = pto."orderId"
JOIN phones AS p ON pto."phoneId" = p."id"
WHERE p."brand" = 'Samsung';
/* */

SELECT o.id, o."createdAt", SUM(pto.quantity)
FROM "orders" AS "o"
JOIN "phones_to_orders" AS pto ON pto."orderId" = o.id
GROUP BY o.id
ORDER BY o.id;
/* */
SELECT u.firstname, COUNT(o."userId") from "users" AS u
JOIN orders AS o ON u.id = o."userId"
GROUP BY u.firstname;

/* */
SELECT u.firstname, u.email FROM "users" AS "u"
JOIN orders AS "o" ON o."userId" = u.id
JOIN phones_to_orders AS pto ON o.id = pto."orderId"
JOIN phones AS p ON pto."phoneId" = p.id
WHERE p.brand = 'Honor'
GROUP BY u.firstname, u.email;

