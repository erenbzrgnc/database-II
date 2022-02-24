CREATE DATABASE IF NOT EXISTS mydb;
USE mydb;
CREATE TABLE IF NOT EXISTS mydb.player(
	id INT  NOT NULL,
	name VARCHAR(45) NOT NULL,
	surname VARCHAR(45) NOT NULL,
	age INT NOT NULL,
	position VARCHAR(45) NOT NULL,
    club_id INT,
    club_league_id INT
);

CREATE TABLE IF NOT EXISTS mydb.club(
	id INT NOT NULL,
    name VARCHAR(45) NOT NULL,
    total_win INT,
    total_lose INT,
    total_tie INT,
    league_id INT NOT NULL
);

CREATE TABLE IF NOT EXISTS mydb.transfer(
	id INT NOT NULL,
    _from INT,
    _to INT,
    player INT NOT NULL,
    fee INT

);

CREATE TABLE IF NOT EXISTS mydb.club_stats(
	id INT NOT NULL,
    season INT,
    club INT,
    win INT,
    lose INT,
    tie INT,
    total_point INT
);

CREATE TABLE IF NOT EXISTS mydb.actions(
	id INT  NOT NULL,
    minute INT,
    the_match INT NOT NULL,
    goals BIT(1) NOT NULL,
    red_card BIT(1) NOT NULL,
    yellow_card BIT(1) NOT NULL,
    player INT
);



CREATE TABLE IF NOT EXISTS mydb.league(
	id INT NOT NULL,
    name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS mydb.season(
	id INT NOT NULL,
    starting_date DATETIME,
    ending_date DATETIME,
    league INT NOT NULL
);

CREATE TABLE IF NOT EXISTS mydb.the_match(
	id INT NOT NULL,
    time_of_match DATETIME,
    location VARCHAR(45),
    home INT,
    guest INT,
    refree INT,
    home_goal INT,
    guest_goal INT,
    winner INT,
    season INT
);

CREATE TABLE IF NOT EXISTS mydb.refree(
	id INT NOT NULL,
    name VARCHAR(45),
    surname VARCHAR(45),
    age INT
);

/********************/
/* PRIMARY KEYS and AUTO INCREMENT */
/********************/

ALTER TABLE player ADD PRIMARY KEY(id);
ALTER TABLE club ADD PRIMARY KEY(id);
ALTER TABLE transfer ADD PRIMARY KEY(id);
ALTER TABLE club_stats ADD PRIMARY KEY(id);
ALTER TABLE actions ADD PRIMARY KEY(id);
ALTER TABLE league ADD PRIMARY KEY(id);
ALTER TABLE season ADD PRIMARY KEY(id);
ALTER TABLE the_match ADD PRIMARY KEY(id);
ALTER TABLE refree ADD PRIMARY KEY(id);


ALTER TABLE player MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE club MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE transfer MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE club_stats MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE actions MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE league MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE season MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE the_match MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;
ALTER TABLE refree MODIFY COLUMN id INT NOT NULL AUTO_INCREMENT;


/********************/
/* FOREIGN KEYS */
/********************/
ALTER TABLE player ADD CONSTRAINT fk_player_club_id FOREIGN KEY (club_id) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE club ADD CONSTRAINT fk_club_league_id FOREIGN KEY (league_id) REFERENCES league(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE player ADD CONSTRAINT fk_player_league_id FOREIGN KEY (club_league_id) REFERENCES club(league_id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE transfer ADD CONSTRAINT fk_from_club FOREIGN KEY (_from) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE transfer ADD CONSTRAINT fk_to_club FOREIGN KEY (_to) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE transfer ADD CONSTRAINT fk_transferred_player FOREIGN KEY (player) REFERENCES player(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE club_stats ADD CONSTRAINT fk_club_stats FOREIGN KEY (club) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE club_stats ADD CONSTRAINT fk_season_stats FOREIGN KEY (season) REFERENCES season(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE actions ADD CONSTRAINT fk_actions_player FOREIGN KEY (player) REFERENCES player(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE actions ADD CONSTRAINT fk_actions_match FOREIGN KEY (the_match) REFERENCES the_match(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE season ADD CONSTRAINT fk_season_league FOREIGN KEY (league) REFERENCES league(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE the_match ADD CONSTRAINT fk_match_home FOREIGN KEY (home) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE the_match ADD CONSTRAINT fk_match_guest FOREIGN KEY (guest) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE the_match ADD CONSTRAINT fk_match_refree FOREIGN KEY (refree) REFERENCES refree(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE the_match ADD CONSTRAINT fk_match_winner FOREIGN KEY (winner) REFERENCES club(id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE the_match ADD CONSTRAINT fk_match_season FOREIGN KEY (season) REFERENCES season(id) ON DELETE CASCADE ON UPDATE CASCADE;



/********************/
/* TRIGGERS */
/********************/

delimiter |

CREATE TRIGGER match_winner BEFORE INSERT ON the_match
  FOR EACH ROW
  BEGIN

    UPDATE club_stats SET win = win + 1 WHERE club = NEW.winner and season=new.season;
    UPDATE club_stats SET lose = lose + 1 WHERE (club = NEW.home OR club = NEW.guest) AND club != NEW.winner AND NEW.winner != null AND season=new.season;
	UPDATE club_stats SET tie = tie + 1 WHERE (club = NEW.home OR club = NEW.guest) AND NEW.winner = null AND season=new.season;
  END;
|

delimiter ;



/********************/

delimiter |

CREATE TRIGGER clubstats BEFORE INSERT ON club_stats
  FOR EACH ROW
  BEGIN
    UPDATE club SET total_win = total_win + NEW.win, total_lose = total_lose + NEW.lose,total_tie = total_tie + NEW.tie  WHERE id = NEW.club ;
  END;
|

delimiter ;

/********************/

delimiter |

CREATE TRIGGER clubstats_update BEFORE UPDATE ON club_stats
  FOR EACH ROW
  BEGIN
    UPDATE club SET total_win = total_win + NEW.win-OLD.win, total_lose = total_lose + NEW.lose-OLD.lose,total_tie= total_tie + NEW.tie-OLD.tie  WHERE id = NEW.club ;
  END;
|

delimiter ;





























