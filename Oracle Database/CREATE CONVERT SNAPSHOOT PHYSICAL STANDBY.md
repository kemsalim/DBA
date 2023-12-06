## Converting a Physical Standby Database into a Snapshot Standby Database

### Perform the following steps to convert a physical standby database into a snapshot standby database:

#### Step 1 : login as sysdba

```bash
$ sqlplus / as sysdba
```

#### Step 2 : Check the database mode --> must be flashback_on = YES
```bash
SQL> select log_mode,flashback_on from v$database;

LOG_MODE     FLASHBACK_ON
------------ ------------------
ARCHIVELOG   YES

if flashback_on = NO must be changes,

SQL > ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
SQL > ALTER DATABASE FLASHBACK ON;
```

#### Step 3 : Check the recovery parameter
```bash
SQL> show parameter db_recover
NAME                                 TYPE        VALUE
------------------------------------ ----------- ----------------------------
db_recovery_file_dest                string      /u05/fast_recovery_area
db_recovery_file_dest_size           big integer 20G
```

#### Step 4 : Change the recovery parameter if necessary
```bash
SQL> alter system set db_recovery_file_dest='/u05/fast_recovery_area';
SQL> alter system set db_recovery_file_dest_size=20480M;
```

#### Step 5 : Stop the archivelog synchronization
```bash
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;	

On Database Primary.
SQL> alter system set log_archive_dest_state_2=defer;	
```

#### Step 6 : shutdown the standby db and mount it , if status database open read only
```bash
SQL> SHUTDOWN IMMEDIATE;
SQL> STARTUP MOUNT; 

if RAC 

$ srvctl stop database -d OPCITTBS
$ srvctl start database -d OPCITTBS -o mount
```

#### Step 7 : Issue the following SQL statement to perform the conversion
```bash
SQL> ALTER DATABASE CONVERT TO SNAPSHOT STANDBY;

Step 8 : Bounce the standby DB
SQL> SHUTDOWN IMMEDIATE;
SQL> STARTUP;

if RAC

$ srvctl stop database -d OPCITTBS
$ srvctl start database -d OPCITTBS
```

#### Step 9 : Confirm the database mode and inform the application team, that the DB is ready to use for testing purpose
```bash
SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from v$database;
NAME OPEN_MODE DATABASE_ROLE
-------------------------------------- ---------- ---------------------------
ORCL READ WRITE SNAPSHOT STANDBY

```





## Converting a Snapshot Standby Database into a Physical Standby Database

### Perform the following steps to convert a snapshot standby database into a physical standby database:

#### Step 1: Check for current database role
```bash
SQL> Select DB_UNIQUE_NAME, OPEN_MODE, DATABASE_ROLE from v$database;
NAME OPEN_MODE DATABASE_ROLE
-------------------------------------- ---------- ---------------------------
ORCL READ WRITE SNAPSHOT STANDBY
```

#### Step 2 : shutdown the snapshot standby db and mount it
```bash
SQL> SHUTDOWN IMMEDIATE;
SQL> STARTUP MOUNT; 

If RAC

$ srvctl stop database -d OPCITTBS
$ srvctl start database -d OPCITTBS -o mount
```
#### Step 3 : Do the conversion of snapshot standby database to physical standby database.
```bash
SQL> ALTER DATABASE CONVERT TO PHYSICAL STANDBY;

Step 4 : Shutdown the DB and start the instance;
SQL> SHUTDOWN IMMEDIATE;

if RAC

$ srvctl stop database -d OPCITTBS
```
#### Step 5 : Mount the database
```bash
SQL> STARTUP NOMOUNT
SQL> ALTER DATABASE MOUNT STANDBY DATABASE;

IF RAC

$ srvctl start database -d OPCITTBS -o mount
```
#### Step 6 : Open the standby database in read only mode
```bash
SQL> ALTER DATABASE OPEN READ ONLY;
```
##### On Database Primary.
```bash
SQL> alter system set log_archive_dest_state_2=enable;	
```

#### Step 7 : Activate the MRP on standby database
```bash
SQL> ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
```

## With Broker
```bash
DGMGRL> show configuration;

Configuration - DELL

  Protection Mode: MaxPerformance
  Databases:
    DELL    - Primary database
    DELL_DG - Physical standby database <----

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS
```
```bash
DGMGRL>


DGMGRL> CONVERT DATABASE "DELL_DG" TO SNAPSHOT STANDBY;
Converting database "DELL_DG" to a Snapshot Standby database, please wait...
Database "DELL_DG" converted successfully
DGMGRL>

DGMGRL> show configuration;

Configuration - DELL

  Protection Mode: MaxPerformance
  Databases:
    DELL    - Primary database
    DELL_DG - Snapshot standby database <----

Fast-Start Failover: DISABLED

Configuration Status:
SUCCESS

DGMGRL>
```