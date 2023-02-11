-- Case Study: Using the "Full European Soccer Database", determine who defeated Manchester United in the 2013/2014 season;
-- How badly did Manchester United lose in each match?
  -- Steps to construct the query - 1. Get team names with CTEs 2. Get match outcome with CASE statements 3. Determine how badly they lost with a window function 
  
-- 1: Create a subquery to setup the home team ; Filters for matches where Manchester United played as the home team.

SELECT  

  m.id,  

  t.team_long_name, 

  -- Identify matches as home/away wins or ties 

  CASE WHEN m.home_goal > away_goal THEN 'MU Win' 

      WHEN m.home_goal < away_goal THEN 'MU Loss' 

      ELSE 'Tie' END AS outcome 

FROM match AS m 

-- Left join team on the home team ID and team API id 

LEFT JOIN team AS t  

ON m.hometeam_id = t.team_api_id 

WHERE  

  -- Filter for 2014/2015 and Manchester United as the home team 

  season = '2014/2015' 

  AND t.team_long_name = 'Manchester United';
  
  
-- 1: Create a subquery to setup the away team ; Filters for matches where Manchester United played as the away team.

SELECT  

    m.id,  

    t.team_long_name, 

    -- Identify matches as home/away wins or ties 

    CASE WHEN m.home_goal > away_goal THEN 'MU Loss' 

        WHEN m.home_goal < away_goal THEN 'MU Win' 

        ELSE 'Tie' END AS outcome 

-- Join team table to the match table 

FROM match AS m 

LEFT JOIN team AS t  

ON m.awayteam_id = t.team_api_id 

WHERE  

    -- Filter for 2014/2015 and Manchester United as the away team 

    season = '2014/2015' 

    AND t.team_long_name = 'Manchester United'; 
    
    
-- 1: Combine the Subqueries into a CTE ; Extracts all matches played by Manchester United in the 2014/2015 season
-- 2: Get match outcome with CASE statements

-- Set up the home team CTE 

WITH home AS ( 

  SELECT m.id, t.team_long_name, 

    CASE WHEN m.home_goal > m.away_goal THEN 'MU Win' 

       WHEN m.home_goal < m.away_goal THEN 'MU Loss'  

         ELSE 'Tie' END AS outcome 

  FROM match AS m 

  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id), 

-- Set up the away team CTE 

away AS ( 

  SELECT m.id, t.team_long_name, 

    CASE WHEN m.home_goal > m.away_goal THEN 'MU Win' 

       WHEN m.home_goal < m.away_goal THEN 'MU Loss'  

         ELSE 'Tie' END AS outcome 

  FROM match AS m 

  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id) 

-- Select team names, the date and goals 

SELECT DISTINCT 

    m.date, 

    home.team_long_name AS home_team, 

    away.team_long_name AS away_team, 

    m.home_goal, 

    m.away_goal 

-- Join the CTEs onto the match table 

FROM match AS m 

LEFT JOIN home ON m.id = home.id 

LEFT JOIN away ON m.id = away.id 

WHERE m.season = '2014/2015' 

      AND (home.team_long_name = 'Manchester United'  

           OR away.team_long_name = 'Manchester United');
           
           
-- 3: Determine how badly Manchester United lost, by using a window function

-- Set up the home team CTE
WITH home AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Win'
		   WHEN m.home_goal < m.away_goal THEN 'MU Loss' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.hometeam_id = t.team_api_id),
-- Set up the away team CTE
away AS (
  SELECT m.id, t.team_long_name,
	  CASE WHEN m.home_goal > m.away_goal THEN 'MU Loss'
		   WHEN m.home_goal < m.away_goal THEN 'MU Win' 
  		   ELSE 'Tie' END AS outcome
  FROM match AS m
  LEFT JOIN team AS t ON m.awayteam_id = t.team_api_id)
-- Select columns and and rank the matches by goal difference
SELECT DISTINCT
    m.date,
    home.team_long_name AS home_team,
    away.team_long_name AS away_team,
    m.home_goal, m.away_goal,
    RANK() OVER(ORDER BY ABS(home_goal - away_goal) DESC) as match_rank
-- Join the CTEs onto the match table
FROM match AS m
LEFT JOIN home ON m.id = home.id
LEFT JOIN away ON m.id = away.id
WHERE m.season = '2014/2015'
      AND ((home.team_long_name = 'Manchester United' AND home.outcome = 'MU Loss')
      OR (away.team_long_name = 'Manchester United' AND away.outcome = 'MU Loss'));
