## ORA-1555 FULL BACKUP DUMP ERROR

#### Info error when trying backup full dump :
![Alt text](image-21.png)
![Alt text](image-22.png)

Indication : 
Long-running transactions: If a transaction spans a long time and other transactions are making changes to the data, the undo information needed for read consistency may have been overwritten.

Small UNDO tablespace: If the UNDO tablespace is too small, it may not be able to retain enough undo information for long-running transactions.

Insufficient undo retention: If the undo retention period is too short, Oracle may not retain the necessary undo information for queries requiring read consistency.

### Solving
```bash
show parameter undo_retention
```
undo_retention  integer  900 -> 3600

```bash
alter system set undo_retention=3600;
### OR
```
```bash
ALTER TABLESPACE UNDOTBS1 ADD DATAFILE '/u01/app/oracle/oradata/orcl/undotbs02.dbf' SIZE 1G AUTOEXTEND ON;
```
