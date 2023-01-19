-- Kills currently running Tasks whose status is equal to 2, by inputting the Task ID

UPDATE ABCLog.AUTOMATION
SET task_status = 3
WHERE task_status = 2
AND task_id IN (X) -- Replace the "X" with the task_id you want to kill (it'll be a number)
