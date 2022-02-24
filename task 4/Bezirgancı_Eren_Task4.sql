
USE mydb;

CALL league_fill(1000000);
SELECT * FROM league;

CALL refree_fill(1000000);
SELECT * FROM refree;

CALL club_fill(1);
SELECT * FROM club;

CALL season_fill();
SELECT * FROM season;

CALL match_fill();
SELECT * FROM the_match;

CALL player_fill();
SELECT * FROM player;

CALL match_fill();
SELECT * FROM the_match;

CALL transfer_fill();
SELECT * FROM transfer;

CALL club_stats_fill();
SELECT * FROM club_stats;

CALL actions_fill();
SELECT * FROM actions;



/*************/
/* 1) which teams in their history have more than 4 goal in a match in the clubs which has id between 200-350 and show how many times did these clubs pass 60 points? */
/*************/
SELECT 
    c.name,
    c.id,
    SUM(cs.total_point) AS total_point,
    COUNT(DISTINCT cs.season) AS how_many
FROM
	club c
INNER JOIN 
	club_stats cs 
ON 
	c.id = cs.club AND	cs.total_point > 60
GROUP BY 
	c.id
HAVING 
	c.id >110 AND c.id <150;

/*************/
/* 2)how many matches which have id between 55-354 there is at least one red? */
/*************/

SELECT 
    m.id,
    m.time_of_match,
    m.location,
    (SELECT name FROM club WHERE id = m.home) AS home,
    (SELECT name FROM club WHERE id = m.guest) AS guest,
    COUNT(a.red_card) AS total_red_card
FROM
	the_match m
INNER JOIN 
	actions a 
ON 
	m.id = a.the_match AND a.red_card > 0
GROUP BY 
	m.id
HAVING
	m.id >55 AND m.id<354;


/*************/
/* 3)Show the players who did not make any transfer in their career and if there are such players show their current club?*/
/*************/
SELECT 
    p.id,
    p.name,
    c.name
FROM
	player p
INNER JOIN 
	club c 
ON 
	p.club_id = c.id	
WHERE NOT EXISTS(SELECT 1 FROM transfer t WHERE p.id = t.player)
GROUP BY 
	p.id,
    p.name;
/*************/
/* 4)Which players whose club has more than 200 wins made a score between 80 min and 90 min ?*/
/*************/
SELECT
	p.id,
    p.name,
    a.minute
FROM
	player p
INNER JOIN 
	actions a 
WHERE
	p.id = a.player AND	a.minute > 80 AND a.minute < 90 AND a.goals = 1 AND 200 < (SELECT total_win from club WHERE id = p.club_id)
GROUP BY 
	p.id,
    a.minute;
    








    



    


