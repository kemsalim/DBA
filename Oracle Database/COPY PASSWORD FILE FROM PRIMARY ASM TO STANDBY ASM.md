# Password File location on Primary Database:

### Password File location on Primary Database:

```bash
srvctl config database -d orcl
```

### Coping Password File from ASM of Primary Database to Filesystem:

```bash
asmcmd
```
```bash
pwcopy +DATA/ORCL/PASSWORD/pwdorcl.256.1048094823 /tmp/orapwORCL
copying +DATA/ORCL/PASSWORD/pwdorcl.256.1048094823 -> /tmp/orapwORCL
```

### Moving copied password file from Primary database server to Standby:

```bash
[grid@ocmnode1 tmp]$ ls -lrt ora*
-rw-r----- 1 grid oinstall 7680 Aug 17 19:22 orapwORCL
[grid@ocmnode1 tmp]$ scp orapwORCL grid@ocmdrnode1:/tmp/
grid@ocmdrnode1's password:
orapwORCL                                     100% 7680     7.5KB/s   00:00
```

### Copying password file from Filesystem to ASM on Standby Database:

```bash
[oracle@ocmdrnode1 ~]$ su - grid
Password:
[grid@ocmdrnode1 tmp]$ asmcmd
ASMCMD> pwcopy /tmp/orapwORCL +DATA/DRORCL/PASSWORD/pwddrorcl
copying /tmp/orapwORCL -> +DATA/DRORCL/PASSWORD/pwddrorcl
```
```bash
[grid@ocmdrnode1 ~]$ su - oracle
Password:
[oracle@ocmdrnode1 ~]$ srvctl modify database –d ORCL –pwfile +DATA/DRORCL/PASSWORD/pwdorcl
[oracle@ocmdrnode1 ~]$ srvctl config database -d ORCL
Database unique name: ORCL
Database name:
Oracle home: /u01/app/oracle/product/12.1.0/dbhome_2
Oracle user: oracle
Spfile: +DATA/DRORCL/PARAMETERFILE/spfileorcl.ora
Password file: +DATA/DRORCL/PASSWORD/pwddrorcl
Domain:
Start options: mount
Stop options: immediate
Database role: PHYSICAL_STANDBY
Management policy: AUTOMATIC
Server pools:
Disk Groups: OCR,DATA,FRA
Mount point paths:
Services:
Type: RAC
Start concurrency:
Stop concurrency:
OSDBA group: dba
OSOPER group: oper
Database instances: ORCL1,ORCL2
Configured nodes: ocmdrnode1,ocmdrnode2
```

### Validation: Connect both databases (Primary and Standby) using TNS and use same password.

1. TNS – drorcl for Standby Database
2. TNS – orcl for Primary Database

From Primary Database Server (check from all nodes)

```bash
SQL> conn sys@drorcl as sysdba
Enter password:
SQL> Select INSTANCE_NUMBER, INSTANCE_NAME,HOST_NAME from GV$INSTANCE;
INSTANCE_NUMBER INSTANCE_NAME    HOST_NAME
--------------- ---------------- ----------------------------------------------------------------
              1 ORCL1            ocmdrnode1.localdomain
              2 ORCL2            ocmdrnode2.localdomain
SQL> SELECT DB_UNIQUE_NAME, OPEN_MODE, PROTECTION_MODE, DATABASE_ROLE FROM V$DATABASE;
DB_UNIQUE_NAME                 OPEN_MODE            PROTECTION_MODE      DATABASE_ROLE
------------------------------ -------------------- -------------------- ----------------
DRORCL                         MOUNTED              MAXIMUM PERFORMANCE  PHYSICAL STANDBY
```

### From Standby Database Server (check from all nodes)

```bash
SQL> conn sys@orcl as sysdba
Enter password:
Connected.
SQL> set linesize 1000
SQL> Select INSTANCE_NUMBER, INSTANCE_NAME,HOST_NAME from GV$INSTANCE;
INSTANCE_NUMBER INSTANCE_NAME    HOST_NAME
--------------- ---------------- ----------------------------------------------------------------
              2 ORCL2            ocmnode2.localdomain
              1 ORCL1            ocmnode1.localdomain
SQL> SELECT DB_UNIQUE_NAME, OPEN_MODE, PROTECTION_MODE, DATABASE_ROLE FROM V$DATABASE;
DB_UNIQUE_NAME                 OPEN_MODE            PROTECTION_MODE      DATABASE_ROLE
------------------------------ -------------------- -------------------- ----------------
ORCL                           READ WRITE           MAXIMUM PERFORMANCE  PRIMARY
```

#### Note::: If in case copying password file don’t resolve the issue and till getting error on alert log file on Standby database about login denied (ORA-01017: invalid username/password; logon denied) then recreate password file on Primary Database and follow the same procedure as mentioned above.

### Create Password File using ORAPWD: (on Primary)

```bash
# From Oracle User:
orapwd file=/u01/app/oracle/product/12.1.0/dbhome_2/dbs/orapwORCL1 password=oracle ignorecase=y
```


