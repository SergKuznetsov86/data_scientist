-- Лабораторная работа
SELECT 'ФИО: Кузнецов Сергей Игоревич';

-- Вывести список названий департаментов и количество главных врачей в каждом из этих департаментов
SELECT
	D.name,
	COUNT(DISTINCT E.chief_doc_id) AS num_of_chef_docs
FROM Department AS D JOIN Employee AS E ON D.id = E.department_id
GROUP BY D.name;

-- Вывести список департамент id в которых работаю 3 и более сотрудника
SELECT department_id FROM Employee GROUP BY department_id HAVING COUNT(*) >= 3;

-- Вывести список департамент id с максимальным количеством публикаций
SELECT department_id FROM Employee GROUP BY department_id
HAVING SUM(num_public) = (
	SELECT SUM(num_public) AS num_of_publics FROM Employee
	GROUP BY department_id ORDER BY num_of_publics DESC LIMIT 1
);

-- Вывести список имен сотрудников и департаментов с минимальным количеством в своем департаментe
WITH department_with_min_docs AS (
	SELECT department_id FROM Employee GROUP BY department_id
	HAVING COUNT(*) = (
		SELECT COUNT(*) AS num_of_docs FROM Employee
		GROUP BY department_id ORDER BY num_of_docs LIMIT 1
	)
)
SELECT
	E.name,
	D.name
FROM department_with_min_docs AS D_MIN
	JOIN Department AS D ON D_MIN.department_id = D.id
	JOIN Employee AS E ON D.id = E.department_id;

-- Вывести список названий департаментов и среднее количество публикаций для тех департаментов, в которых
-- работает более одного главного врача
WITH department_with_more_one_chef AS (
	SELECT department_id FROM Employee
	GROUP BY department_id HAVING COUNT(DISTINCT chief_doc_id) > 1
)
SELECT
	D.name,
	AVG(E.num_public) AS average_publics
FROM department_with_more_one_chef AS D_CHEF
	JOIN Department AS D ON D_CHEF.department_id = D.id
	JOIN Employee AS E ON D.id = E.department_id
GROUP BY D.name;