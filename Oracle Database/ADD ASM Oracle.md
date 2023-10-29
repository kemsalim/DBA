# Restart ODG and MOP How To Add ASM

| No  | Activities  | Host | 
| -------- | -------- | -------- | 
| 1 | Check ASM_DISK dan ASM_DISKGROUP Information | DC / DRC | 
## Step 1
```bash
su - grid 
sqlplus / as sysasm

set lines 500 pages 500
SELECT g.name,
       sum(b.total_mb) total_mb,
       sum((b.total_mb - b.free_mb)) used_mb,
       sum(B.FREE_MB) free_mb,
       decode(sum(b.total_mb),0,0,(ROUND((1- (sum(b.free_mb) / sum(b.total_mb)))*100, 2))) pct_used,
       decode(sum(b.total_mb),0,0,(ROUND(((sum(b.free_mb) / sum(b.total_mb)))*100, 2))) pct_free
FROM
     v$asm_disk b,v$asm_diskgroup g
where b.group_number = g.group_number (+)
group by g.name
order by 1;

set lines 500 pages 500
col diskgroup for a15
col type for a15
col failgroup for a18
col asmdisk for a20
col path for a30
SELECT dg.name diskgroup,dg.type,d.failgroup, d.name asmdisk,d.path,round(d.total_mb/1024,2)total_gb,round(d.free_mb/1024,2)free_gb 
FROM v$asm_diskgroup dg join v$asm_disk d on dg.group_number=d.group_number order by 4;```