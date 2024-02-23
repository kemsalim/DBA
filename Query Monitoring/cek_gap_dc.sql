	SELECT a.thread#, b. last_seq, a.applied_seq, to_char (a.last_app_timestamp, 'YYYY-MM-DD HH24:MI:SS') "TANGGAL    JAM", b.last_seq-a.applied_seq
	ARC_DIFF FROM (SELECT  thread#, MAX(sequence#) applied_seq, MAX(next_time) last_app_timestamp
	FROM gv$archived_log WHERE applied = 'YES' or applied='IN-MEMORY' GROUP BY thread#) a, 
	(SELECT  thread#, MAX (sequence#) last_seq FROM gv$archived_log GROUP BY thread#) b 
	WHERE a.thread# = b.thread#;