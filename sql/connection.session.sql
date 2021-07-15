/*----------- SQL HW20210715 --------------*/
/*------ 1 ------*/
SELECT phones."brand",
  phones."model",
  SUM(phones_to_orders."quantity") AS "count"
FROM "phones_to_orders",
  "phones"
WHERE phones_to_orders."phoneId" = phones."id"
GROUP BY phones."brand",
  phones."model"
ORDER BY "count" DESC;
/*------ 2 ------*/
SELECT "brand",
  "model",
  SUM("quantity")
FROM "phones"
GROUP BY "brand",
  "model"
ORDER BY "brand";
/*------ 3 ------*/
SELECT AVG("price")
FROM "phones";
/*------ 4 ------*/
SELECT "brand",
AVG("price") AS "avg"
FROM "phones"
GROUP BY "brand"
ORDER BY "avg" DESC;
/*------ 5 ------*/
SELECT "brand", COUNT("id")
FROM "phones"
GROUP BY "brand";
/*------ 6 ------*/
SELECT CONCAT(users."firstname", ' ', users."lastname") AS "full_name",
COUNT(orders."userId") AS "count"
FROM "orders", "users"
WHERE users."id" = orders."userId"
GROUP BY CONCAT(users."firstname", ' ', users."lastname")
ORDER BY "count" DESC;
/*------ 7 ------*/
SELECT AVG("price")
FROM "phones"
WHERE "brand" = 'Iphone';
/*------ 8------*/
SELECT SUM("price")
FROM "phones"
WHERE "price" BETWEEN 10000 AND 20000;
/*------ 9 ------*/
SELECT "brand", SUM("quantity") AS "left"
FROM "phones"
GROUP BY "brand"
ORDER BY "left"
LIMIT 5;
/*------ 10 ------*/
SELECT "age",
  COUNT("id") AS "count"
FROM (SELECT EXTRACT(
    "year"
    from AGE("birthday")
  ) AS "age", * FROM "users") AS "users"
GROUP BY "age";
