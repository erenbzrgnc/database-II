CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;

-- 1)CREATE WTHOUT CONSTRAINTS AND INDEX
CREATE TABLE league (id INT, name VARCHAR(45));
CREATE TABLE season (id INT, starting_date DATETIME, ending_date DATETIME, league INT);

-- *****************************************************************************************************

-- 2)CREATE WITH INDEX AND WITHOUT CONSTRAINT
CREATE TABLE league (id INT, name VARCHAR(45));
CREATE TABLE season (id INT, starting_date DATETIME, ending_date DATETIME, league INT);

CREATE INDEX league_name ON league(name);
CREATE INDEX season_s_date ON season(starting_date);

-- *****************************************************************************************************

-- 3)CREATE WITHOUT INDEX AND WITH CONSTRAINTS
CREATE TABLE league (id INT, name VARCHAR(45));
CREATE TABLE season (id INT, starting_date DATETIME, ending_date DATETIME, league INT);

ALTER TABLE league ADD PRIMARY KEY (id);
ALTER TABLE season ADD FOREIGN KEY (league) REFERENCES league(id) ON UPDATE CASCADE ON DELETE SET NULL;

-- *****************************************************************************************************

/********************/
/* FILL LEAGUE TABLE */
/********************/

DELIMITER $$
CREATE PROCEDURE fill_league(IN row_num INT)
BEGIN
	DECLARE counter INT;
    DECLARE league_name VARCHAR(45);
    DECLARE rnd_str VARCHAR(45);
	DECLARE last_str VARCHAR(45);
    SET counter = 0;
    START TRANSACTION;
    
	loop_label: LOOP
		IF counter < row_num THEN
			SET rnd_str = lpad(conv(floor(rand()*pow(36,6)), 10, 36), 6, 0);
			SET last_str = CONCAT(league_name, "-" ,rnd_str);
			INSERT INTO league VALUES(counter,last_str);
		   
		ELSE 
			LEAVE loop_label;
		   
		END IF;
			SET counter= counter + 1;
    END LOOP;
    COMMIT;

END$$

/********************/
/* FILL SEASON TABLE */
/********************/

DELIMITER $$
CREATE PROCEDURE season_fill (
	IN row_num INT
)
BEGIN
	DECLARE counter INT;
    DECLARE rand INT;
    DECLARE rand_date DATETIME;

	

	SET counter = 0;
    START TRANSACTION;
    loop_label: LOOP
		SET rand = ROUND((RAND() * (counter-0))+0);
        SET rand_date =DATE(FROM_UNIXTIME(FLOOR((RAND() * (UNIX_TIMESTAMP('2021-12-31') - UNIX_TIMESTAMP('1940-01-01'))) + UNIX_TIMESTAMP('1940-01-01'))));
		IF counter < row_num THEN

			INSERT INTO season VALUES(counter,rand_date, DATE_ADD(rand_date, INTERVAL 180 DAY),rand);
           
		ELSE 
			LEAVE loop_label;
           
		END IF;
			SET counter= counter + 1;
	END LOOP;
    COMMIT;


END$$
DELIMITER ;

/********************/
/* FILL SEASON TABLE in case of foreign key */
/********************/

DELIMITER $$
CREATE PROCEDURE season_fill_2 (
		IN row_num INT
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE rand_date DATETIME;
	DEClARE league_id INT;
    DECLARE counter INT;
    
    
	-- declare cursor for employee email
	DEClARE cur_league_id CURSOR FOR SELECT id FROM league;

	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    SET counter = 0;
	OPEN cur_league_id;
	START TRANSACTION;
	get_league_id: LOOP
		FETCH cur_league_id INTO league_id;
		SET rand_date =DATE(FROM_UNIXTIME(FLOOR((RAND() * (UNIX_TIMESTAMP('2021-12-31') - UNIX_TIMESTAMP('1940-01-01'))) + UNIX_TIMESTAMP('1940-01-01'))));

		IF finished = 1 OR counter >= row_num THEN
			LEAVE get_league_id;
		END IF;
        SET counter = counter + 1;
		INSERT INTO season VALUES(default,rand_date,DATE_ADD(rand_date, INTERVAL 180 DAY),league_id);

	END LOOP get_league_id;
	CLOSE cur_league_id;
    COMMIT;
END$$
DELIMITER ;

-- INSERT for 1 & 2
-- CASE 1 --
CALL fill_league(100000);
CALL season_fill(100000);
-- CASE 2 --
CALL fill_league(1000000);
CALL season_fill(1000000);
-- CASE 3 --
CALL fill_league(10000000);
CALL season_fill(10000000);

-- ********************************************************
-- ********************************************************
-- ********************************************************

-- Insert for 3(which has foreign key)

-- CASE 1 --
CALL fill_league(100000);
CALL season_fill_2(100000);
-- CASE 2 --
CALL fill_league(1000000);
CALL season_fill_2(1000000);
-- CASE 3 --
CALL fill_league(10000000);
CALL season_fill_2(10000000);
    
-- *****************************************************************************************************
-- *****************************************************************************************************

-- ----------------------------------------------------------------------------------------------
-- SELECT (1 & 2 & 3)-------------------------------------------------------------------------------
SELECT * FROM league;
EXPLAIN SELECT * FROM league;
SELECT name FROM league WHERE name='rand'; 
EXPLAIN SELECT name FROM league WHERE name='rand';

SELECT * FROM season;
EXPLAIN SELECT * FROM season;
SELECT league, starting_date FROM season WHERE id=400;
EXPLAIN SELECT league, starting_date FROM season WHERE id=400;

-- ----------------------------------------------------------------------------------------------
-- UPDATE (1 & 2 & 3)-------------------------------------------------------------------------------
UPDATE league SET name='name_updated';
EXPLAIN UPDATE league SET name='name_updated';
UPDATE league SET name='name_updated' WHERE name='rand';
EXPLAIN UPDATE league SET name='name_updated' WHERE name='rand';

UPDATE season SET starting_date=curdate();
EXPLAIN UPDATE season SET starting_date=curdate();
UPDATE season SET starting_date=curdate() WHERE id=400;
EXPLAIN UPDATE season SET starting_date=curdate() WHERE id=400;

-- ----------------------------------------------------------------------------------------------
-- DELETE (1 & 2 & 3)-------------------------------------------------------------------------------
EXPLAIN DELETE FROM league;
DELETE FROM league;
EXPLAIN DELETE FROM season;
DELETE FROM season;



