SELECT ('ФИО: Кузнецов Сергей Игоревич');

-- 1. Простые выборки
-- 1.1 SELECT , LIMIT - выбрать 10 записей из таблицы rating
SELECT * FROM ratings LIMIT 10;

-- 1.2 WHERE, LIKE - выбрать из таблицы links всё записи, у которых imdbid
-- оканчивается на "42", а поле movieid между 100 и 1000
SELECT * FROM links WHERE imdbid LIKE '%42' AND movieid BETWEEN 10 AND 100 LIMIT 10;

-- 2. Сложные выборки: JOIN
-- 2.1 INNER JOIN выбрать из таблицы links все imdbId, которым ставили рейтинг 5
SELECT
	L.imdbId
FROM
	links AS L JOIN ratings AS R ON L.movieid = R.movieid
WHERE
	R.rating = 5 LIMIT 10;

-- 3. Аггрегация данных: базовые статистики
-- 3.1 COUNT() Посчитать число фильмов без оценок
SELECT
	COUNT(DISTINCT L.movieid) AS Num_of_films_without_marks
FROM
	links AS L LEFT JOIN ratings AS R ON L.movieid = R.movieid
WHERE
	R.rating IS NULL;

-- 3.2 GROUP BY, HAVING вывести top-10 пользователей, у который средний рейтинг выше 3.5
SELECT userid AS average_rating FROM ratings GROUP BY userid HAVING AVG(rating) > 3.5
ORDER BY AVG(rating) LIMIT 10;

-- 4. Иерархические запросы
--4.1 Подзапросы: достать любые 10 imbdId из links у которых средний рейтинг больше 3.5.
SELECT imdbid FROM links WHERE movieid IN (
	SELECT movieid FROM ratings GROUP BY movieid HAVING AVG(rating) > 3.5
	)
LIMIT 10;

-- 4.2 Common Table Expressions: посчитать средний рейтинг по пользователям, у которых более 10 оценок.
-- Нужно подсчитать средний рейтинг по все пользователям, которые попали под условие -
-- то есть в ответе должно быть одно число.
WITH users_with_10_marks AS (
	SELECT userid FROM ratings GROUP BY userid HAVING COUNT(*) > 10
)
SELECT AVG(R.rating) FROM ratings AS R JOIN users_with_10_marks U ON R.userid = U.userid;