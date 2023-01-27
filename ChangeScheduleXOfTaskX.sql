-- This query is for changing the Scheduled Start Time and End Time for a Task
  -- This query should be used in conjunction with the FindTaskXByScheduleX.sql query to first find a task and its schedule, and then go and change its schedule
    -- This query starts off with the UPDATE BLOCKS commented and the SELECT block uncommented so you can test out changing times
    
-- (Uncomment SELECT block and comment the UPDATE blocks) Run SELECT block first to test (by putting what times you want to change to) what the UPDATE blocks will do
-- Replace "X" with the scheduled time of the task you want to test what it would look like updated (numbers)
SELECT  t.task_id, t.task_name, s.schedule_id, s.first_start_time, s.next_start_time, s.first_start_time_zone,
        CONVERT(DATE, first_start_time) AS first_start_date,
        CONVERT(time, first_start_time) AS first_start_time,
        CONVERT(DATE, next_start_time) AS next_start_date,
        CONVERT(time, next_start_time) AS next_start_time,
        CONVERT(DATETIME, CONVERT(VARCHAR, CONVERT(DATE, first_start_time)) + ' XX:XX.XX.XXX') AS new_first_start_time,
        CONVERT(DATETIME, CONVERT(VARCHAR, CONVERT(DATE, next_start_time)) + ' XX:XX.XX.XXX') AS new_next_start_time

-- Run 1st UPDATE block to change the schedule of the first_start_time (will have to comment the SELECT block first)
--UPDATE s
--Set first_start_time = CONVERT(DATETIME, CONVERT(VARCHAR, CONVERT(DATE, first_start_time)) + ' XX:XX.XX.XXX')

-- Run 2nd UPDATE block to change the schedule of the next_start_time  (will have to comment the SELECT block first)
--UPDATE s
--Set next_start_time = NULL

FROM ABCMain.TASK AS t
INNER JOIN ABCMain.SCHEDULE AS s
  ON t.task_id = s.task_id
WHERE s.run_once = 0
  AND CONVERT(TIME, first_start_time) = CONVERT(TIME, 'X:XX:XX.XXX') -- filter the results to only show tasks that first start at this time ; optional
