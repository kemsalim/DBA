# How to restart ODG

1. Cek Listener 
```bash
lsnrctl status
```

2. Cek Service PMON dan Oracle SID
```bash
ps -ef | grep pmon
echo $ORACLE_SID
```

3. Cek Status DB
```bash
SELECT name, open_mode from v$database;
```

4. Check Instance Status 
```bash
SELECT instance_name, status from v$instance;
```

5. Cek Gap
```bash
ALTER SYSTEM SWITCH LOGFILE;
CEK GAP QUERY @
```


6. Backup PFILE
```bash
create pfile=‘direktori/pfile_backup.ora’ from spfile;
```

7. Shutdown DRC
```bash
SELECT process, status from v$managed_standby;
ALTER DATABASE RECOVER MANAGED STANDBY DATABASE CANCEL;
shut immediate;
```

8. Stop Log Ship
```bash
ALTER SYSTEM SET log_archive_dest_state_2=‘DEFER’;

// if with restart DC then
shut immediate;
```

9. Start DC
```bash
startup;
ALTER SYSTEM SET log_archive_dest_state_2=‘ENABLE’;
```

10. Start DRC
```bash
startup nomount;
alter database mount standby database;

ALTER DATABASE RECOVER MANAGED STANDBY DATABASE DISCONNECT FROM SESSION;
select process, status from v$managed_standby;
```

## Then
```bash
alter system switch logfile; 2x (di dc)

// CEK GAP @
```



