CREATE DATABASE homework5;

USE homework5;

CREATE TABLE Cars 
(
ID INT PRIMARY KEY,
Name TEXT,
Cost INT
);

INSERT INTO Cars (ID, Name, Cost) VALUES
(1, 'Audi', 52642),
(2, 'Mercedes', 57127),
(3, 'Skoda', 9000),
(4, 'Volvo', 29000),
(5, 'Bentley', 350000),
(6, 'Citroen', 21000),
(7, 'Hummer', 41400),
(8, 'Volkswagen', 21600);

-- 1. Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов
CREATE VIEW cars_up_to_25000 AS
SELECT * FROM Cars
WHERE Cost < 25000;

SELECT * FROM cars_up_to_25000;

-- 2. Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW cars_up_to_25000 AS
SELECT * FROM Cars
WHERE Cost < 30000;

-- 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE VIEW cars2 AS
SELECT * FROM Cars
WHERE name = 'Skoda' OR name = 'Audi';

SELECT * FROM cars2;

-- 4. Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.
CREATE TABLE Analysis
(
an_id INT PRIMARY KEY,
an_name TEXT,
an_cost INT,
an_price INT,
an_group INT
);

INSERT INTO Analysis 
(an_id, an_name, an_cost, an_price, an_group)
VALUES
(1, 'analysis1', 1500, 2000, 101),
(2, 'analysis2', 1600, 2200, 102),
(3, 'analysis3', 1900, 2500, 102),
(4, 'analysis4', 1300, 2100, 103),
(5, 'analysis5', 1700, 2400, 101);

CREATE TABLE Groups_an
(
gr_id INT PRIMARY KEY,
gr_name TEXT,
gr_temp INT
);

INSERT INTO Groups_an (gr_id, gr_name, gr_temp) VALUES
(101, 'group1', -2),
(102, 'group2', 1),
(103, 'group3', 4);

CREATE TABLE Orders
(
ord_id INT PRIMARY KEY,
ord_datetime DATETIME,
ord_an INT
);

INSERT INTO Orders (ord_id, ord_datetime, ord_an) VALUES
(10001, '2020-02-04 10:22:08', 2),
(10002, '2020-02-04 13:22:08', 1),
(10003, '2020-02-05 15:22:08', 5),
(10004, '2020-02-07 18:22:08', 4),
(10005, '2020-02-10 12:22:08', 3),
(10006, '2020-02-11 17:22:08', 3),
(10007, '2020-02-15 11:22:08', 2);

CREATE VIEW week_analysis AS
SELECT an_name, an_price FROM Analysis
INNER JOIN Orders 
ON Analysis.an_id = Orders.ord_an
WHERE ord_datetime BETWEEN '2020-02-05 00:00:00' AND '2020-02-12 23:59:59';

SELECT DISTINCT * FROM week_analysis;

/* 5. Добавьте новый столбец под названием «время до следующей станции». 
Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. 
Проще это сделать с помощью оконной функции LEAD . 
Эта функция сравнивает значения из одной строки со следующей строкой, чтобы получить результат. 
В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
*/

CREATE TABLE Trains
(
train_id INT,
station TEXT,
station_time TIME
);

INSERT INTO Trains (train_id, station, station_time)
VALUES
(110, 'San Francisco', '10:00:00'),
(110, 'Redwood City', '10:54:00'),
(110, 'Palo Alto', '11:02:00'),
(110, 'San Jose', '12:35:00'),
(120, 'San Francisco', '11:00:00'),
(120, 'Palo Alto', '12:49:00'),
(120, 'San Jose', '13:30:00');

SELECT train_id, station, station_time, 
COALESCE(TIMEDIFF(LEAD (station_time) OVER (PARTITION BY train_id ORDER BY train_id), station_time), ' ')
AS Time_to_next_station
FROM Trains;
