-- 1 Вывести TOP-3 региона с самым большим объемом выдач за 1 полугодие 2017 г.
SELECT
	R.region_name,
	SUM(CT.contract_limit) AS total_value
FROM
	contract AS CT
	JOIN application AS A ON CT.application_id = A.id
	JOIN customer AS CR ON A.customer_id = CR.id
	JOIN region AS R ON CR.region_id = R.id
WHERE
	CT.contract_date >= '2017-01-01'
	AND CT.contract_date < '2017-07-01'
GROUP BY
	R.region_name
ORDER BY
	total_value DESC
LIMIT 3;

-- 2 Вывести top-3 клиентов, которые после которые после погашения трех займов
-- принесли компании максимальную прибыль 
WITH contract_value AS (
	SELECT application_id, SUM(payment_fv + payment_iv + payment_pv) AS value
	FROM transaction
	GROUP BY application_id
)
SELECT
	id AS customer_id,
	name as customer_name,
	customer_value
 FROM (
	SELECT
		CR.id,
		CR.name,
		CT.application_id,
		DENSE_RANK() OVER (PARTITION BY CR.id ORDER BY CT.contract_date) AS loan_index,
		SUM(CV.value) OVER (PARTITION BY CR.id ORDER BY CT.contract_date) customer_value
	FROM
		contract AS CT
		JOIN application AS A ON CT.application_id = A.id
		JOIN customer AS CR ON A.customer_id = CR.id
		JOIN contract_value AS CV ON CT.application_id = CV.application_id
	) as tmp
WHERE loan_index = 3
ORDER BY customer_value DESC
LIMIT 3;

-- 3 Вывести клиентов, получивших максимальное количество займов за 2017 год.
-- Вывести баланс по каждому из них в динамике
WITH customers_with_max_loans AS (
	SELECT
		CR.id
	FROM
		contract AS CT
		JOIN application AS A ON CT.application_id = A.id
		JOIN customer AS CR ON A.customer_id = CR.id
	WHERE
		CT.contract_date >= '2017-01-01'
		AND CT.contract_date < '2018-01-01'
	GROUP BY
		CR.id
	HAVING
		COUNT(*) = (
			SELECT
				COUNT(*) AS num_of_loans
			FROM
				contract AS CT
				JOIN application AS A ON CT.application_id = A.id
				JOIN customer AS CR ON A.customer_id = CR.id
			WHERE
				CT.contract_date >= '2017-01-01'
				AND CT.contract_date < '2018-01-01'
			GROUP BY
				CR.id
			ORDER BY
				num_of_loans DESC
			LIMIT 1)
)
SELECT DISTINCT
	CR.id,
	CR.name,
	T.operation_date,
	T.amount,
	T.direction,
	SUM(T.amount * T.direction) OVER (PARTITION BY CR.id ORDER BY T.operation_date) AS balance
FROM
	contract AS CT
	JOIN transaction AS T ON T.application_id = CT.application_id
	JOIN application AS A ON CT.application_id = A.id
	JOIN customer AS CR ON A.customer_id = CR.id
WHERE CR.id IN (SELECT id FROM customers_with_max_loans)
ORDER BY
	CR.id, T.operation_date;

-- 4 Для каждого повторного займа вычислить отношение дохода, полученного на предыдущем займе
-- к сумме текущего
WITH customer_contract_value AS (
	SELECT application_id, customer_value FROM (
		SELECT
			CR.id,
			CT.application_id,
			CT.contract_finished_date,
			T.operation_date,
			T.direction,
			SUM(T.payment_fv + T.payment_iv + T.payment_pv)
				OVER (PARTITION BY CR.id ORDER BY T.operation_date) customer_value
		FROM
			contract AS CT
			JOIN application AS A ON CT.application_id = A.id
			JOIN customer AS CR ON A.customer_id = CR.id
			JOIN transaction AS T ON CT.application_id = T.application_id
		) AS tmp
	WHERE
		operation_date IS NULL OR (operation_date = contract_finished_date AND direction = 1)
),
current_and_last_contract AS (
	SELECT
		CR.id,
		CT.application_id,
		CT.contract_date,
		CT.contract_limit,
		LAG(CT.application_id, 1) OVER (PARTITION BY CR.id ORDER BY CT.contract_date) last_contract_id 
	FROM
		contract AS CT
		JOIN application AS A ON CT.application_id = A.id
		JOIN customer AS CR ON A.customer_id = CR.id
	ORDER BY CR.id, CT.contract_date
)
SELECT
	L.application_id,
	L.contract_limit,
	V.customer_value,
	V.customer_value / L.contract_limit AS value_ratio
FROM
	customer_contract_value V JOIN current_and_last_contract L ON L.last_contract_id = V.application_id
WHERE
	L.last_contract_id IS NOT NULL
LIMIT 10;
	
-- 5 Для каждого займа вычислить отношение суммы займа к максимальной сумме, когда-либо полученной клиентом
SELECT
	CR.id AS customer_id,
	CT.application_id,
	CT.contract_limit,
	CT.contract_limit / MAX(CT.contract_limit) OVER (PARTITION BY CR.id) AS limit_ratio
FROM
	contract AS CT
	JOIN application AS A ON CT.application_id = A.id
	JOIN customer AS CR ON A.customer_id = CR.id
LIMIT 10;

-- 6 Вывести дефолт 5+ по регионам, по которым было более было более 3 выдач
SELECT
	R.region_name,
	COUNT(*),
	AVG(
		CASE 
			WHEN CT.contract_finished_date IS NULL THEN 1
			WHEN (CT.contract_finished_date - CT.contract_date) > (A.application_days + 5) THEN 1
			ELSE 0
		END
	) AS risc_5
FROM
	contract AS CT
	JOIN application AS A ON CT.application_id = A.id
	JOIN customer AS CR ON A.customer_id = CR.id
	JOIN region AS R ON CR.region_id = R.id
GROUP BY
	R.region_name
HAVING
	COUNT(*) > 3;

-- 7 Вывести средний чек в разрезе пола / возраста
SELECT
	CR.gender,
	CASE 
		WHEN (CURRENT_DATE - CR.birthdate) / 365 < 25 THEN 'less 25'
		WHEN (CURRENT_DATE - CR.birthdate) / 365 BETWEEN 25 AND 30 THEN '25..30'
		WHEN (CURRENT_DATE - CR.birthdate) / 365 BETWEEN 30 AND 45 THEN '30..45'
		WHEN (CURRENT_DATE - CR.birthdate) / 365 > 45 THEN 'more 45'
	END AS age,
	AVG(CT.contract_limit::NUMERIC(7,2))::MONEY average_limit
FROM
	contract AS CT
	JOIN application AS A ON CT.application_id = A.id
	JOIN customer AS CR ON A.customer_id = CR.id
GROUP BY
	CR.gender,
	CASE 
		WHEN (CURRENT_DATE - CR.birthdate) / 365 < 25 THEN 'less 25'
		WHEN (CURRENT_DATE - CR.birthdate) / 365 BETWEEN 25 AND 30 THEN '25..30'
		WHEN (CURRENT_DATE - CR.birthdate) / 365 BETWEEN 30 AND 45 THEN '30..45'
		WHEN (CURRENT_DATE - CR.birthdate) / 365 > 45 THEN 'more 45'
	END
ORDER BY
	CR.gender, age;

-- 8 Вывести top 5 клиентов с максимальной переплатой
SELECT
	CR.id AS customer_id,
	SUM(T.amount - T.payment_fv - T.payment_iv - T.payment_pv) as total_overpayment
FROM
	contract AS CT
	JOIN application AS A ON CT.application_id = A.id
	JOIN customer AS CR ON A.customer_id = CR.id
	JOIN transaction AS T ON CT.application_id = T.application_id
WHERE
	T.direction = 1
GROUP BY
	CR.id
HAVING
	SUM(T.amount - T.payment_fv - T.payment_iv - T.payment_pv)::NUMERIC(8, 2) >= 0.01 
ORDER BY
	total_overpayment DESC
LIMIT 5;

-- 9 Вывести top 3 продукта с максимальной долей отмененных заявок
SELECT
	P.productname,
	AVG(CASE WHEN A.status = 'Canceled' THEN 1.0 ELSE 0.0 END) cancel_ratio
FROM
	application A JOIN product P on A.product_id = P.id
GROUP BY
	P.productname
ORDER BY
	cancel_ratio DESC
LIMIT 3;

-- 10 Вывести top 3 региона с наибольшим количеством одобрений по первичным заявкам
SELECT
	region_name,
	AVG(approve) AS approve_rate
FROM (
	SELECT
		R.region_name,
		CR.id,
		A.id,
		CASE WHEN A.status = 'Approve' THEN 1.0 ELSE 0.0 END AS approve,
		RANK() OVER (PARTITION BY CR.id ORDER BY A.application_date) application_num
	FROM
		application AS A
		JOIN customer AS CR ON A.customer_id = CR.id
		JOIN region AS R ON CR.region_id = R.id
) as tmp
WHERE application_num = 1
GROUP BY region_name
ORDER BY approve_rate DESC
LIMIT 3;