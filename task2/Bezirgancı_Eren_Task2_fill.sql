USE mydb;

/********************/
/* FILL LEAGUE TABLE */
/********************/
DELIMITER //

CREATE PROCEDURE league_fill( 
	IN row_num INT
)
BEGIN
    DECLARE counter INT;
    DECLARE league_name VARCHAR(45);
    DECLARE rnd_str VARCHAR(45);
    DECLARE last_str VARCHAR(45);
    SET counter = 0;
    SET league_name = "league";
    
    loop_label: LOOP
		IF counter < row_num THEN
			SET rnd_str = lpad(conv(floor(rand()*pow(36,6)), 10, 36), 6, 0);
			SET last_str = CONCAT(league_name, "-" ,rnd_str);
			INSERT INTO league VALUES(default,last_str);
           
		ELSE 
			LEAVE loop_label;
           
		END IF;
			SET counter= counter + 1;
	END LOOP;

END//



/



/********************/
/* FILL REFREE TABLE */
/********************/

CREATE PROCEDURE refree_fill( 
	IN row_num_2 INT
)
BEGIN
    DECLARE counter INT;
    DECLARE refree_name VARCHAR(45);
	DECLARE refree_surname VARCHAR(45);
    
    DECLARE rnd_str VARCHAR(45);
    DECLARE fnl_name VARCHAR(45);
    DECLARE fnl_surname VARCHAR(45);
    

    SET counter = 0;
    SET refree_name = "name";
	SET refree_surname = "surname";
    
    loop_label: LOOP
		IF counter < row_num_2 THEN
			SET rnd_str = lpad(conv(floor(rand()*pow(36,6)), 10, 36), 6, 0);
			SET fnl_name = CONCAT(refree_name, "-" ,rnd_str);
			SET fnl_surname = CONCAT(refree_surname, "-" ,rnd_str);
			INSERT INTO refree VALUES(default,fnl_name,fnl_surname,35);
           
		ELSE 
			LEAVE loop_label;
           
		END IF;
			SET counter= counter + 1;
	END LOOP;

END//


DELIMITER ;

/


/********************/
/* FILL CLUB TABLE */
/********************/

DELIMITER $$
CREATE PROCEDURE club_fill (
	IN row_num INT
)
BEGIN
	DECLARE counter INT;
	DECLARE finished INTEGER DEFAULT 0;
    DECLARE name VARCHAR(45) DEFAULT "club_name";
    DECLARE win INT DEFAULT 172;
	DECLARE loose INT DEFAULT 100;
	DECLARE tie INT DEFAULT 28;
	DEClARE league_id INT;
    
    
	-- declare cursor for employee email
	DEClARE cur_league_id CURSOR FOR SELECT id FROM league;

	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
    SET counter = 0;

    
    loop_label: LOOP
		
		IF counter < row_num THEN
			OPEN cur_league_id;
			get_league_id: LOOP
				FETCH cur_league_id INTO league_id;

				IF finished = 1 THEN 
					LEAVE get_league_id;
                    
				END IF;
				INSERT INTO club VALUES(default,name, win,loose,tie,league_id);

			END LOOP get_league_id;
		ELSE 
			LEAVE loop_label;
           
		END IF;
			SET counter= counter + 1;
		CLOSE cur_league_id;
	END LOOP loop_label;
    


	
    
    

END$$
DELIMITER ;

/

/********************/
/* FILL SEASON TABLE */
/********************/

DELIMITER $$
CREATE PROCEDURE season_fill (
	
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;

	DEClARE league_id INT;
    
	-- declare cursor for employee email
	DEClARE cur_league_id CURSOR FOR SELECT id FROM league;

	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN cur_league_id;

	get_league_id: LOOP
		FETCH cur_league_id INTO league_id;

		IF finished = 1 THEN 
			LEAVE get_league_id;
		END IF;
		INSERT INTO season VALUES(default,CURDATE(),CURDATE(),league_id);

	END LOOP get_league_id;
	CLOSE cur_league_id;

END$$
DELIMITER ;

/

/********************/
/* FILL PLAYER TABLE */
/********************/


DELIMITER $$
CREATE PROCEDURE player_fill (
	
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;

	DEClARE league_id INT;
    DEClARE club_id INT;
    
	-- declare cursor for employee email
	DEClARE cur_league_id CURSOR FOR SELECT id FROM league;
	DEClARE cur_club_id CURSOR FOR SELECT id FROM club;

	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

	OPEN cur_league_id;
    OPEN cur_club_id;
    
	get_league_id: LOOP
		FETCH cur_league_id INTO league_id;
        FETCH cur_club_id INTO club_id;

		IF finished = 1 THEN 
			LEAVE get_league_id;
		END IF;
		INSERT INTO player VALUES(default,"player_name","player_surname",25, "sf",club_id,league_id);

	END LOOP get_league_id;
	CLOSE cur_league_id;
    CLOSE cur_club_id;

END$$
DELIMITER ;

/

/********************/
/* FILL MATCH TABLE */
/********************/


DELIMITER $$
CREATE PROCEDURE match_fill (
	
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;

	
    DEClARE club_id INT;
	DEClARE opponent_club_id INT;
	DEClARE refree_id INT;
	DEClARE season_id INT;
    
	-- declare cursor for employee email

	DEClARE cur_club_id CURSOR FOR SELECT id FROM club;
	DEClARE cur_refree_id CURSOR FOR SELECT id FROM refree;
	DEClARE cur_season_id CURSOR FOR SELECT id FROM season;

	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


    OPEN cur_club_id;
    OPEN cur_refree_id;
    OPEN cur_season_id; 
    
	get_league_id: LOOP

        FETCH cur_club_id INTO club_id;
		FETCH cur_refree_id INTO refree_id;
		FETCH cur_season_id INTO season_id;

		IF finished = 1 THEN 
			LEAVE get_league_id;
		END IF;

        IF club_id > 1 THEN
            SET opponent_club_id= club_id-1;
			INSERT INTO the_match VALUES(default,curdate(),"MARIBOR",club_id, opponent_club_id ,refree_id,1,2,club_id, season_id);
		ELSE
			SET opponent_club_id= club_id+1;
			INSERT INTO the_match VALUES(default,curdate(),"MARIBOR",club_id, opponent_club_id ,refree_id,1,2,club_id, season_id);
		END IF;
        
        
	END LOOP get_league_id;

    CLOSE cur_club_id;
    CLOSE cur_refree_id;
    CLOSE cur_season_id;

END$$
DELIMITER ;

/

/********************/
/* FILL TRANSFER TABLE */
/********************/


DELIMITER $$
CREATE PROCEDURE transfer_fill (
	
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;

	
    DEClARE club_id INT;
	DEClARE other_club_id INT;
	DEClARE player_id INT;

    
	-- declare cursor for employee email

	DEClARE cur_club_id CURSOR FOR SELECT id FROM club;
	DEClARE cur_player_id CURSOR FOR SELECT id FROM player;


	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


    OPEN cur_club_id;
    OPEN cur_player_id;

    
	get_league_id: LOOP

        FETCH cur_club_id INTO club_id;
		FETCH cur_player_id INTO player_id;


		IF finished = 1 THEN 
			LEAVE get_league_id;
		END IF;

        IF club_id > 1 THEN
            SET other_club_id= club_id-1;
			INSERT INTO transfer VALUES(default,club_id,other_club_id ,player_id,1000000);
		ELSE
			SET other_club_id= club_id+1;
			INSERT INTO transfer VALUES(default,club_id,other_club_id ,player_id,1000000);
		END IF;
        
        
	END LOOP get_league_id;

    CLOSE cur_club_id;
    CLOSE cur_player_id;

END$$
DELIMITER ;

/

/********************/
/* FILL CLUB_STATS TABLE */
/********************/



DELIMITER $$
CREATE PROCEDURE club_stats_fill (
	
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;

	
    DEClARE club_id INT;
	DEClARE season_id INT;

    
	-- declare cursor for employee email

	DEClARE cur_club_id CURSOR FOR SELECT id FROM club;
	DEClARE cur_season_id CURSOR FOR SELECT id FROM season;


	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;


    OPEN cur_club_id;
    OPEN cur_season_id;

    
	get_league_id: LOOP

        FETCH cur_club_id INTO club_id;
		FETCH cur_season_id INTO season_id;


		IF finished = 1 THEN 
			LEAVE get_league_id;
		END IF;
        
        INSERT INTO club_stats VALUES(default,season_id,club_id, 22, 8, 5, 71);
        
        
	END LOOP get_league_id;

    CLOSE cur_club_id;
    CLOSE cur_season_id;

END$$
DELIMITER ;

/

/********************/
/* FILL ACTIONS TABLE */
/********************/


DELIMITER $$
CREATE PROCEDURE actions_fill (
	
)
BEGIN
	DECLARE finished INTEGER DEFAULT 0;

	

	DEClARE player_id INT;
	DEClARE match_id INT;

    
	-- declare cursor for employee email


	DEClARE cur_player_id CURSOR FOR SELECT id FROM player;
	DEClARE cur_match_id CURSOR FOR SELECT id FROM the_match;
	
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;

    OPEN cur_player_id;
    OPEN cur_match_id;

	get_league_id: LOOP
    
		FETCH cur_player_id INTO player_id;
		FETCH cur_match_id INTO match_id;

		IF finished = 1 THEN 
			LEAVE get_league_id;
		END IF;
        
        INSERT INTO actions VALUES(default,51, match_id ,1, 0, 0,player_id);
        
        
	END LOOP get_league_id;

    CLOSE cur_player_id;
    CLOSE cur_match_id;

END$$
DELIMITER ;








