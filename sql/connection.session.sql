/*----------- SQL HW20210715 --------------*/
/*Посчитать кол-во телефонов, которые были проданы*/
SELECT phones."brand",
  phones."model",
  SUM(phones_to_orders."quantity") AS "count"
FROM "phones_to_orders",
  "phones"
WHERE phones_to_orders."phoneId" = phones."id"
GROUP BY phones."brand",
  phones."model"
ORDER BY "count" DESC;
/*Кол-во телефонов, которые есть "на складе"*/
SELECT "brand",
  "model",
  SUM("quantity")
FROM "phones"
GROUP BY "brand",
  "model"
ORDER BY "brand";
/*Средняя цена всех телефонов*/
SELECT AVG("price")
FROM "phones";
/*Средняя цена каждого бренда*/
SELECT "brand",
  AVG("price") AS "avg"
FROM "phones"
GROUP BY "brand"
ORDER BY "avg" DESC;
/*Кол-во моделей каждого бренда*/
SELECT "brand",
  COUNT("id")
FROM "phones"
GROUP BY "brand";
/* Кол-во заказов каждого пользователя, которые совершали заказы*/
SELECT CONCAT(users."firstname", ' ', users."lastname") AS "full_name",
  COUNT(orders."userId") AS "count"
FROM "orders",
  "users"
WHERE users."id" = orders."userId"
GROUP BY CONCAT(users."firstname", ' ', users."lastname")
ORDER BY "count" DESC;
/*Средняя цена на IPhone*/
SELECT AVG("price")
FROM "phones"
WHERE "brand" = 'Iphone';
/*Стоимость всех телефонов в диапазоне их цен от 10К до 20К*/
SELECT SUM("price")
FROM "phones"
WHERE "price" BETWEEN 10000 AND 20000;
/*Узнать каких брендов телефонов осталось меньше всего*/
SELECT "brand",
  SUM("quantity") AS "left"
FROM "phones"
GROUP BY "brand"
ORDER BY "left"
LIMIT 5;
/*Сортировка юзеров по возрасту(не день рождения) и по имени*/
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
GROUP BY "age";
/*Извлечь все телефоны заказа №4*/
SELECT p.brand,
  p.model
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
WHERE pto."orderId" = 4;
/*Кол-во заказов каждого пользователя и его емейл*/
SELECT u.firstname,
  u.email,
  COUNT(o.id)
FROM users AS u
  JOIN orders AS o ON u.id = o."userId"
GROUP BY u.firstname,
  u.email;
/*Извлечь самый популярный телефон (каких моделей телефонов заказано больше всего)*/
SELECT p.*
FROM phones AS p
  JOIN phones_to_orders AS pto ON p.id = pto."phoneId"
  ORDER BY pto.quantity DESC
  LIMIT 1;