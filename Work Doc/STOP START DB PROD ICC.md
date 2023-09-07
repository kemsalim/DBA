# How to Stop and Start PROD ICC

| No | Hostname | IP | User/Pass |
|----------|----------|----------|----------|
| 1 | mncsvicc1 | 192.168.175.101 | root/1t!xBur!x |
| 2 | mncsvicc2 | 192.168.175.102 | root/KuyAB@t0k |
| 3 | mncsvicc3 | 192.168.175.103 | root/@y4mBur!x |
| 4 | mncsvicc4 | 192.168.175.104 | root/D0mB4b0t@x |

```bash
crsctl stat res -t
```
```bash
crsctl stop crs res -t
```
```bash
srvctl status database -d mncicc
```
```bash
crs_stat -t
```

#### SCREENSHOOT


### Check MRP
```bash
select process,status from v$managed_standby;
```

### Check status DB
```bash
select name, open_mode, database_role from v$database;
```

### Check cluster
```bash
crsctl stat res -t
```

#### SCREENSHOT

## Stop
1. Sebelum Stop dan Start DB lakukan precheck pada setiap database :
### Primary Node 1 and Primary Node 2
Command precheck :
```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
date
```
#### SCREENSHOOT
```bash
. .grid_env
```
```bash
crsctl stat res -t
```
```bash
date
```
#### SCREENSHOOT

```bash
lsnrctl status
```
```bash
select name, open_mode, database_role from v$database;
```
```bash
!date
```
```bash
!hostname
```
#### SCREENSHOOT

### Standby Node 3 and Standby Node 4
Command precheck :
```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
date
```
#### SCREENSHOOT
```bash
. .grid_env
```
```bash
crsctl stat res -t
```
```bash
date
```
#### SCREENSHOOT
```bash
lsnrctl status
```
```bash
select name, open_mode, database_role from v$database;
```
```bash
!date
```
```bash
!hostname
```
#### SCREENSHOOT
```bash
SELECT /*Check gap on stby with difference*/ al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied", almax-lhmax "Gap", decode(almax-lhmax, 0, 'Sync', 'Gap') "Result"
		   FROM (select thread# thrd, MAX(sequence#) almax FROM v$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) al,
		   (SELECT thread# thrd, MAX(sequence#) lhmax FROM v$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;
```
```bash
!date
```
```bash
!hostname
```
```bash
select process,status from v$managed_standby;
```
```bash
!date
```
```bash
!hostname
```

2. Lanjut kita bisa stop service DB nya.

- stop drc 1 (103)
```bash
srvctl status listener -n mncsvicc3
```
```bash
srvctl stop listener -n mncsvicc3
```
```bash
date
```
#### SCREENSHOOT
```bash
srvctl status instance -d mnciccdr -i mnciccdr1
```
```bash
srvctl stop instance -d mnciccdr -i mnciccdr1 -f
```
```bash
date
```
#### SCREENSHOOT
```bash
srvctl status asm -n mncsvicc3
```
```bash
srvctl stop asm -n mncsvicc3
```
```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
date
```
#### SCREEENSHOOT

switch redolog dua kali di dc node 2 
```bash
alter system switch logfile; 
```
	

- shutdown dc node 2 (102)-> 
   srvctl status listener -n mncsvicc2
   srvctl stop listener -n mncsvicc2
   srvctl status instance -d mncicc -i mncicc2 
   srvctl stop instance -d mncicc -i mncicc2 -f
   srvctl status asm -n mncsvicc2
   srvctl stop asm -n mncsvicc2
   ps -ef | grep pmon
   ps -ef | grep lsnr
   date
   
- switch redolog dua kali di dc node 1
   alter system switch logfile;
   alter system switch logfile;
   
- check archivelog apakah sudah apply di drc 1.
   SELECT a.thread#, b. last_seq, a.applied_seq, to_char(a. last_app_timestamp,'MM/DD/YYYY HH24:MI:SS') "last_app_timestamp", b.last_seq-a.applied_seq 
   ARC_DIFF FROM (SELECT  thread#, MAX(sequence#) applied_seq, MAX(next_time) last_app_timestamp 
   FROM gv$archived_log WHERE applied = 'YES' or applied='IN-MEMORY' GROUP BY thread#) a, 
   (SELECT  thread#, MAX (sequence#) last_seq FROM gv$archived_log GROUP BY thread#) b 
   WHERE a.thread# = b.thread#;
   
   --Check gap on standby DB with gap
   SELECT /*Check gap on stby with difference*/ al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied", almax-lhmax "Gap", decode(almax-lhmax, 0, 'Sync', 'Gap') "Result"
   FROM (select thread# thrd, MAX(sequence#) almax FROM v$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) al,
   (SELECT thread# thrd, MAX(sequence#) lhmax FROM v$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM v$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

- stop mrp on drc 2
   alter database recover managed standby database cancel;
   
- shutdwon drc2 (104): -> shutdown immediate
   srvctl status listener -n mncsvicc4 
   srvctl stop listener -n mncsvicc4
   srvctl status instance -d mnciccdr -i mnciccdr2
   srvctl stop instance -d mnciccdr -i mnciccdr2 -f
   srvctl status asm -n mncsvicc4
   srvctl stop asm -n mncsvicc4
   ps -ef | grep pmon
   ps -ef | grep lsnr
   date
   
- stop dc node 1 (101)
   srvctl status listener -n mncsvicc1
   srvctl stop listener -n mncsvicc1
   srvctl status instance -d mncicc -i mncicc1
   srvctl stop instance -d mncicc -i mncicc1 -f
   srvctl status asm -n mncsvicc1
   srvctl stop asm -n mncsvicc1 -f
   ps -ef | grep pmon
   ps -ef | grep lsnr
   date

#### SCREENSHOOT



```bash
sqlplus / as sysdba
```
```bash
shutdown immediate
```
```bash
!ps -ef | grep pmon
```
```bash
!ps -ef | grep lsnr
```
```bash
!date
```

#### SCREENSHOOT



## Start
Untuk start, kita bisa langsung dengan command berikut.

```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
lsnrctl status
```
```bash
lsnrctl start
```
```bash
lsnrctl status
```
```bash
date
```
	
#### SCREENSHOOT



```bash
sqlplus / as sysdba
```
```bash
startup
```
```bash
!ps -ef | grep pmon
```
```bash
!ps -ef | grep lsnr
```
```bash
!lsnrctl status
```
```bash
date
```

#### SCREENSHOOT
