### /Month
```bash
SELECT trunc (completion_time) TIME,
SUM(BLOCKS * BLOCK_SIZE) /1024/1024/1024 SIZE_GB
FROM v$archived_log
group by trunc(completion_time)
ORDER BY 1;
```

### /Hour
```bash
col hour for a20
select to_char(trunc(COMPLETION_TIME,'HH'),'dd-mm-yyyy HH24:MI:SS') Hour,thread# , 
round(sum(BLOCKS*BLOCK_SIZE)/1024/1024/1024) GB,
count(*) Archives from v$archived_log 
--where trunc(COMPLETION_TIME) = '02-JAN-23'
group by trunc(COMPLETION_TIME,'HH'),thread#  order by 1 ;
```

### /Day
```bash
select trunc(COMPLETION_TIME,'DD') Day, thread#, 
round(sum(BLOCKS*BLOCK_SIZE)/1024/1024/1024) GB,
count(*) Archives_Generated from v$archived_log 
group by trunc(COMPLETION_TIME,'DD'),thread# order by 1;
```

