-- This query searches for a Task based on the time it is scheduled to run, that is inputted by the User

SELECT t.task_id, t.task_name, s.schedule_id, s.first_start_time, s.next_start_time, s.first_start_time_zone
FROM ABCMain.TASK AS t
INNER JOIN ABCMain.SCHEDULE AS s
  ON t.task_id = s.task_id
WHERE s.run_once = 0
  AND CONVERT(TIME, first_start_time) = CONVERT(TIME, 'X:XX:XX.XXX') -- replace "X" with the scheduled time of the task you want to see (numbers)
  -- TIME 'X:XX:XX.XXX' is UTC ; EX: '4:15:00.000' is actually 11:15 AM EST (so it is 5 hours ahead of EST)
  -- AND task_name LIKE 'X%' -- uncomment this to filter based on the task name; replace "X" with the letter of the task you want to find
  -- Comment out the first AND statement (along with the second if that has been uncommented) to see all the scheduled tasks
ORDER BY task_name
