-- Outputs currently running tasks whose status is less than 2, with some columns about the Task and Scheduling information

SELECT t.task_name, si.start_time, si.end_time, a.task_id, a.task_process_time, a.task_status
FROM ABCLog.AUTOMATION AS a
INNER JOIN ABCMain.TASK AS t
  ON a.task_id = t.task_id
INNER JOIN ABCLog.SCHEDULE_INSTANCE AS si
  ON a.schedule_instance_id = si.schedule_instance_id
WHERE task_status < 2
