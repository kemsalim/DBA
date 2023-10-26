# ON PRIMARY (DC) SIDE
1. You must search the name service of this primary (DC) side
2. The you must make sure the last sequence

```bash
SQL> SELECT dbid, open_mode, database_role from v$database;
```

```bash
      DBID OPEN_MODE		DATABASE_ROLE
---------- -------------------- ----------------
2267153246 READ WRITE		PRIMARY

TNS_SENADB_PR1

```bash
[oracle@dc1senadbo01 ~]$ . .bash_profile 
[oracle@dc1senadbo01 ~]$ 
[oracle@dc1senadbo01 ~]$ 
[oracle@dc1senadbo01 ~]$ echo $ORACLE_SID
senadb
[oracle@dc1senadbo01 ~]$ 
[oracle@dc1senadbo01 ~]$ 
[oracle@dc1senadbo01 ~]$ 
[oracle@dc1senadbo01 ~]$ 
[oracle@dc1senadbo01 ~]$ cd mii/scripts/
[oracle@dc1senadbo01 scripts]$ 
[oracle@dc1senadbo01 scripts]$ 
[oracle@dc1senadbo01 scripts]$ !sql
```

sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Oct 9 18:24:59 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0
```

```bash
SQL> @gap.sql

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
DGRD	  ALLOCATED		0
ARCH	  CLOSING	     2865
DGRD	  ALLOCATED		0
ARCH	  CLOSING	     2866
ARCH	  CLOSING	     2867
ARCH	  CLOSING	     2868
ARCH	  CLOSING	     2869
ARCH	  CLOSING	     2870
ARCH	  CLOSING	     2863
ARCH	  CLOSING	     2864
DGRD	  ALLOCATED		0

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
DGRD	  ALLOCATED		0

12 rows selected.


NAME	  DB_UNIQUE_NAME		       DBID LOG_MODE
--------- ------------------------------ ---------- ------------
OPEN_MODE	     DATABASE_ROLE    CURRENT_SCN
-------------------- ---------------- ----------------------------------------
SENADB	  senadb			 2267153246 ARCHIVELOG
READ WRITE	     PRIMARY	      315462686



    Thread Last Seq Received Last Seq Applied	     Gap Resu
---------- ----------------- ---------------- ---------- ----
	 1		2870		 2870	       0 Sync

```bash
SQL> SELECT dbid, open_mode, database_role from v$database;
```

      DBID OPEN_MODE		DATABASE_ROLE
---------- -------------------- ----------------
2267153246 READ WRITE		PRIMARY
```

```bash
[oracle@dc1senadbo01 scripts]$ 
[oracle@dc1senadbo01 scripts]$ 
[oracle@dc1senadbo01 scripts]$ !sql

sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Oct 9 18:32:16 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0

```bash
SQL> select current_scn from v$database;
```

CURRENT_SCN
-----------
  315467362

SQL> archive log list   
Database log mode	       Archive Mode
Automatic archival	       Enabled
Archive destination	       USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     2869
Next log sequence to archive   2871
Current log sequence	       2871
```

```bash
SQL> ALTER SYSTEM SET log_archive_dest_state_2='ENABLE';
```

System altered.

```bash
SQL> @gap.sql
```

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
DGRD	  ALLOCATED		0
ARCH	  CLOSING	     2865
DGRD	  ALLOCATED		0
ARCH	  CLOSING	     2866
ARCH	  CLOSING	     2867
ARCH	  CLOSING	     2868
ARCH	  CLOSING	     2869
ARCH	  CLOSING	     2870
ARCH	  CLOSING	     2863
ARCH	  CLOSING	     2864
LNS	  CONNECTED		0

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
DGRD	  ALLOCATED		0
LNS	  WRITING	     2871
DGRD	  ALLOCATED		0

14 rows selected.


NAME	  DB_UNIQUE_NAME		       DBID LOG_MODE
--------- ------------------------------ ---------- ------------
OPEN_MODE	     DATABASE_ROLE    CURRENT_SCN
-------------------- ---------------- ----------------------------------------
SENADB	  senadb			 2267153246 ARCHIVELOG
READ WRITE	     PRIMARY	      315482063



    Thread Last Seq Received Last Seq Applied	     Gap Resu
---------- ----------------- ---------------- ---------- ----
	 1		2870		 2870	       0 Sync

```bash
SQL> alter system switch logfile
```


# ON STANDBY (DRC) SIDE

```bash
[oracle@drcsenadbo01 ~]$ . .env_stbdb 
[oracle@drcsenadbo01 ~]$ !sql
```
sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Oct 9 18:24:06 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0
[oracle@drcsenadbo01 ~]$ 
[oracle@drcsenadbo01 ~]$ 
[oracle@drcsenadbo01 ~]$ cd mii/scripts/
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ !sql
sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Oct 9 18:24:14 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0

SQL> @gap.sql

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
ARCH	  CLOSING	     2824
DGRD	  ALLOCATED		0
DGRD	  ALLOCATED		0
ARCH	  CLOSING	     2825
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0

10 rows selected.


NAME	  DB_UNIQUE_NAME		       DBID LOG_MODE
--------- ------------------------------ ---------- ------------
OPEN_MODE	     DATABASE_ROLE    CURRENT_SCN
-------------------- ---------------- ----------------------------------------
SENADB	  senadb_stb1			 2267153246 ARCHIVELOG
MOUNTED 	     PHYSICAL STANDBY 131236941



    Thread Last Seq Received Last Seq Applied	     Gap Resu
---------- ----------------- ---------------- ---------- ----
	 1		2825		  789	    2036 Gap

```bash
SQL> show parameter archive_dest   
```

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest		     string
log_archive_dest_1		     string	 LOCATION=USE_DB_RECOVERY_FILE_
						 DEST
log_archive_dest_10		     string
log_archive_dest_11		     string
log_archive_dest_12		     string
log_archive_dest_13		     string
log_archive_dest_14		     string
log_archive_dest_15		     string
log_archive_dest_16		     string
log_archive_dest_17		     string

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_18		     string
log_archive_dest_19		     string
log_archive_dest_2		     string	 SERVICE=TNS_SENADB_PR1 NOAFFIR
						 M ASYNC VALID_FOR=(ONLINE_LOGF
						 ILES,PRIMARY_ROLE) DB_UNIQUE_N
						 AME=senadb
log_archive_dest_20		     string
log_archive_dest_21		     string
log_archive_dest_22		     string
log_archive_dest_23		     string
log_archive_dest_24		     string

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_25		     string
log_archive_dest_26		     string
log_archive_dest_27		     string
log_archive_dest_28		     string
log_archive_dest_29		     string
log_archive_dest_3		     string
log_archive_dest_30		     string
log_archive_dest_31		     string
log_archive_dest_4		     string
log_archive_dest_5		     string
log_archive_dest_6		     string

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_7		     string
log_archive_dest_8		     string
log_archive_dest_9		     string
log_archive_dest_state_1	     string	 enable
log_archive_dest_state_10	     string	 enable
log_archive_dest_state_11	     string	 enable
log_archive_dest_state_12	     string	 enable
log_archive_dest_state_13	     string	 enable
log_archive_dest_state_14	     string	 enable
log_archive_dest_state_15	     string	 enable
log_archive_dest_state_16	     string	 enable

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_state_17	     string	 enable
log_archive_dest_state_18	     string	 enable
log_archive_dest_state_19	     string	 enable
log_archive_dest_state_2	     string	 enable
log_archive_dest_state_20	     string	 enable
log_archive_dest_state_21	     string	 enable
log_archive_dest_state_22	     string	 enable
log_archive_dest_state_23	     string	 enable
log_archive_dest_state_24	     string	 enable
log_archive_dest_state_25	     string	 enable
log_archive_dest_state_26	     string	 enable

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_state_27	     string	 enable
log_archive_dest_state_28	     string	 enable
log_archive_dest_state_29	     string	 enable
log_archive_dest_state_3	     string	 enable
log_archive_dest_state_30	     string	 enable
log_archive_dest_state_31	     string	 enable
log_archive_dest_state_4	     string	 enable
log_archive_dest_state_5	     string	 enable
log_archive_dest_state_6	     string	 enable
log_archive_dest_state_7	     string	 enable
log_archive_dest_state_8	     string	 enable

NAME				     TYPE	 VALUE
------------------------------------ ----------- ------------------------------
log_archive_dest_state_9	     string	 enable
SQL> 
SQL> 
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ 

```bash
[oracle@drcsenadbo01 scripts]$ tnsping TNS_SENADB_PR1
```

TNS Ping Utility for Linux: Version 19.0.0.0.0 - Production on 09-OCT-2023 18:29:00

Copyright (c) 1997, 2020, Oracle.  All rights reserved.

Used parameter files:


Used TNSNAMES adapter to resolve the alias
Attempting to contact (DESCRIPTION = (ADDRESS_LIST = (ADDRESS =(PROTOCOL = TCP)(HOST = dc1senadbo01.corp.bi.go.id)(PORT = 1521))) (CONNECT_DATA = (SID = senadb) (GLOBAL_NAME = senadb)))
OK (10 msec)

```bash
[oracle@drcsenadbo01 scripts]$ sqlplus sys/bicloudera#123@TNS_SENADB_PR1 as sysdba
```
SQL*Plus: Release 19.0.0.0.0 - Production on Mon Oct 9 18:31:35 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0

SQL> SELECT dbid, open_mode, database_role from v$database;

      DBID OPEN_MODE		DATABASE_ROLE
---------- -------------------- ----------------
2267153246 READ WRITE		PRIMARY

```bash
SQL> select current_scn from v$database;
```

CURRENT_SCN
-----------
  315467546

```bash
SQL> archive log list
```
Database log mode	       Archive Mode
Automatic archival	       Enabled
Archive destination	       USE_DB_RECOVERY_FILE_DEST
Oldest online log sequence     2869
Next log sequence to archive   2871
Current log sequence	       2871
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ ps -ef | grep mrp
oracle    710719  709081  0 18:33 pts/0    00:00:00 grep --color=auto mrp
[oracle@drcsenadbo01 scripts]$ 
[oracle@drcsenadbo01 scripts]$ 
```bash
[oracle@drcsenadbo01 scripts]$ rman target /
```

Recovery Manager: Release 19.0.0.0.0 - Production on Mon Oct 9 18:33:41 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2019, Oracle and/or its affiliates.  All rights reserved.

connected to target database: SENADB (DBID=2267153246, not open)

```bash
RMAN> recover standby database from service TNS_SENADB_PR1;
```

Starting recover at 09-OCT-23
using target database control file instead of recovery catalog
Oracle instance started

Total System Global Area   15032382560 bytes

Fixed Size                    15991904 bytes
Variable Size               1040187392 bytes
Database Buffers           13958643712 bytes
Redo Buffers                  17559552 bytes

contents of Memory Script:
{
   restore standby controlfile from service  'TNS_SENADB_PR1';
   alter database mount standby database;
}
executing Memory Script

Starting restore at 09-OCT-23
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=467 device type=DISK

channel ORA_DISK_1: starting datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
channel ORA_DISK_1: restoring control file
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
output file name=+DATA/SENADB_STB1/CONTROLFILE/current.257.1128703139
output file name=+RECO/SENADB_STB1/CONTROLFILE/current.256.1128703139
Finished restore at 09-OCT-23

released channel: ORA_DISK_1
Statement processed
For record type BACKUP PIECE RECIDS from 13 to 234 are re-used before resync
For record type BACKUP SET RECIDS from 8 to 273 are re-used before resync
For record type DELETED OBJECT RECIDS from 888 to 3846 are re-used before resync
Executing: alter system set standby_file_management=manual

contents of Memory Script:
{
set newname for datafile  1 to 
 "+DATA/SENADB_STB1/DATAFILE/system.265.1128704045";
set newname for datafile  2 to 
 "+DATA/SENADB_STB1/DATAFILE/senarmantbs.259.1128704045";
set newname for datafile  3 to 
 "+DATA/SENADB_STB1/DATAFILE/sysaux.266.1128704085";
set newname for datafile  4 to 
 "+DATA/SENADB_STB1/DATAFILE/undotbs1.267.1128704085";
set newname for datafile  5 to 
 "+DATA/SENADB_STB1/DATAFILE/senascmtbs.260.1128704045";
set newname for datafile  7 to 
 "+DATA/SENADB_STB1/DATAFILE/users.268.1128704085";
set newname for datafile  8 to 
 "+DATA/SENADB_STB1/DATAFILE/senarangertbs.261.1128704045";
set newname for datafile  9 to 
 "+DATA/SENADB_STB1/DATAFILE/senahuetbs.262.1128704045";
set newname for datafile  10 to 
 "+DATA/SENADB_STB1/DATAFILE/senametatbs.263.1128704045";
set newname for datafile  11 to 
 "+DATA/SENADB_STB1/DATAFILE/senaoozietbs.264.1128704045";
set newname for datafile  12 to 
 "+DATA/SENADB_STB1/DATAFILE/senaamontbs.258.1128704043";
   catalog datafilecopy  "+DATA/SENADB_STB1/DATAFILE/system.265.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/senarmantbs.259.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/sysaux.266.1128704085", 
 "+DATA/SENADB_STB1/DATAFILE/undotbs1.267.1128704085", 
 "+DATA/SENADB_STB1/DATAFILE/senascmtbs.260.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/users.268.1128704085", 
 "+DATA/SENADB_STB1/DATAFILE/senarangertbs.261.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/senahuetbs.262.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/senametatbs.263.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/senaoozietbs.264.1128704045", 
 "+DATA/SENADB_STB1/DATAFILE/senaamontbs.258.1128704043";
   switch datafile all;
}
executing Memory Script

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

executing command: SET NEWNAME

Starting implicit crosscheck backup at 09-OCT-23
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=901 device type=DISK
Crosschecked 13 objects
Finished implicit crosscheck backup at 09-OCT-23

Starting implicit crosscheck copy at 09-OCT-23
using channel ORA_DISK_1
Finished implicit crosscheck copy at 09-OCT-23

searching for all files in the recovery area
cataloging files...
cataloging done

List of Cataloged Files
=======================
File Name: +RECO/SENADB_STB1/ARCHIVELOG/2023_10_06/thread_1_seq_2824.372.1149522931
File Name: +RECO/SENADB_STB1/ARCHIVELOG/2023_10_06/thread_1_seq_2825.484.1149530613

cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/system.265.1128704045 RECID=1 STAMP=1149791691
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senarmantbs.259.1128704045 RECID=2 STAMP=1149791691
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/sysaux.266.1128704085 RECID=3 STAMP=1149791691
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/undotbs1.267.1128704085 RECID=4 STAMP=1149791691
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senascmtbs.260.1128704045 RECID=5 STAMP=1149791691
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/users.268.1128704085 RECID=6 STAMP=1149791692
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senarangertbs.261.1128704045 RECID=7 STAMP=1149791692
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senahuetbs.262.1128704045 RECID=8 STAMP=1149791692
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senametatbs.263.1128704045 RECID=9 STAMP=1149791692
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senaoozietbs.264.1128704045 RECID=10 STAMP=1149791692
cataloged datafile copy
datafile copy file name=+DATA/SENADB_STB1/DATAFILE/senaamontbs.258.1128704043 RECID=11 STAMP=1149791692

datafile 1 switched to datafile copy
input datafile copy RECID=1 STAMP=1149791691 file name=+DATA/SENADB_STB1/DATAFILE/system.265.1128704045
datafile 2 switched to datafile copy
input datafile copy RECID=2 STAMP=1149791691 file name=+DATA/SENADB_STB1/DATAFILE/senarmantbs.259.1128704045
datafile 3 switched to datafile copy
input datafile copy RECID=3 STAMP=1149791691 file name=+DATA/SENADB_STB1/DATAFILE/sysaux.266.1128704085
datafile 4 switched to datafile copy
input datafile copy RECID=4 STAMP=1149791691 file name=+DATA/SENADB_STB1/DATAFILE/undotbs1.267.1128704085
datafile 5 switched to datafile copy
input datafile copy RECID=5 STAMP=1149791691 file name=+DATA/SENADB_STB1/DATAFILE/senascmtbs.260.1128704045
datafile 7 switched to datafile copy
input datafile copy RECID=6 STAMP=1149791692 file name=+DATA/SENADB_STB1/DATAFILE/users.268.1128704085
datafile 8 switched to datafile copy
input datafile copy RECID=7 STAMP=1149791692 file name=+DATA/SENADB_STB1/DATAFILE/senarangertbs.261.1128704045
datafile 9 switched to datafile copy
input datafile copy RECID=8 STAMP=1149791692 file name=+DATA/SENADB_STB1/DATAFILE/senahuetbs.262.1128704045
datafile 10 switched to datafile copy
input datafile copy RECID=9 STAMP=1149791692 file name=+DATA/SENADB_STB1/DATAFILE/senametatbs.263.1128704045
datafile 11 switched to datafile copy
input datafile copy RECID=10 STAMP=1149791692 file name=+DATA/SENADB_STB1/DATAFILE/senaoozietbs.264.1128704045
datafile 12 switched to datafile copy
input datafile copy RECID=11 STAMP=1149791692 file name=+DATA/SENADB_STB1/DATAFILE/senaamontbs.258.1128704043
Executing: alter database rename file '+DATA/SENADB/ONLINELOG/group_1.272.1128196321' to '+DATA/SENADB_STB1/ONLINELOG/group_1.269.1128705253'
Executing: alter database rename file '+RECO/SENADB/ONLINELOG/group_1.261.1128196323' to '+RECO/SENADB_STB1/ONLINELOG/group_1.259.1128705253'
Executing: alter database rename file '+DATA/SENADB/ONLINELOG/group_2.273.1128196321' to '+DATA/SENADB_STB1/ONLINELOG/group_2.270.1128705253'
Executing: alter database rename file '+RECO/SENADB/ONLINELOG/group_2.262.1128196323' to '+RECO/SENADB_STB1/ONLINELOG/group_2.260.1128705253'
Executing: alter database rename file '+DATA/SENADB/ONLINELOG/group_3.274.1128196321' to '+DATA/SENADB_STB1/ONLINELOG/group_3.271.1128705253'
Executing: alter database rename file '+RECO/SENADB/ONLINELOG/group_3.263.1128196323' to '+RECO/SENADB_STB1/ONLINELOG/group_3.261.1128705253'

contents of Memory Script:
{
  recover database from service  'TNS_SENADB_PR1';
}
executing Memory Script

Starting recover at 09-OCT-23
using channel ORA_DISK_1
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00001: +DATA/SENADB_STB1/DATAFILE/system.265.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:00:16
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00002: +DATA/SENADB_STB1/DATAFILE/senarmantbs.259.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00003: +DATA/SENADB_STB1/DATAFILE/sysaux.266.1128704085
channel ORA_DISK_1: restore complete, elapsed time: 00:01:55
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00004: +DATA/SENADB_STB1/DATAFILE/undotbs1.267.1128704085
channel ORA_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00005: +DATA/SENADB_STB1/DATAFILE/senascmtbs.260.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00007: +DATA/SENADB_STB1/DATAFILE/users.268.1128704085
channel ORA_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00008: +DATA/SENADB_STB1/DATAFILE/senarangertbs.261.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:00:15
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00009: +DATA/SENADB_STB1/DATAFILE/senahuetbs.262.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:00:55
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00010: +DATA/SENADB_STB1/DATAFILE/senametatbs.263.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:05:55
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00011: +DATA/SENADB_STB1/DATAFILE/senaoozietbs.264.1128704045
channel ORA_DISK_1: restore complete, elapsed time: 00:00:02
channel ORA_DISK_1: starting incremental datafile backup set restore
channel ORA_DISK_1: using network backup set from service TNS_SENADB_PR1
destination for restore of datafile 00012: +DATA/SENADB_STB1/DATAFILE/senaamontbs.258.1128704043
channel ORA_DISK_1: restore complete, elapsed time: 00:00:01

starting media recovery

media recovery complete, elapsed time: 00:00:00
Finished recover at 09-OCT-23
Executing: alter system set standby_file_management=auto
Finished recover at 09-OCT-23

RMAN> exit


Recovery Manager complete.

```bash
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
```

Database altered.

SQL> select process, status from v$managed_standby;

PROCESS   STATUS
--------- ------------
ARCH	  CONNECTED
DGRD	  ALLOCATED
DGRD	  ALLOCATED
ARCH	  CONNECTED
ARCH	  CONNECTED
ARCH	  CONNECTED
ARCH	  CONNECTED
ARCH	  CONNECTED
ARCH	  CONNECTED
ARCH	  CONNECTED
RFS	  IDLE

PROCESS   STATUS
--------- ------------
RFS	  IDLE
MRP0	  WAIT_FOR_LOG

13 rows selected.

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0
[oracle@drcsenadbo01 scripts]$ sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Oct 9 18:48:35 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0

SQL> @gap.sql

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
ARCH	  CONNECTED		0
DGRD	  ALLOCATED		0
DGRD	  ALLOCATED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
RFS	  IDLE			0

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
RFS	  IDLE		     2871
MRP0	  WAIT_FOR_LOG	     2871

13 rows selected.


NAME	  DB_UNIQUE_NAME		       DBID LOG_MODE
--------- ------------------------------ ---------- ------------
OPEN_MODE	     DATABASE_ROLE    CURRENT_SCN
-------------------- ---------------- ----------------------------------------
SENADB	  senadb_stb1			 2267153246 ARCHIVELOG
MOUNTED 	     PHYSICAL STANDBY 315470587



    Thread Last Seq Received Last Seq Applied	     Gap Resu
---------- ----------------- ---------------- ---------- ----
	 1		2825		 2870	     -45 Gap

```bash
SQL> @gap.sql
```
### Result after switch log file from side dc

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
ARCH	  CONNECTED		0
DGRD	  ALLOCATED		0
DGRD	  ALLOCATED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
ARCH	  CONNECTED		0
RFS	  IDLE			0

PROCESS   STATUS	SEQUENCE#
--------- ------------ ----------
RFS	  IDLE		     2872
MRP0	  WAIT_FOR_LOG	     2872

13 rows selected.


NAME	  DB_UNIQUE_NAME		       DBID LOG_MODE
--------- ------------------------------ ---------- ------------
OPEN_MODE	     DATABASE_ROLE    CURRENT_SCN
-------------------- ---------------- ----------------------------------------
SENADB	  senadb_stb1			 2267153246 ARCHIVELOG
MOUNTED 	     PHYSICAL STANDBY 315470587



    Thread Last Seq Received Last Seq Applied	     Gap Resu
---------- ----------------- ---------------- ---------- ----
	 1		2871		 2871	       0 Sync

SQL> 





