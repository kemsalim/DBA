#!/bin/bash

# ================================================================================================= #
#                           Skrip Pemeliharaan Preventif Oracle Database                            #
#                                    Diuji pada Lingkungan LINUX                                    #
#                              Skrip oleh Emil S MII (Metrodata Group)                              #
# ================================================================================================= #

# Konfigurasi lingkungan Oracle
# source ~/.bash_profile
export PATH=$ORACLE_HOME/bin:$PATH

# Direktori untuk menyimpan laporan
read -p "Masukkan direktori untuk menyimpan laporan: " REPORT_DIR

# Periksa apakah direktori laporan ada
if [ ! -d "$REPORT_DIR" ]; then
  echo "Direktori laporan tidak ditemukan: $REPORT_DIR"
  exit 1
fi

# ================================================================================================= #
# Mengecek status service Oracle dengan srvctl secara otomatis
# ================================================================================================= #

# Ambil db_unique_name dari database
DB_UNIQUE_NAME=$(sqlplus -s / as sysdba <<EOF
SET PAGESIZE 0 FEEDBACK OFF VERIFY OFF HEADING OFF ECHO OFF
SELECT value FROM v\$parameter WHERE name = 'db_unique_name';
EXIT;
EOF
)

# Mendefinisikan nama file output (bisa disesuaikan)
SRVCTL_OUTPUT_FILE="${REPORT_DIR}/srvctl_status_service_$(date +%Y%m%d%H%M).txt"

# Tampilkan status service dan simpan ke file
if [ -n "$DB_UNIQUE_NAME" ]; then
  echo "Menampilkan status service untuk database: $DB_UNIQUE_NAME"
  srvctl status service -d "$DB_UNIQUE_NAME" > "$SRVCTL_OUTPUT_FILE"
  echo "Hasil srvctl telah disimpan di: $SRVCTL_OUTPUT_FILE"
else
  echo "Gagal mendapatkan db_unique_name dari database."
fi



# ================================================================================================= # 
#                      Bagian 0: Inputan Info Database (Primary atau Standby)                       #
# ================================================================================================= #

echo "Apakah Anda bekerja dengan DC atau DRC? (Masukkan DC atau DRC)"
read DC_DRC

if [ "$DC_DRC" == "DC" ]; then
  echo "Database berada di Data Center (DC). Jalankan seluruh skrip untuk DC."
  
# ================================================================================================= # 
#                          Bagian 1: Kode Kondisi Generate AWR Report                               #
# ================================================================================================= #

echo "Pilih metode Snap ID:"
echo "1. Gunakan Snap ID dengan highest DB time (otomatis)"
echo "2. Masukkan Snap ID secara manual"
read -p "Masukkan pilihan Anda (1/2): " SNAP_OPTION

if [ "$SNAP_OPTION" -eq 1 ]; then
  SNAP_IDS=$(sqlplus -s / as sysdba <<EOF
SET HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF
SELECT ASNAPID || ',' || CSNAPID FROM (
  SELECT A.SNAP_ID ASNAPID, C.SNAP_ID CSNAPID, 
         ROUND(TO_NUMBER((C.VALUE-A.VALUE)/1000000/60), 2) DBTIME
  FROM DBA_HIST_SYS_TIME_MODEL A, DBA_HIST_SNAPSHOT B, DBA_HIST_SYS_TIME_MODEL C 
  WHERE A.SNAP_ID=B.SNAP_ID AND C.SNAP_ID=A.SNAP_ID+1 AND A.STAT_NAME=C.STAT_NAME 
        AND UPPER(A.STAT_NAME) LIKE '%DB TIME%' 
        AND B.BEGIN_INTERVAL_TIME > SYSDATE-14 AND B.END_INTERVAL_TIME <= SYSDATE
  ORDER BY TO_NUMBER((C.VALUE-A.VALUE)/1000000/60) DESC
) WHERE ROWNUM=1;
EXIT;
EOF
)

  BEGIN_SNAP_ID=$(echo $SNAP_IDS | cut -d',' -f1)
  END_SNAP_ID=$(echo $SNAP_IDS | cut -d',' -f2)

  echo "Snap ID dengan highest DB time ditemukan:"
  echo "Snap ID awal: $BEGIN_SNAP_ID"
  echo "Snap ID akhir: $END_SNAP_ID"

elif [ "$SNAP_OPTION" -eq 2 ]; then
  echo "Masukkan Snap ID awal:"
  read BEGIN_SNAP_ID
  echo "Masukkan Snap ID akhir:"
  read END_SNAP_ID
else
  echo "Pilihan tidak valid. Proses dihentikan."
  exit 1
fi

# ================================================================================================= # 
#                              Bagian 2: Kode Kondisi RAC / Non RAC                                 #
# ================================================================================================= #

IS_RAC=$(sqlplus -s / as sysdba <<EOF
SET HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF
SELECT COUNT(*) FROM gv\$instance WHERE INST_ID > 1;
EXIT;
EOF
)

if [ "$IS_RAC" -gt 0 ]; then
  echo "Database berjalan dalam mode RAC. Pilih Instance Number:"
  sqlplus -s / as sysdba <<EOF
SET HEADING ON FEEDBACK ON PAGESIZE 100 LINESIZE 200
SELECT INSTANCE_NUMBER, INSTANCE_NAME FROM gv\$instance;
EXIT;
EOF
  read -p "Masukkan Instance Number: " INSTANCE_NUMBER
else
  echo "Database berjalan dalam mode Single Instance."
  INSTANCE_NUMBER=1
fi

# ================================================================================================= # 
#                      Bagian 3: Generate Laporan AWR Menggunakan awrrpt.sql                        #
# ================================================================================================= #

REPORT_FILE="${REPORT_DIR}/awr_report_${BEGIN_SNAP_ID}_${END_SNAP_ID}_instance_${INSTANCE_NUMBER}_$(date +%Y%m%d%H%M).html"

sqlplus -s / as sysdba <<EOF
SET ECHO OFF
@?/rdbms/admin/awrrpt.sql
html
${INSTANCE_NUMBER}
${BEGIN_SNAP_ID}
${END_SNAP_ID}
${REPORT_FILE}
EXIT;
EOF

echo "Laporan AWR telah disimpan di: ${REPORT_FILE}"

# ================================================================================================= # 
#                      Bagian 4: Masuk ke bagian Generate Info DB CDB PDB                           #
# ================================================================================================= #

echo "Menghasilkan laporan Database Info untuk CDB dan PDB..."

# ================================================================================================= # 
#                           Bagian 5: Generate Laporan Database CDB                                 #
# ================================================================================================= #
CDB_REPORT_NAME="${REPORT_DIR}/cdb_info_$(date +%Y%m%d%H%M).html"

sqlplus -s / as sysdba <<EOF > "${CDB_REPORT_NAME}"

SET MARKUP HTML ON
SET PAGESIZE 9999
SET LINESIZE 200
SET FEEDBACK OFF
SET HEADING ON

-- Resource limit
SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;

COL INST_ID FOR 9;
COL RESOURCE_NAME FOR A25;
COL CURRENT_UTILIZATION FOR 9;
COL MAX_UTILIZATION FOR 9;
COL INIT_ALLOC FOR A10;
COL LIMIT_VAL FOR A10;

SELECT /*+ PARALLEL(2) */ 
       RESOURCE_NAME, 
       CURRENT_UTILIZATION AS CUR_UTIL, 
       MAX_UTILIZATION AS MAX_UTIL, 
       INITIAL_ALLOCATION AS INIT_ALLOC, 
       LIMIT_VALUE AS LIMIT_VAL 
FROM GV\$RESOURCE_LIMIT;

--Parameter information
SHOW PARAMETER;

-- Objek Tidak Valid
SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;

-- Menghitung jumlah objek tidak valid
SELECT COUNT(1) AS INV_OBJ 
FROM DBA_OBJECTS 
WHERE STATUS = 'INVALID';

COL OBJ_NAME FOR A60;

-- Menampilkan jenis dan nama objek tidak valid
SELECT /*+ PARALLEL(4) */ 
       OBJECT_TYPE, 
       OWNER || '.' || OBJECT_NAME AS OBJ_NAME 
FROM DBA_OBJECTS 
WHERE STATUS = 'INVALID' 
ORDER BY 2, 1;

 -- Database Information Query
    SET LINES 160 
    PAGES 5000 
    TIMING ON 
    TRIM ON 
    ECHO ON;

    -- Column formatting
    COL HOST_NAME FOR A30;
    COL DB_ROLE FOR A15;
    COL OS FOR A30;
    COL INSTANCE_NAME FOR A10;
    COL DBNAME FOR A10;
    COL LOG_MODE FOR A15;
    COL OPEN_MODE FOR A15;
    COL PLATFORM_NAME FOR A25;
    COL FORCE_LOGGING FOR A3;
    COL STARTUP_TIME FOR A20;
    COL UPTIME FOR A30;

    -- Database Information
    SELECT NAME,
           DB_UNIQUE_NAME,
           DBID,
           CREATED,
           LOG_MODE,
           OPEN_MODE,
           DATABASE_ROLE,
           PLATFORM_NAME,
           FORCE_LOGGING
    FROM V\$DATABASE;

    -- Instance Information with UPTIME
    SELECT INSTANCE_NUMBER,
           INSTANCE_NAME,
           STATUS,
           HOST_NAME,
           TO_CHAR(STARTUP_TIME, 'DD-MON-YYYY HH24:MI:SS') AS STARTUP_TIME,
        -- Calculate and format UPTIME
        FLOOR(SYSDATE - STARTUP_TIME) || ' days ' || 
        TRUNC(MOD((SYSDATE - STARTUP_TIME) * 24, 24)) || ' hours ' || 
        TRUNC(MOD((SYSDATE - STARTUP_TIME) * 24 * 60, 60)) || ' minutes' AS UPTIME,
        VERSION
    FROM GV\$INSTANCE
    ORDER BY 1;

--Database version
SELECT BANNER FROM V\$VERSION;

--Database patches
SELECT 
    ACTION_TIME AS PATCH_DATE, 
    VERSION AS PATCH_VERSION, 
    ACTION AS PATCH_ACTION, 
    BUNDLE_ID, 
    COMMENTS 
FROM 
    REGISTRY$HISTORY
ORDER BY 
    ACTION_TIME DESC;

--Memory information
SHO PARAMETER MEMORY;
SELECT * FROM V\$MEMORY_TARGET_ADVICE ORDER BY 1;
SHO PARAMETER SGA;
SELECT * FROM V\$SGA_TARGET_ADVICE ORDER BY 1;
SHO PARAMETER PGA;
SELECT * FROM V\$PGA_TARGET_ADVICE ORDER BY 1;

-- Informasi Redo Log
COL MEMBER FOR A80;

-- Menampilkan informasi file redo log
SELECT * 
FROM V\$LOGFILE 
ORDER BY 1, 3, 4;

COL STATUS FOR A10;

-- Menampilkan informasi redo log
SELECT GROUP#, 
       THREAD#, 
       SEQUENCE#, 
       ROUND((BYTES / 1024 / 1024), 2) AS REDO_MB, 
       MEMBERS, 
       ARCHIVED, 
       STATUS, 
       FIRST_CHANGE# 
FROM V\$LOG 
ORDER BY 1;

--Tablespace information
SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;
--MB version
SELECT /*+ PARALLEL(4)*/
  DDF.TABLESPACE_NAME, ROUND(DDF.BYTES/1024/1024,2)ALLOCATED_MB, ROUND((DDF.BYTES-DFS.BYTES)/1024/1024,2)USED_MB,
  ROUND(((DDF.BYTES-DFS.BYTES)/DDF.BYTES)*100,2)PERCENT_USED, ROUND(DFS.BYTES/1024/1024,2)FREE_MB, ROUND((1-((DDF.BYTES-DFS.BYTES)/DDF.BYTES))*100,2)PERCENT_FREE
FROM (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME) DDF
JOIN (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME) DFS ON DDF.TABLESPACE_NAME=DFS.TABLESPACE_NAME ORDER BY 4 DESC;
--GB version
COL USED_GB FOR 999999.99;
COL PERCENT_USED FOR 999.99;
COL FREE_GB FOR 999999.99;
COL PERCENT_FREE FOR 999.99;
SELECT /*+ PARALLEL(8)*/
  DDF.TABLESPACE_NAME, ROUND(DDF.BYTES/1024/1024/1024,2)ALLOCATED_GB, ROUND((DDF.BYTES-DFS.BYTES)/1024/1024/1024,2)USED_GB,
  ROUND(((DDF.BYTES-DFS.BYTES)/DDF.BYTES)*100,2)PERCENT_USED, ROUND(DFS.BYTES/1024/1024/1024,2)FREE_GB, ROUND((1-((DDF.BYTES-DFS.BYTES)/DDF.BYTES))*100,2)PERCENT_FREE
FROM (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME) DDF
JOIN (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME) DFS ON DDF.TABLESPACE_NAME=DFS.TABLESPACE_NAME ORDER BY 4 DESC;

-- Comprehensive Tablespace Usage Report
SET LINESIZE 200
SET PAGESIZE 100
SET TIMING ON
COLUMN TABLESPACE_NAME FORMAT A30
COLUMN CURRENT_MB FORMAT 999,999,999.99
COLUMN MAX_MB FORMAT 999,999,999.99
COLUMN USED_MB FORMAT 999,999,999.99
COLUMN FREE_MB FORMAT 999,999,999.99
COLUMN USED_PCT FORMAT 999.99
COLUMN FREE_PCT FORMAT 999.99

WITH 
DATAFILE_INFO AS (
    SELECT 
        TABLESPACE_NAME, 
        SUM(BYTES) AS TOTAL_BYTES,
        SUM(DECODE(AUTOEXTENSIBLE, 'YES', 
            MAXBYTES, 
            BYTES
        )) AS MAX_BYTES
    FROM 
        DBA_DATA_FILES
    GROUP BY 
        TABLESPACE_NAME
),
FREE_SPACE_INFO AS (
    SELECT 
        TABLESPACE_NAME, 
        SUM(NVL(BYTES, 0)) AS FREE_BYTES
    FROM 
        DBA_FREE_SPACE
    GROUP BY 
        TABLESPACE_NAME
)
SELECT 
    DF.TABLESPACE_NAME,
    ROUND(DF.TOTAL_BYTES / 1024 / 1024, 2) AS CURRENT_MB,
    ROUND(DF.MAX_BYTES / 1024 / 1024, 2) AS MAX_MB,
    ROUND((DF.TOTAL_BYTES - NVL(FS.FREE_BYTES, 0)) / 1024 / 1024, 2) AS USED_MB,
    ROUND(NVL(FS.FREE_BYTES, 0) / 1024 / 1024, 2) AS FREE_MB,
    ROUND(100 * (DF.TOTAL_BYTES - NVL(FS.FREE_BYTES, 0)) / DF.TOTAL_BYTES, 2) AS USED_PCT,
    ROUND(100 * NVL(FS.FREE_BYTES, 0) / DF.TOTAL_BYTES, 2) AS FREE_PCT,
    ROUND(100 * (DF.TOTAL_BYTES - NVL(FS.FREE_BYTES, 0)) / DF.MAX_BYTES, 2) AS MAX_USED_PCT
FROM 
    DATAFILE_INFO DF
LEFT JOIN 
    FREE_SPACE_INFO FS ON DF.TABLESPACE_NAME = FS.TABLESPACE_NAME
ORDER BY 
    USED_PCT DESC;

--Datafiles and tempfiles information
SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;
COL TABLESPACE_NAME FOR A20;
COL FILE_ID FOR 9999;
COL FILE_NAME FOR A55;
COL AUTOEXTENSIBLE FOR A3;
COL OL FOR A10;
COL ENABLED FOR A15;
COL STATUS FOR A10;
SELECT /*+ PARALLEL(4)*/ * FROM (
  SELECT /*+ PARALLEL(4)*/ TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VD.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,DDF.STATUS,ONLINE_STATUS OL,VD.ENABLED
  FROM DBA_DATA_FILES DDF JOIN V\$DATAFILE VD ON VD.NAME=DDF.FILE_NAME ORDER BY 1,2)
UNION ALL
SELECT * FROM (
  SELECT /*+ PARALLEL(4)*/ TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VT.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,'',DTF.STATUS OL,VT.ENABLED
  FROM DBA_TEMP_FILES DTF JOIN V\$TEMPFILE VT ON VT.NAME=DTF.FILE_NAME ORDER BY 1,2);

--ASM information
COL PATH FOR A55;
COL NAME FOR A20;
SELECT MOUNT_STATUS,HEADER_STATUS,STATE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,NAME,PATH FROM V\$ASM_DISK ORDER BY NAME;
SELECT NAME,TYPE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,ROUND(USABLE_FILE_MB/1024,2)USABLE_FILE_GB,STATE,SECTOR_SIZE,BLOCK_SIZE FROM V\$ASM_DISKGROUP ORDER BY NAME;
COL ASMDISK FOR A15;
COL DISKGROUP FOR A10;
SELECT DG.NAME DISKGROUP,DG.TYPE,D.NAME ASMDISK,D.PATH,ROUND(D.TOTAL_MB/1024,2)TOTAL_GB,ROUND(D.FREE_MB/1024,2)FREE_GB,D.VOTING_FILE,DG.SECTOR_SIZE,DG.BLOCK_SIZE FROM V\$ASM_DISKGROUP DG JOIN V\$ASM_DISK D ON DG.GROUP_NUMBER=D.GROUP_NUMBER ORDER BY 3;

--ASM volume
COL VOLUME_NAME FOR A10;
COL USAGE FOR A10;
COL MOUNTPATH FOR A35;
COL VOLUME_DEVICE FOR A30;
SELECT GROUP_NUMBER,VOLUME_NAME,ROUND(SIZE_MB/1024,2)SIZE_GB,VOLUME_NUMBER,REDUNDANCY,STATE,FILE_NUMBER,USAGE,VOLUME_DEVICE,MOUNTPATH FROM V\$ASM_VOLUME;

--Database size
SELECT /*+ PARALLEL(4)*/ROUND((SUM(BYTES))/1024/1024/1024, 2)DBSIZE_GB,ROUND((SUM(BYTES))/1024/1024/1024/1024, 2)DBSIZE_TB FROM DBA_DATA_FILES;

--Total database size
SELECT /*+ PARALLEL(4)*/ 'Datafiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)DATAFILES_GB FROM DBA_DATA_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Tempfiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)TEMPFILES_GB FROM DBA_TEMP_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Redo Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$LOG UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Stby Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$STANDBY_LOG UNION ALL
SELECT 'TOTAL' "COMPONENT", SUM(DATAFILES_GB)TOTAL_GB FROM(
SELECT /*+ PARALLEL(4)*/ 'Datafiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)DATAFILES_GB FROM DBA_DATA_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Tempfiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)TEMPFILES_GB FROM DBA_TEMP_FILES UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Redo Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$LOG UNION ALL
SELECT /*+ PARALLEL(4)*/ 'Stby Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$STANDBY_LOG);

--Analyzed table
COL OWNER FOR A25;
SELECT OWNER, SUM(DECODE(NVL(NUM_ROWS,9999), 9999,0,1)) ANALYZED, SUM(DECODE(NVL(NUM_ROWS,9999), 9999,1,0)) NOT_ANALYZED,COUNT(TABLE_NAME) TOTAL FROM DBA_TABLES GROUP BY OWNER ORDER BY 1;

--Buffer hit ratio
SELECT SUM(DECODE(NAME, 'consistent gets',VALUE, 0)) Consistent_Gets, SUM(DECODE(NAME, 'db block gets',VALUE, 0)) DB_Blk_Gets, SUM(DECODE(NAME, 'physical reads',VALUE, 0))Physical_Reads,
ROUND(
  (SUM(DECODE(NAME, 'consistent gets',value, 0)) + SUM(DECODE(NAME, 'db block gets',value, 0)) - SUM(DECODE(NAME, 'physical reads',value, 0))) /
  (SUM(DECODE(NAME, 'consistent gets',value, 0)) + SUM(DECODE(NAME, 'db block gets',value, 0))) * 100,2
) HIT_RATIO FROM V\$SYSSTAT;

--Library cache hit ratio
SELECT SUM(PINS) Executions, SUM(PINHITS) Execution_Hits, ROUND((SUM(PINHITS) / SUM(PINS)) * 100,3) Hit_Ratio, SUM(RELOADS) Misses, ROUND((SUM(PINS) / (SUM(PINS) + sum(RELOADS))) * 100,3) Hit_Ratio FROM V\$LIBRARYCACHE;

--Data dictionary hit ratio
SELECT SUM(GETS) Gets, SUM(GETMISSES) Cache_Misses, ROUND((1 - (SUM(GETMISSES) / sum(GETS))) * 100,2) Hit_Ratio FROM V\$ROWCACHE;

--User's tablespace
SET LINES 160 PAGES 5000 TIMING ON;
COL USERNAME FOR A25;
COL ACCOUNT_STATUS FOR A20;
SELECT USERNAME, ACCOUNT_STATUS, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE TEMP_TBS FROM DBA_USERS ORDER BY 1;

--Redo log history
COL "00" FOR A4;
COL "01" FOR A4;
COL "02" FOR A4;
COL "03" FOR A4;
COL "04" FOR A4;
COL "05" FOR A4;
COL "06" FOR A4;
COL "07" FOR A4;
COL "08" FOR A4;
COL "09" FOR A4;
COL "10" FOR A4;
COL "11" FOR A4;
COL "12" FOR A4;
COL "13" FOR A4;
COL "14" FOR A4;
COL "15" FOR A4;
COL "16" FOR A4;
COL "17" FOR A4;
COL "18" FOR A4;
COL "19" FOR A4;
COL "20" FOR A4;
COL "21" FOR A4;
COL "22" FOR A4;
COL "23" FOR A4;
--SELECT SUBSTR(TO_CHAR(FIRST_TIME,'DY, YYYY/MM/DD'),1,15) DAY,
SELECT TO_DATE(SUBSTR(TO_CHAR(FIRST_TIME,'DD-Mon-YYYY'),1,15),'DD-Mon-YYYY') DAY,
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0))) AS "00",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0))) AS "01",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0))) AS "02",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0))) AS "03",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0))) AS "04",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0))) AS "05",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0))) AS "06",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0))) AS "07",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0))) AS "08",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0))) AS "09",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0))) AS "10",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0))) AS "11",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0))) AS "12",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0))) AS "13",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0))) AS "14",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0))) AS "15",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0))) AS "16",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0))) AS "17",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0))) AS "18",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0))) AS "19",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0))) AS "20",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0))) AS "21",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0))) AS "22",
decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0))) AS "23"
FROM V\$LOG_HISTORY /*GROUP BY SUBSTR(TO_CHAR(FIRST_TIME,'DY, YYYY/MM/DD'),1,15)*/ GROUP BY TO_DATE(SUBSTR(TO_CHAR(FIRST_TIME,'DD-Mon-YYYY'),1,15),'DD-Mon-YYYY') ORDER BY 1 DESC;

--RMAN backup jobs
SELECT 
    R.COMMAND_ID,
    R.TIME_TAKEN_DISPLAY,
    R.INPUT_TYPE,
    R.STATUS,
    R.OUTPUT_DEVICE_TYPE,
    R.INPUT_BYTES_DISPLAY,
    R.OUTPUT_BYTES_DISPLAY
FROM 
    (SELECT 
        COMMAND_ID,
        TIME_TAKEN_DISPLAY,
        STATUS,
        INPUT_TYPE,
        OUTPUT_DEVICE_TYPE,
        INPUT_BYTES_DISPLAY,
        OUTPUT_BYTES_DISPLAY
    FROM 
        V\$RMAN_BACKUP_JOB_DETAILS
    ORDER BY 
        START_TIME DESC) R
WHERE 
    ROWNUM < 32;

--Check block corruption
SELECT * FROM V\$DATABASE_BLOCK_CORRUPTION;

set lines 200 pages 1000
select THREAD#,SEQUENCE#,ARCHIVED,APPLIED,STATUS,COMPLETION_TIME from V\$archived_log
where trunc(COMPLETION_TIME)>=trunc(sysdate-1)
order by 1,2,3;
select name,database_role from gV\$database;
select instance_name,status from gV\$instance;

SELECT ARCH.THREAD# "Thread", ARCH.SEQUENCE# "Last Sequence Received", APPL.SEQUENCE# "Last Sequence Applied",
(ARCH.SEQUENCE# - APPL.SEQUENCE#) "Difference"
FROM (SELECT THREAD# ,SEQUENCE# FROM V\$ARCHIVED_LOG WHERE (THREAD#,FIRST_TIME )
IN (SELECT THREAD#,MAX(FIRST_TIME) FROM V\$ARCHIVED_LOG GROUP BY THREAD#)) ARCH,
(SELECT THREAD# ,SEQUENCE# FROM V\$LOG_HISTORY WHERE (THREAD#,FIRST_TIME ) IN
(SELECT THREAD#,MAX(FIRST_TIME) FROM V\$LOG_HISTORY GROUP BY THREAD#)) APPL
WHERE ARCH.THREAD# = APPL.THREAD#;

SET LINES 250 PAGES 5000 TIMING ON TRIM ON;
--Check DB information
COL PLATFORM_NAME FOR A30;
COL DB_UNIQUE_NAME FOR A15;
COL CURRENT_SCN FOR A20;
COL HOST_NAME FOR A30;
SELECT NAME,DB_UNIQUE_NAME,INSTANCE_NAME,DBID,HOST_NAME,PLATFORM_NAME,OPEN_MODE,STATUS,LOG_MODE,DATABASE_ROLE,TO_CHAR(CURRENT_SCN)CURRENT_SCN FROM V\$DATABASE X,V\$INSTANCE Y;

--Check gap on standby DB with gap
SELECT /*Check gap on stby with difference*/ al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied", almax-lhmax "Gap", decode(almax-lhmax, 0, 'Sync', 'Gap') "Result"
FROM (select thread# thrd, MAX(sequence#) almax FROM V\$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM V\$database) GROUP BY thread#) al,
(SELECT thread# thrd, MAX(sequence#) lhmax FROM V\$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM V\$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

--Check proses standby
SELECT PROCESS,STATUS,SEQUENCE#,INST_ID FROM GV\$MANAGED_STANDBY ORDER BY 1,3,2;

--Check FRA
set pages 50 lines 50
col name format a15
SELECT name
,    ceil( space_limit / 1024 / 1024) SIZE_M
,    ceil( space_used  / 1024 / 1024) USED_M
,    decode( nvl( space_used, 0),
		    0, 0
			    , ceil ( ( space_used / space_limit) * 100) ) PCT_USED
		FROM v\$recovery_file_dest
		ORDER BY name;

EXIT;
EOF

echo "Laporan CDB telah disimpan di: ${CDB_REPORT_NAME}"

# ================================================================================================= # 
#                           Bagian 6: Generate Laporan Database PDB                                 #
# ================================================================================================= #
PDB_LIST=$(sqlplus -s / as sysdba <<EOF
SET HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF
SELECT NAME FROM V\$PDBS WHERE OPEN_MODE = 'READ WRITE';
EXIT;
EOF
)

# Periksa apakah PDB_LIST kosong
if [ -z "$PDB_LIST" ]; then
  echo "Tidak ada PDB yang ditemukan. Melewati pembuatan laporan untuk PDB."
else
  for PDB in $PDB_LIST; do
    echo "Menghasilkan laporan untuk PDB: $PDB..."
    
    PDB_REPORT_NAME="${REPORT_DIR}/${PDB}_info_$(date +%Y%m%d%H%M).html"

    sqlplus -s / as sysdba <<EOF > "${PDB_REPORT_NAME}"
    -- Beralih ke PDB yang sesuai
    ALTER SESSION SET CONTAINER = $PDB;
    
    SET MARKUP HTML ON
    SET PAGESIZE 9999
    SET LINESIZE 200
    SET FEEDBACK OFF
    SET HEADING ON

    -- Resource limit
    SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;

    COL INST_ID FOR 9;
    COL RESOURCE_NAME FOR A25;
    COL CURRENT_UTILIZATION FOR 9;
    COL MAX_UTILIZATION FOR 9;
    COL INIT_ALLOC FOR A10;
    COL LIMIT_VAL FOR A10;

    SELECT /*+ PARALLEL(2) */ 
          RESOURCE_NAME, 
          CURRENT_UTILIZATION AS CUR_UTIL, 
          MAX_UTILIZATION AS MAX_UTIL, 
          INITIAL_ALLOCATION AS INIT_ALLOC, 
          LIMIT_VALUE AS LIMIT_VAL 
    FROM GV\$RESOURCE_LIMIT;

    --Parameter information
    SHOW PARAMETER;

    -- Objek Tidak Valid
    SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;

    -- Menghitung jumlah objek tidak valid
    SELECT COUNT(1) AS INV_OBJ 
    FROM DBA_OBJECTS 
    WHERE STATUS = 'INVALID';

    COL OBJ_NAME FOR A60;

    -- Menampilkan jenis dan nama objek tidak valid
    SELECT /*+ PARALLEL(4) */ 
          OBJECT_TYPE, 
          OWNER || '.' || OBJECT_NAME AS OBJ_NAME 
    FROM DBA_OBJECTS 
    WHERE STATUS = 'INVALID' 
    ORDER BY 2, 1;

    -- Database Information Query
    SET LINES 160 
    PAGES 5000 
    TIMING ON 
    TRIM ON 
    ECHO ON;

    -- Column formatting
    COL HOST_NAME FOR A30;
    COL DB_ROLE FOR A15;
    COL OS FOR A30;
    COL INSTANCE_NAME FOR A10;
    COL DBNAME FOR A10;
    COL LOG_MODE FOR A15;
    COL OPEN_MODE FOR A15;
    COL PLATFORM_NAME FOR A25;
    COL FORCE_LOGGING FOR A3;
    COL STARTUP_TIME FOR A20;
    COL UPTIME FOR A30;

    -- Database Information
    SELECT NAME,
           DB_UNIQUE_NAME,
           DBID,
           CREATED,
           LOG_MODE,
           OPEN_MODE,
           DATABASE_ROLE,
           PLATFORM_NAME,
           FORCE_LOGGING
    FROM V\$DATABASE;

    -- Instance Information with UPTIME
    SELECT INSTANCE_NUMBER,
           INSTANCE_NAME,
           STATUS,
           HOST_NAME,
           TO_CHAR(STARTUP_TIME, 'DD-MON-YYYY HH24:MI:SS') AS STARTUP_TIME,
        -- Calculate and format UPTIME
        FLOOR(SYSDATE - STARTUP_TIME) || ' days ' || 
        TRUNC(MOD((SYSDATE - STARTUP_TIME) * 24, 24)) || ' hours ' || 
        TRUNC(MOD((SYSDATE - STARTUP_TIME) * 24 * 60, 60)) || ' minutes' AS UPTIME,
        VERSION
    FROM GV\$INSTANCE
    ORDER BY 1;

    --Database version
    SELECT BANNER FROM V\$VERSION;

    --Database patches
    SELECT 
        ACTION_TIME AS PATCH_DATE, 
        VERSION AS PATCH_VERSION, 
        ACTION AS PATCH_ACTION, 
        BUNDLE_ID, 
        COMMENTS 
    FROM 
        REGISTRY$HISTORY
    ORDER BY 
        ACTION_TIME DESC;

    --Memory information
    SHO PARAMETER MEMORY;
    SELECT * FROM V\$MEMORY_TARGET_ADVICE ORDER BY 1;
    SHO PARAMETER SGA;
    SELECT * FROM V\$SGA_TARGET_ADVICE ORDER BY 1;
    SHO PARAMETER PGA;
    SELECT * FROM V\$PGA_TARGET_ADVICE ORDER BY 1;

    -- Informasi Redo Log
    COL MEMBER FOR A80;

    -- Menampilkan informasi file redo log
    SELECT * 
    FROM V\$LOGFILE 
    ORDER BY 1, 3, 4;

    COL STATUS FOR A10;

    -- Menampilkan informasi redo log
    SELECT GROUP#, 
          THREAD#, 
          SEQUENCE#, 
          ROUND((BYTES / 1024 / 1024), 2) AS REDO_MB, 
          MEMBERS, 
          ARCHIVED, 
          STATUS, 
          FIRST_CHANGE# 
    FROM V\$LOG 
    ORDER BY 1;

    --Tablespace information
    SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;
    --MB version
    SELECT /*+ PARALLEL(4)*/
      DDF.TABLESPACE_NAME, ROUND(DDF.BYTES/1024/1024,2)ALLOCATED_MB, ROUND((DDF.BYTES-DFS.BYTES)/1024/1024,2)USED_MB,
      ROUND(((DDF.BYTES-DFS.BYTES)/DDF.BYTES)*100,2)PERCENT_USED, ROUND(DFS.BYTES/1024/1024,2)FREE_MB, ROUND((1-((DDF.BYTES-DFS.BYTES)/DDF.BYTES))*100,2)PERCENT_FREE
    FROM (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME) DDF
    JOIN (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME) DFS ON DDF.TABLESPACE_NAME=DFS.TABLESPACE_NAME ORDER BY 4 DESC;
    --GB version
    COL USED_GB FOR 999999.99;
    COL PERCENT_USED FOR 999.99;
    COL FREE_GB FOR 999999.99;
    COL PERCENT_FREE FOR 999.99;
    SELECT /*+ PARALLEL(8)*/
      DDF.TABLESPACE_NAME, ROUND(DDF.BYTES/1024/1024/1024,2)ALLOCATED_GB, ROUND((DDF.BYTES-DFS.BYTES)/1024/1024/1024,2)USED_GB,
      ROUND(((DDF.BYTES-DFS.BYTES)/DDF.BYTES)*100,2)PERCENT_USED, ROUND(DFS.BYTES/1024/1024/1024,2)FREE_GB, ROUND((1-((DDF.BYTES-DFS.BYTES)/DDF.BYTES))*100,2)PERCENT_FREE
    FROM (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_DATA_FILES GROUP BY TABLESPACE_NAME) DDF
    JOIN (SELECT TABLESPACE_NAME,SUM(BYTES) BYTES FROM DBA_FREE_SPACE GROUP BY TABLESPACE_NAME) DFS ON DDF.TABLESPACE_NAME=DFS.TABLESPACE_NAME ORDER BY 4 DESC;

    -- Comprehensive Tablespace Usage Report
    SET LINESIZE 200
    SET PAGESIZE 100
    SET TIMING ON
    COLUMN TABLESPACE_NAME FORMAT A30
    COLUMN CURRENT_MB FORMAT 999,999,999.99
    COLUMN MAX_MB FORMAT 999,999,999.99
    COLUMN USED_MB FORMAT 999,999,999.99
    COLUMN FREE_MB FORMAT 999,999,999.99
    COLUMN USED_PCT FORMAT 999.99
    COLUMN FREE_PCT FORMAT 999.99

    WITH 
    DATAFILE_INFO AS (
        SELECT 
            TABLESPACE_NAME, 
            SUM(BYTES) AS TOTAL_BYTES,
            SUM(DECODE(AUTOEXTENSIBLE, 'YES', 
                MAXBYTES, 
                BYTES
            )) AS MAX_BYTES
        FROM 
            DBA_DATA_FILES
        GROUP BY 
            TABLESPACE_NAME
    ),
    FREE_SPACE_INFO AS (
        SELECT 
            TABLESPACE_NAME, 
            SUM(NVL(BYTES, 0)) AS FREE_BYTES
        FROM 
            DBA_FREE_SPACE
        GROUP BY 
            TABLESPACE_NAME
    )
    SELECT 
        DF.TABLESPACE_NAME,
        ROUND(DF.TOTAL_BYTES / 1024 / 1024, 2) AS CURRENT_MB,
        ROUND(DF.MAX_BYTES / 1024 / 1024, 2) AS MAX_MB,
        ROUND((DF.TOTAL_BYTES - NVL(FS.FREE_BYTES, 0)) / 1024 / 1024, 2) AS USED_MB,
        ROUND(NVL(FS.FREE_BYTES, 0) / 1024 / 1024, 2) AS FREE_MB,
        ROUND(100 * (DF.TOTAL_BYTES - NVL(FS.FREE_BYTES, 0)) / DF.TOTAL_BYTES, 2) AS USED_PCT,
        ROUND(100 * NVL(FS.FREE_BYTES, 0) / DF.TOTAL_BYTES, 2) AS FREE_PCT,
        ROUND(100 * (DF.TOTAL_BYTES - NVL(FS.FREE_BYTES, 0)) / DF.MAX_BYTES, 2) AS MAX_USED_PCT
    FROM 
        DATAFILE_INFO DF
    LEFT JOIN 
        FREE_SPACE_INFO FS ON DF.TABLESPACE_NAME = FS.TABLESPACE_NAME
    ORDER BY 
        USED_PCT DESC;

    --Datafiles and tempfiles information
    SET LINES 160 PAGES 5000 TIMING ON TRIM ON ECHO ON;
    COL TABLESPACE_NAME FOR A20;
    COL FILE_ID FOR 9999;
    COL FILE_NAME FOR A55;
    COL AUTOEXTENSIBLE FOR A3;
    COL OL FOR A10;
    COL ENABLED FOR A15;
    COL STATUS FOR A10;
    SELECT /*+ PARALLEL(4)*/ * FROM (
      SELECT /*+ PARALLEL(4)*/ TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VD.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,DDF.STATUS,ONLINE_STATUS OL,VD.ENABLED
      FROM DBA_DATA_FILES DDF JOIN V\$DATAFILE VD ON VD.NAME=DDF.FILE_NAME ORDER BY 1,2)
    UNION ALL
    SELECT * FROM (
      SELECT /*+ PARALLEL(4)*/ TABLESPACE_NAME,FILE_ID,FILE_NAME,ROUND(VT.BYTES/1024/1024/1024,2)SIZE_GB,ROUND(MAXBYTES/1024/1024/1024,2)MAX_GB,AUTOEXTENSIBLE,'',DTF.STATUS OL,VT.ENABLED
      FROM DBA_TEMP_FILES DTF JOIN V\$TEMPFILE VT ON VT.NAME=DTF.FILE_NAME ORDER BY 1,2);

    --ASM information
    COL PATH FOR A55;
    COL NAME FOR A20;
    SELECT MOUNT_STATUS,HEADER_STATUS,STATE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,NAME,PATH FROM V\$ASM_DISK ORDER BY NAME;
    SELECT NAME,TYPE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,ROUND(USABLE_FILE_MB/1024,2)USABLE_FILE_GB,STATE,SECTOR_SIZE,BLOCK_SIZE FROM V\$ASM_DISKGROUP ORDER BY NAME;
    COL ASMDISK FOR A15;
    COL DISKGROUP FOR A10;
    SELECT DG.NAME DISKGROUP,DG.TYPE,D.NAME ASMDISK,D.PATH,ROUND(D.TOTAL_MB/1024,2)TOTAL_GB,ROUND(D.FREE_MB/1024,2)FREE_GB,D.VOTING_FILE,DG.SECTOR_SIZE,DG.BLOCK_SIZE FROM V\$ASM_DISKGROUP DG JOIN V\$ASM_DISK D ON DG.GROUP_NUMBER=D.GROUP_NUMBER ORDER BY 3;

    --ASM volume
    COL VOLUME_NAME FOR A10;
    COL USAGE FOR A10;
    COL MOUNTPATH FOR A35;
    COL VOLUME_DEVICE FOR A30;
    SELECT GROUP_NUMBER,VOLUME_NAME,ROUND(SIZE_MB/1024,2)SIZE_GB,VOLUME_NUMBER,REDUNDANCY,STATE,FILE_NUMBER,USAGE,VOLUME_DEVICE,MOUNTPATH FROM V\$ASM_VOLUME;

    --Database size
    SELECT /*+ PARALLEL(4)*/ROUND((SUM(BYTES))/1024/1024/1024, 2)DBSIZE_GB,ROUND((SUM(BYTES))/1024/1024/1024/1024, 2)DBSIZE_TB FROM DBA_DATA_FILES;

    --Total database size
    SELECT /*+ PARALLEL(4)*/ 'Datafiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)DATAFILES_GB FROM DBA_DATA_FILES UNION ALL
    SELECT /*+ PARALLEL(4)*/ 'Tempfiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)TEMPFILES_GB FROM DBA_TEMP_FILES UNION ALL
    SELECT /*+ PARALLEL(4)*/ 'Redo Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$LOG UNION ALL
    SELECT /*+ PARALLEL(4)*/ 'Stby Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$STANDBY_LOG UNION ALL
    SELECT 'TOTAL' "COMPONENT", SUM(DATAFILES_GB)TOTAL_GB FROM(
    SELECT /*+ PARALLEL(4)*/ 'Datafiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)DATAFILES_GB FROM DBA_DATA_FILES UNION ALL
    SELECT /*+ PARALLEL(4)*/ 'Tempfiles' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)TEMPFILES_GB FROM DBA_TEMP_FILES UNION ALL
    SELECT /*+ PARALLEL(4)*/ 'Redo Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$LOG UNION ALL
    SELECT /*+ PARALLEL(4)*/ 'Stby Logs' "COMPONENTS", ROUND((SUM(BYTES))/1024/1024/1024, 2)REDO_GB FROM V\$STANDBY_LOG);

    --Analyzed table
    COL OWNER FOR A25;
    SELECT OWNER, SUM(DECODE(NVL(NUM_ROWS,9999), 9999,0,1)) ANALYZED, SUM(DECODE(NVL(NUM_ROWS,9999), 9999,1,0)) NOT_ANALYZED,COUNT(TABLE_NAME) TOTAL FROM DBA_TABLES GROUP BY OWNER ORDER BY 1;

    --Buffer hit ratio
    SELECT SUM(DECODE(NAME, 'consistent gets',VALUE, 0)) Consistent_Gets, SUM(DECODE(NAME, 'db block gets',VALUE, 0)) DB_Blk_Gets, SUM(DECODE(NAME, 'physical reads',VALUE, 0))Physical_Reads,
    ROUND(
      (SUM(DECODE(NAME, 'consistent gets',value, 0)) + SUM(DECODE(NAME, 'db block gets',value, 0)) - SUM(DECODE(NAME, 'physical reads',value, 0))) /
      (SUM(DECODE(NAME, 'consistent gets',value, 0)) + SUM(DECODE(NAME, 'db block gets',value, 0))) * 100,2
    ) HIT_RATIO FROM V\$SYSSTAT;

    --Library cache hit ratio
    SELECT SUM(PINS) Executions, SUM(PINHITS) Execution_Hits, ROUND((SUM(PINHITS) / SUM(PINS)) * 100,3) Hit_Ratio, SUM(RELOADS) Misses, ROUND((SUM(PINS) / (SUM(PINS) + sum(RELOADS))) * 100,3) Hit_Ratio FROM V\$LIBRARYCACHE;

    --Data dictionary hit ratio
    SELECT SUM(GETS) Gets, SUM(GETMISSES) Cache_Misses, ROUND((1 - (SUM(GETMISSES) / sum(GETS))) * 100,2) Hit_Ratio FROM V\$ROWCACHE;

    --User's tablespace
    SET LINES 160 PAGES 5000 TIMING ON;
    COL USERNAME FOR A25;
    COL ACCOUNT_STATUS FOR A20;
    SELECT USERNAME, ACCOUNT_STATUS, DEFAULT_TABLESPACE, TEMPORARY_TABLESPACE TEMP_TBS FROM DBA_USERS ORDER BY 1;

    --Redo log history
    COL "00" FOR A4;
    COL "01" FOR A4;
    COL "02" FOR A4;
    COL "03" FOR A4;
    COL "04" FOR A4;
    COL "05" FOR A4;
    COL "06" FOR A4;
    COL "07" FOR A4;
    COL "08" FOR A4;
    COL "09" FOR A4;
    COL "10" FOR A4;
    COL "11" FOR A4;
    COL "12" FOR A4;
    COL "13" FOR A4;
    COL "14" FOR A4;
    COL "15" FOR A4;
    COL "16" FOR A4;
    COL "17" FOR A4;
    COL "18" FOR A4;
    COL "19" FOR A4;
    COL "20" FOR A4;
    COL "21" FOR A4;
    COL "22" FOR A4;
    COL "23" FOR A4;
    --SELECT SUBSTR(TO_CHAR(FIRST_TIME,'DY, YYYY/MM/DD'),1,15) DAY,
    SELECT TO_DATE(SUBSTR(TO_CHAR(FIRST_TIME,'DD-Mon-YYYY'),1,15),'DD-Mon-YYYY') DAY,
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'00',1,0))) AS "00",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'01',1,0))) AS "01",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'02',1,0))) AS "02",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'03',1,0))) AS "03",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'04',1,0))) AS "04",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'05',1,0))) AS "05",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'06',1,0))) AS "06",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'07',1,0))) AS "07",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'08',1,0))) AS "08",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'09',1,0))) AS "09",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'10',1,0))) AS "10",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'11',1,0))) AS "11",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'12',1,0))) AS "12",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'13',1,0))) AS "13",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'14',1,0))) AS "14",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'15',1,0))) AS "15",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'16',1,0))) AS "16",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'17',1,0))) AS "17",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'18',1,0))) AS "18",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'19',1,0))) AS "19",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'20',1,0))) AS "20",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'21',1,0))) AS "21",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'22',1,0))) AS "22",
    decode(sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0)),0,'-',sum(decode(substr(to_char(FIRST_TIME,'HH24'),1,2),'23',1,0))) AS "23"
    FROM V\$LOG_HISTORY /*GROUP BY SUBSTR(TO_CHAR(FIRST_TIME,'DY, YYYY/MM/DD'),1,15)*/ GROUP BY TO_DATE(SUBSTR(TO_CHAR(FIRST_TIME,'DD-Mon-YYYY'),1,15),'DD-Mon-YYYY') ORDER BY 1 DESC;

    --RMAN backup jobs
    SELECT R.COMMAND_ID, R.START_TIME, R.TIME_TAKEN_DISPLAY, R.INPUT_TYPE, R.STATUS, R.OUTPUT_DEVICE_TYPE, R.INPUT_BYTES_DISPLAY, R.OUTPUT_BYTES_DISPLAY, R.OUTPUT_BYTES_PER_SEC_DISPLAY
    FROM (SELECT COMMAND_ID, START_TIME, TIME_TAKEN_DISPLAY, STATUS, INPUT_TYPE, OUTPUT_DEVICE_TYPE, INPUT_BYTES_DISPLAY, OUTPUT_BYTES_DISPLAY, OUTPUT_BYTES_PER_SEC_DISPLAY FROM V\$RMAN_BACKUP_JOB_DETAILS ORDER BY START_TIME DESC) R WHERE ROWNUM < 32;

    --Check block corruption
    SELECT * FROM V\$DATABASE_BLOCK_CORRUPTION;
    EXIT;
EOF

    echo "Laporan untuk PDB $PDB telah disimpan di: $PDB_REPORT_NAME"
  done
fi

elif [ "$DC_DRC" == "DRC" ]; then
  echo "Database berada di Data Recovery Center (DRC). Jalankan skrip tambahan untuk DRC."

  # ================================================================================================= # 
  #                                 Kode Tambahan untuk Standby                                       #
  # ================================================================================================= #

  # Menyaring log yang relevan dari database standby
  STANDBY_REPORT_NAME="${REPORT_DIR}/standby_info_$(date +%Y%m%d%H%M).html"

  sqlplus -s / as sysdba <<EOF > "${STANDBY_REPORT_NAME}"
  SET MARKUP HTML ON
  SET PAGESIZE 9999
  SET LINESIZE 200
  SET FEEDBACK OFF
  SET HEADING ON

   -- Database Information Query
    SET LINES 160 
    PAGES 5000 
    TIMING ON 
    TRIM ON 
    ECHO ON;

    -- Column formatting
    COL HOST_NAME FOR A30;
    COL DB_ROLE FOR A15;
    COL OS FOR A30;
    COL INSTANCE_NAME FOR A10;
    COL DBNAME FOR A10;
    COL LOG_MODE FOR A15;
    COL OPEN_MODE FOR A15;
    COL PLATFORM_NAME FOR A25;
    COL FORCE_LOGGING FOR A3;
    COL STARTUP_TIME FOR A20;
    COL UPTIME FOR A30;

    -- Database Information
    SELECT NAME,
           DB_UNIQUE_NAME,
           DBID,
           CREATED,
           LOG_MODE,
           OPEN_MODE,
           DATABASE_ROLE,
           PLATFORM_NAME,
           FORCE_LOGGING
    FROM V\$DATABASE;

    -- Instance Information with UPTIME
    SELECT INSTANCE_NUMBER,
           INSTANCE_NAME,
           STATUS,
           HOST_NAME,
           TO_CHAR(STARTUP_TIME, 'DD-MON-YYYY HH24:MI:SS') AS STARTUP_TIME,
        -- Calculate and format UPTIME
        FLOOR(SYSDATE - STARTUP_TIME) || ' days ' || 
        TRUNC(MOD((SYSDATE - STARTUP_TIME) * 24, 24)) || ' hours ' || 
        TRUNC(MOD((SYSDATE - STARTUP_TIME) * 24 * 60, 60)) || ' minutes' AS UPTIME,
        VERSION
    FROM GV\$INSTANCE
    ORDER BY 1;

  -- Check gap on standby DB
  SELECT /*Check gap on stby with difference*/ al.thrd "Thread", almax "Last Seq Received", lhmax "Last Seq Applied", almax-lhmax "Gap", decode(almax-lhmax, 0, 'Sync', 'Gap') "Result"
  FROM (select thread# thrd, MAX(sequence#) almax FROM V\$archived_log WHERE resetlogs_change#=(SELECT resetlogs_change# FROM V\$database) GROUP BY thread#) al,
  (SELECT thread# thrd, MAX(sequence#) lhmax FROM V\$log_history WHERE resetlogs_change#=(SELECT resetlogs_change# FROM V\$database) GROUP BY thread#) lh WHERE al.thrd = lh.thrd;

  -- Check proses standby
  SELECT PROCESS,STATUS,SEQUENCE#,INST_ID FROM GV\$MANAGED_STANDBY ORDER BY 1,3,2;

  --Check FRA
  set pages 50 lines 50
  col name format a15
  SELECT name
  ,    ceil( space_limit / 1024 / 1024) SIZE_M
  ,    ceil( space_used  / 1024 / 1024) USED_M
  ,    decode( nvl( space_used, 0),
          0, 0
            , ceil ( ( space_used / space_limit) * 100) ) PCT_USED
      FROM v\$recovery_file_dest
      ORDER BY name;

  --ASM information
    COL PATH FOR A55;
    COL NAME FOR A20;
    SELECT MOUNT_STATUS,HEADER_STATUS,STATE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,NAME,PATH FROM V\$ASM_DISK ORDER BY NAME;
    SELECT NAME,TYPE,ROUND(TOTAL_MB/1024,2)TOTAL_GB,ROUND(FREE_MB/1024,2)FREE_GB,ROUND(USABLE_FILE_MB/1024,2)USABLE_FILE_GB,STATE,SECTOR_SIZE,BLOCK_SIZE FROM V\$ASM_DISKGROUP ORDER BY NAME;
    COL ASMDISK FOR A15;
    COL DISKGROUP FOR A10;
    SELECT DG.NAME DISKGROUP,DG.TYPE,D.NAME ASMDISK,D.PATH,ROUND(D.TOTAL_MB/1024,2)TOTAL_GB,ROUND(D.FREE_MB/1024,2)FREE_GB,D.VOTING_FILE,DG.SECTOR_SIZE,DG.BLOCK_SIZE FROM V\$ASM_DISKGROUP DG JOIN V\$ASM_DISK D ON DG.GROUP_NUMBER=D.GROUP_NUMBER ORDER BY 3;

  --ASM volume
    COL VOLUME_NAME FOR A10;
    COL USAGE FOR A10;
    COL MOUNTPATH FOR A35;
    COL VOLUME_DEVICE FOR A30;
    SELECT GROUP_NUMBER,VOLUME_NAME,ROUND(SIZE_MB/1024,2)SIZE_GB,VOLUME_NUMBER,REDUNDANCY,STATE,FILE_NUMBER,USAGE,VOLUME_DEVICE,MOUNTPATH FROM V\$ASM_VOLUME;

  EXIT;
EOF

  echo "Laporan Standby telah disimpan di: ${STANDBY_REPORT_NAME}"

else
  echo "Gagal mengidentifikasi role database. Proses dihentikan."
  exit 1
fi

# ================================================================================================= # 
#                           Bagian 7: Generate Laporan Info OS                                      #
# ================================================================================================= #

# Ambil direktori alert log secara otomatis dari database
ALERT_DIR=$(sqlplus -s / as sysdba <<EOF
SET HEADING OFF FEEDBACK OFF VERIFY OFF ECHO OFF
SELECT VALUE FROM V\$DIAG_INFO WHERE NAME = 'Diag Trace';
EXIT;
EOF
)

# Bersihkan spasi/enter
ALERT_DIR=$(echo "$ALERT_DIR" | xargs)

# # Meminta pengguna untuk memasukkan direktori alert
# read -p "Masukkan direktori alert: " ALERT_DIR

# # Mendefinisikan path ke file alert log
# ALERT_LOG="${ALERT_DIR}/alert_${ORACLE_SID}.log"

# Set nama file alert log sesuai ORACLE_SID
ALERT_LOG="${ALERT_DIR}/alert_${ORACLE_SID}.log"

# Meminta pengguna untuk memasukkan direktori bin GRID 
read -p "Masukkan direktori Clusterware Status: " CRSCTL_DIR

# # Meminta pengguna untuk memasukkan direktori output
# read -p "Masukkan direktori output untuk laporan: " OUTPUT_DIR

# Mendefinisikan nama file output berdasarkan direktori yang diberikan pengguna
OUTPUT_ALERT_LOG="${REPORT_DIR}/output_ora_errors.log"
OUTPUT_SYSTEM_INFO="${REPORT_DIR}/system_info.log"
OUTPUT_LAST_LINES="${REPORT_DIR}/last_10000_lines_alert_log.txt"

# Mendefinisikan tanggal 1 bulan yang lalu
DATE_THRESHOLD=$(date --date="1 month ago" +"%b %d %Y")

# Periksa apakah file alert log ada
if [ ! -f "$ALERT_LOG" ]; then
  echo "File alert log tidak ditemukan di $ALERT_LOG"
  exit 1
fi

# Filter log berdasarkan tanggal dan pola "ORA-"
awk -v date_threshold="$DATE_THRESHOLD" '
BEGIN { show = 0 }
/^[A-Za-z]{3} [ 0-9]{2} [0-9]{4}/ {
  current_date = $0;
  if (current_date >= date_threshold) {
    show = 1;
  } else {
    show = 0;
  }
}
show && /ORA-/ { print }
' "$ALERT_LOG" > "$OUTPUT_ALERT_LOG"

echo "Log error ORA- dalam periode satu bulan terakhir telah disimpan di $OUTPUT_ALERT_LOG"

# Ekstraksi 10.000 baris terakhir dari alert log
tail -10000 "$ALERT_LOG" > "$OUTPUT_LAST_LINES"
echo "10.000 baris terakhir dari alert log telah disimpan di $OUTPUT_LAST_LINES"

# Kumpulkan informasi sistem dan simpan ke file keluaran terpisah
{
  hostname
  hostnamectl
  date
  uptime
  uname -a
  lsb_release -a || cat /etc/os-release
  lscpu
  df -h
  df -g || df -BG
  lsblk
  lsmem || free -h
  vmstat 2 5
  iostat || echo "iostat command not found"
  sar -u 1 10 || echo "sar command not found"
  free -mt; free -gt
  env | grep ORA || echo "No ORA environment variables found."
  ps -ef | grep pmon | grep -v grep
  ps -ef | grep tns | grep -v grep
  lsnrctl status || echo "Listener not running or command not found."
  cat /etc/hosts
  ifconfig -a || ip addr show
  cat /proc/meminfo | grep MemTotal
  cat /proc/meminfo | grep SwapTotal
  cat /proc/cpuinfo | grep "model name" | uniq
  cat /proc/cpuinfo | grep "model name" | wc -l | awk '{print $1, "CPU(s)"}'
  "${CRSCTL_DIR}/crsctl" status res -t
} > "$OUTPUT_SYSTEM_INFO"

echo "Informasi sistem telah disimpan di $OUTPUT_SYSTEM_INFO"

# Selesai
echo "Proses selesai."
echo "Semua laporan terkait Database telah selesai dibuat."


