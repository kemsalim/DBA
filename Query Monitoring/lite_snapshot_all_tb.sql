

define reportHeader="<font size=+3 color=darkgreen><b>Preventive Maintenance 11<i>g</i> Version 1.1</b></font><hr>Copyright (c) Sisindokom "


-- +----------------------------------------------------------------------------+
-- |                           SCRIPT SETTINGS                                  |
-- +----------------------------------------------------------------------------+

set termout       off
set echo          off
set feedback      off
set heading       off
set verify        off
set wrap          on
set trimspool     on
set serveroutput  on
set escape        on

set pagesize 50000
set linesize 175
set long     2000000000

clear buffer computes columns breaks screen

define fileName=lite_snapshot
define versionNumber=4.7


-- +----------------------------------------------------------------------------+
-- |                   GATHER DATABASE REPORT INFORMATION                       |
-- +----------------------------------------------------------------------------+

COLUMN tdate NEW_VALUE _date NOPRINT
SELECT TO_CHAR(SYSDATE,'MM/DD/YYYY') tdate FROM dual;

COLUMN time NEW_VALUE _time NOPRINT
SELECT TO_CHAR(SYSDATE,'HH24:MI:SS') time FROM dual;

COLUMN date_time NEW_VALUE _date_time NOPRINT
SELECT TO_CHAR(SYSDATE,'MM/DD/YYYY HH24:MI:SS') date_time FROM dual;

COLUMN date_time_timezone NEW_VALUE _date_time_timezone NOPRINT
SELECT TO_CHAR(systimestamp, 'Mon DD, YYYY (') || TRIM(TO_CHAR(systimestamp, 'Day')) || TO_CHAR(systimestamp, ') "at" HH:MI:SS AM') || TO_CHAR(systimestamp, ' "in Timezone" TZR') date_time_timezone
FROM dual;

COLUMN spool_time NEW_VALUE _spool_time NOPRINT
SELECT TO_CHAR(SYSDATE,'YYYYMMDD') spool_time FROM dual;

COLUMN dbname NEW_VALUE _dbname NOPRINT
SELECT name dbname FROM v$database;

COLUMN dbid NEW_VALUE _dbid NOPRINT
SELECT dbid dbid FROM v$database;

COLUMN platform_id NEW_VALUE _platform_id NOPRINT
SELECT platform_id platform_id FROM v$database;

COLUMN platform_name NEW_VALUE _platform_name NOPRINT
SELECT platform_name platform_name FROM v$database;

COLUMN global_name NEW_VALUE _global_name NOPRINT
SELECT global_name global_name FROM global_name;

COLUMN blocksize NEW_VALUE _blocksize NOPRINT
SELECT value blocksize FROM v$parameter WHERE name='db_block_size';

COLUMN startup_time NEW_VALUE _startup_time NOPRINT
SELECT TO_CHAR(startup_time, 'MM/DD/YYYY HH24:MI:SS') startup_time FROM v$instance;

COLUMN host_name NEW_VALUE _host_name NOPRINT
SELECT host_name host_name FROM v$instance;

COLUMN instance_name NEW_VALUE _instance_name NOPRINT
SELECT instance_name instance_name FROM v$instance;

COLUMN instance_number NEW_VALUE _instance_number NOPRINT
SELECT instance_number instance_number FROM v$instance;

COLUMN thread_number NEW_VALUE _thread_number NOPRINT
SELECT thread# thread_number FROM v$instance;

COLUMN cluster_database NEW_VALUE _cluster_database NOPRINT
SELECT value cluster_database FROM v$parameter WHERE name='cluster_database';

COLUMN cluster_database_instances NEW_VALUE _cluster_database_instances NOPRINT
SELECT value cluster_database_instances FROM v$parameter WHERE name='cluster_database_instances';

COLUMN reportRunUser NEW_VALUE _reportRunUser NOPRINT
SELECT user reportRunUser FROM dual;



-- +----------------------------------------------------------------------------+
-- |                   GATHER DATABASE REPORT INFORMATION                       |
-- +----------------------------------------------------------------------------+

set heading on

set markup html on spool on preformat off entmap on -
head ' -
  <title>Database Report</title> -
  <style type="text/css"> -
    body              {font:9pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    p                 {font:9pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    table,tr,td       {font:9pt Arial,Helvetica,sans-serif; color:Black; background:#FFFFFF; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} -
    th                {font:bold 9pt Arial,Helvetica,sans-serif; color:#336699; background:#FFFFFF; padding:0px 0px 0px 0px;} -
    h1                {font:bold 12pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #FFFFFF; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
    h2                {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;} -
    a                 {font:9pt Arial,Helvetica,sans-serif; color:#663300; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.link            {font:9pt Arial,Helvetica,sans-serif; color:#663300; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLink          {font:9pt Arial,Helvetica,sans-serif; color:#663300; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkBlue      {font:9pt Arial,Helvetica,sans-serif; color:#0000ff; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkDarkBlue  {font:9pt Arial,Helvetica,sans-serif; color:#000099; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkRed       {font:9pt Arial,Helvetica,sans-serif; color:#ff0000; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkDarkRed   {font:9pt Arial,Helvetica,sans-serif; color:#990000; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkGreen     {font:9pt Arial,Helvetica,sans-serif; color:#00ff00; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
    a.noLinkDarkGreen {font:9pt Arial,Helvetica,sans-serif; color:#009900; text-decoration: none; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
  </style>' -
body   'BGCOLOR="#FFFFFF"' -
table  'WIDTH="90%" BORDER="1"' 

spool &FileName._&_dbname._&_spool_time..html

set markup html on entmap off

prompt <a name=top></a>
prompt &reportHeader
prompt <br></br>
prompt <br></br>
prompt <br></br>

-- +----------------------------------------------------------------------------+
-- |                            - REPORT HEADER -                               |
-- +----------------------------------------------------------------------------+


prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Report Header</b></font><hr align="left" width="460">

prompt <table width="90%" border="1"> -
<tr><th align="left" width="20%">Report Name</th><td width="80%"><tt>&FileName._&_dbname._&_spool_time..html</tt></td></tr> -
<tr><th align="left" width="20%">Snapshot Database Version</th><td width="80%"><tt>&versionNumber</tt></td></tr> -
<tr><th align="left" width="20%">Run Date / Time / Timezone</th><td width="80%"><tt>&_date_time_timezone</tt></td></tr> -
<tr><th align="left" width="20%">Host Name</th><td width="80%"><tt>&_host_name</tt></td></tr> -
<tr><th align="left" width="20%">Database Name</th><td width="80%"><tt>&_dbname</tt></td></tr> -
<tr><th align="left" width="20%">Database ID</th><td width="80%"><tt>&_dbid</tt></td></tr> -
<tr><th align="left" width="20%">Global Database Name</th><td width="80%"><tt>&_global_name</tt></td></tr> -
<tr><th align="left" width="20%">Platform Name / ID</th><td width="80%"><tt>&_platform_name / &_platform_id</tt></td></tr> -
<tr><th align="left" width="20%">Clustered Database?</th><td width="80%"><tt>&_cluster_database</tt></td></tr> -
<tr><th align="left" width="20%">Clustered Database Instances</th><td width="80%"><tt>&_cluster_database_instances</tt></td></tr> -
<tr><th align="left" width="20%">Instance Name</th><td width="80%"><tt>&_instance_name</tt></td></tr> -
<tr><th align="left" width="20%">Instance Number</th><td width="80%"><tt>&_instance_number</tt></td></tr> -
<tr><th align="left" width="20%">Thread Number</th><td width="80%"><tt>&_thread_number</tt></td></tr> -
<tr><th align="left" width="20%">Database Startup Time</th><td width="80%"><tt>&_startup_time</tt></td></tr> -
<tr><th align="left" width="20%">Database Block Size</th><td width="80%"><tt>&_blocksize</tt></td></tr> -
<tr><th align="left" width="20%">Report Run User</th><td width="80%"><tt>&_reportRunUser</tt></td></tr> -
</table>

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>




-- SET TIMING ON




-- +----------------------------------------------------------------------------+
-- |                                 - VERSION -                                |
-- +----------------------------------------------------------------------------+


prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Version</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN banner   FORMAT a120   HEADING 'Banner'

SELECT * FROM v$version;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

-- +----------------------------------------------------------------------------+
-- |                            - DATA FILES -                                  |
-- +----------------------------------------------------------------------------+


prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Data Files</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN tablespace                                   HEADING 'Tablespace Name / File Class'  ENTMAP off
COLUMN filename                                     HEADING 'Filename'                      ENTMAP off
COLUMN filesize        FORMAT 999,999,999,999,999   HEADING 'File Size'                     ENTMAP off
COLUMN autoextensible                               HEADING 'Autoextensible'                ENTMAP off
COLUMN increment_by    FORMAT 999,999,999           HEADING 'Next'                          ENTMAP off
COLUMN maxbytes        FORMAT 999,999,999,999,999   HEADING 'Max'                           ENTMAP off

BREAK ON report
COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF filesize ON report

SELECT /*+ ordered */
    '<font color="#336699"><b>' || d.tablespace_name  || '</b></font>'  tablespace
  , '<tt>' || d.file_name || '</tt>'                                    filename
  , d.bytes                                                             filesize
  , '<div align="center">' || NVL(d.autoextensible, '<br>') || '</div>' autoextensible
  , d.increment_by * e.value                                            increment_by
  , d.maxbytes                                                          maxbytes
FROM
    sys.dba_data_files d
  , v$datafile v
  , (SELECT value
     FROM v$parameter 
     WHERE name = 'db_block_size') e
WHERE
  (d.file_name = v.name)
UNION
SELECT
    '<font color="#336699"><b>' || d.tablespace_name || '</b></font>'   tablespace 
  , '<tt>' || d.file_name  || '</tt>'                                   filename
  , d.bytes                                                             filesize
  , '<div align="center">' || NVL(d.autoextensible, '<br>') || '</div>' autoextensible
  , d.increment_by * e.value                                            increment_by
  , d.maxbytes                                                          maxbytes
FROM
    sys.dba_temp_files d
  , (SELECT value
     FROM v$parameter 
     WHERE name = 'db_block_size') e
UNION
SELECT
    '<font color="#336699"><b>[ ONLINE REDO LOG ]</b></font>'
  , '<tt>' || a.member || '</tt>'
  , b.bytes
  , null
  , null
  , null
FROM
    v$logfile a
  , v$log b
WHERE
    a.group# = b.group#
UNION
SELECT
    '<font color="#336699"><b>[ CONTROL FILE    ]</b></font>'
  , '<tt>' || a.name || '</tt>'
  , null
  , null
  , null
  , null
FROM
    v$controlfile a
ORDER BY
    1
  , 2;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                            - TABLESPACES -                                 |
-- +----------------------------------------------------------------------------+


prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Tablespaces</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN status                                  HEADING 'Status'            ENTMAP off
COLUMN name                                    HEADING 'Tablespace Name'   ENTMAP off
COLUMN type        FORMAT a12                  HEADING 'TS Type'           ENTMAP off
COLUMN extent_mgt  FORMAT a10                  HEADING 'Ext. Mgt.'         ENTMAP off
COLUMN segment_mgt FORMAT a9                   HEADING 'Seg. Mgt.'         ENTMAP off
COLUMN ts_size     FORMAT 999,999,999,999,999  HEADING 'Tablespace Size'   ENTMAP off
COLUMN free        FORMAT 999,999,999,999,999  HEADING 'Free (in bytes)'   ENTMAP off
COLUMN used        FORMAT 999,999,999,999,999  HEADING 'Used (in bytes)'   ENTMAP off
COLUMN pct_used                                HEADING 'Pct. Used'         ENTMAP off

BREAK ON report
COMPUTE SUM label '<font color="#990000"><b>Total:</b></font>'   OF ts_size used free ON report

SELECT
    DECODE(   d.status
            , 'OFFLINE'
            , '<div align="center"><b><font color="#990000">'   || d.status || '</font></b></div>'
            , '<div align="center"><b><font color="darkgreen">' || d.status || '</font></b></div>') status
  , '<b><font color="#336699">' || d.tablespace_name || '</font></b>'                               name
  , d.contents                                          type
  , d.extent_management                                 extent_mgt
  , d.segment_space_management                          segment_mgt
  , NVL(a.bytes, 0)                                     ts_size
  , NVL(f.bytes, 0)                                     free
  , NVL(a.bytes - NVL(f.bytes, 0), 0)                   used
  , '<div align="right"><b>' || 
          DECODE (
              (1-SIGN(1-SIGN(TRUNC(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0)) - 90)))
            , 1
            , '<font color="#990000">'   || TO_CHAR(TRUNC(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0))) || '</font>'
            , '<font color="darkgreen">' || TO_CHAR(TRUNC(NVL((a.bytes - NVL(f.bytes, 0)) / a.bytes * 100, 0))) || '</font>'
          )
    || '</b> %</div>' pct_used
FROM 
    sys.dba_tablespaces d
  , ( select tablespace_name, sum(bytes) bytes
      from dba_data_files
      group by tablespace_name
    ) a
  , ( select tablespace_name, sum(bytes) bytes
      from dba_free_space
      group by tablespace_name
    ) f
WHERE
      d.tablespace_name = a.tablespace_name(+)
  AND d.tablespace_name = f.tablespace_name(+)
  AND NOT (
    d.extent_management like 'LOCAL'
    AND
    d.contents like 'TEMPORARY'
  )
UNION ALL 
SELECT
    DECODE(   d.status
            , 'OFFLINE'
            , '<div align="center"><b><font color="#990000">'   || d.status || '</font></b></div>'
            , '<div align="center"><b><font color="darkgreen">' || d.status || '</font></b></div>') status
  , '<b><font color="#336699">' || d.tablespace_name  || '</font></b>'                              name
  , d.contents                                   type
  , d.extent_management                          extent_mgt
  , d.segment_space_management                   segment_mgt
  , NVL(a.bytes, 0)                              ts_size
  , NVL(a.bytes - NVL(t.bytes,0), 0)             free
  , NVL(t.bytes, 0)                              used
  , '<div align="right"><b>' || 
          DECODE (
              (1-SIGN(1-SIGN(TRUNC(NVL(t.bytes / a.bytes * 100, 0)) - 90)))
            , 1
            , '<font color="#990000">'   || TO_CHAR(TRUNC(NVL(t.bytes / a.bytes * 100, 0))) || '</font>'
            , '<font color="darkgreen">' || TO_CHAR(TRUNC(NVL(t.bytes / a.bytes * 100, 0))) || '</font>'
          )
    || '</b> %</div>' pct_used
FROM
    sys.dba_tablespaces d
  , ( select tablespace_name, sum(bytes) bytes
      from dba_temp_files
      group by tablespace_name
    ) a
  , ( select tablespace_name, sum(bytes_cached) bytes
      from v$temp_extent_pool
      group by tablespace_name
    ) t
WHERE
      d.tablespace_name = a.tablespace_name(+)
  AND d.tablespace_name = t.tablespace_name(+)
  AND d.extent_management like 'LOCAL'
  AND d.contents like 'TEMPORARY'
ORDER BY 2;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

-- +----------------------------------------------------------------------------+
-- |                          - DATABASE GROWTH -                               |
-- +----------------------------------------------------------------------------+


prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Database Growth</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN month        FORMAT a75                  HEADING 'Month'
COLUMN growth       FORMAT 999,999,999,999,999  HEADING 'Growth (Megabytes)'

BREAK ON report
COMPUTE SUM label '<font color="#990000"><b>Total:</b></font>' OF growth ON report

SELECT
    '<div align="left"><font color="#336699"><b>' || TO_CHAR(creation_time, 'RRRR-MM') || '</b></font></div>' month
  , SUM(bytes)/1024/1024                        growth
FROM     sys.v_$datafile
GROUP BY TO_CHAR(creation_time, 'RRRR-MM')
ORDER BY TO_CHAR(creation_time, 'RRRR-MM');

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

-- +----------------------------------------------------------------------------+
-- |                          - CURRENT SESSIONS -                              |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Current Sessions</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN instance_name_print  FORMAT a45    HEADING 'Instance Name'              ENTMAP off
COLUMN thread_number_print  FORMAT a45    HEADING 'Thread Number'              ENTMAP off
COLUMN count                FORMAT a45    HEADING 'Current No. of Processes'   ENTMAP off
COLUMN value                FORMAT a45    HEADING 'Max No. of Processes'       ENTMAP off
COLUMN pct_usage            FORMAT a45    HEADING '% Usage'                    ENTMAP off

SELECT
    '<div align="center"><font color="#336699"><b>' || a.instance_name  || '</b></font></div>'  instance_name_print
  , '<div align="center">' || a.thread#             || '</div>'  thread_number_print
  , '<div align="center">' || TO_CHAR(a.count)      || '</div>'  count
  , '<div align="center">' || b.value               || '</div>'  value
  , '<div align="center">' || TO_CHAR(ROUND(100*(a.count / b.value), 2)) || '%</div>'  pct_usage
FROM
    (select   count(*) count, a1.inst_id, a2.instance_name, a2.thread#
     from     gv$session a1
            , gv$instance a2
     where    a1.inst_id = a2.inst_id
     group by a1.inst_id
            , a2.instance_name
            , a2.thread#) a
  , (select value, inst_id from gv$parameter where name='processes') b
WHERE
    a.inst_id = b.inst_id
ORDER BY
    a.instance_name;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>




-- +----------------------------------------------------------------------------+
-- |                        - USER SESSION MATRIX -                             |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>User Session Matrix</b></font><hr align="left" width="460">

prompt <b>User sessions (excluding SYS and background processes)</b>

CLEAR COLUMNS BREAKS COMPUTES

COLUMN instance_name_print  FORMAT a75               HEADING 'Instance Name'            ENTMAP off
COLUMN thread_number_print  FORMAT a75               HEADING 'Thread Number'            ENTMAP off
COLUMN username             FORMAT a79               HEADING 'Oracle User'              ENTMAP off
COLUMN num_user_sess        FORMAT 999,999,999,999   HEADING 'Total Number of Logins'   ENTMAP off
COLUMN count_a              FORMAT 999,999,999       HEADING 'Active Logins'            ENTMAP off
COLUMN count_i              FORMAT 999,999,999       HEADING 'Inactive Logins'          ENTMAP off
COLUMN count_k              FORMAT 999,999,999       HEADING 'Killed Logins'            ENTMAP off

BREAK ON report ON instance_name_print ON thread_number_print

SELECT
    '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'                      instance_name_print
  , '<div align="center"><font color="#336699"><b>' || i.thread#       || '</b></font></div>'                      thread_number_print
  , '<div align="left"><font color="#000000">' || NVL(sess.username, '[B.G. Process]') || '</font></div>' username
  , count(*)              num_user_sess
  , NVL(act.count, 0)     count_a
  , NVL(inact.count, 0)   count_i
  , NVL(killed.count, 0)  count_k
FROM 
    gv$session                        sess
  , gv$instance                       i
  , (SELECT    count(*) count, NVL(username, '[B.G. Process]') username, inst_id
     FROM      gv$session
     WHERE     status = 'ACTIVE'
     GROUP BY  username, inst_id)              act
  , (SELECT    count(*) count, NVL(username, '[B.G. Process]') username, inst_id
     FROM      gv$session
     WHERE     status = 'INACTIVE'
     GROUP BY  username, inst_id)              inact
  , (SELECT    count(*) count, NVL(username, '[B.G. Process]') username, inst_id
     FROM      gv$session
     WHERE     status = 'KILLED'
     GROUP BY  username, inst_id)              killed
WHERE
         sess.inst_id                         = i.inst_id
     AND (
           NVL(sess.username, '[B.G. Process]') = act.username (+)
           AND
           sess.inst_id  = act.inst_id (+)
         )
     AND (
           NVL(sess.username, '[B.G. Process]') = inact.username (+)
           AND
           sess.inst_id  = inact.inst_id (+)
         )
     AND (
           NVL(sess.username, '[B.G. Process]') = killed.username (+)
           AND
           sess.inst_id  = killed.inst_id (+)
         )
     AND sess.username NOT IN ('SYS')
GROUP BY
    i.instance_name
  , i.thread#
  , sess.username
  , act.count
  , inact.count
  , killed.count
ORDER BY
    i.instance_name
  , i.thread#
  , sess.username;


prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>



-- +----------------------------------------------------------------------------+
-- |                         - FILE I/O STATISTICS -                            |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>File I/O Statistics</b></font><hr align="left" width="460">

prompt <b>Ordered by "Physical Reads" since last startup of the Oracle instance</b>

CLEAR COLUMNS BREAKS COMPUTES

COLUMN tablespace_name   FORMAT a50                   HEAD 'Tablespace'       ENTMAP off
COLUMN fname                                          HEAD 'File Name'        ENTMAP off
COLUMN phyrds            FORMAT 999,999,999,999,999   HEAD 'Physical Reads'   ENTMAP off
COLUMN phywrts           FORMAT 999,999,999,999,999   HEAD 'Physical Writes'  ENTMAP off
COLUMN read_pct                                       HEAD 'Read Pct.'        ENTMAP off
COLUMN write_pct                                      HEAD 'Write Pct.'       ENTMAP off
COLUMN total_io          FORMAT 999,999,999,999,999   HEAD 'Total I/O'        ENTMAP off

BREAK ON report
COMPUTE sum LABEL '<font color="#990000"><b>Total: </b></font>' OF phyrds phywrts total_io ON report

SELECT
    '<font color="#336699"><b>' || df.tablespace_name || '</b></font>'                      tablespace_name
  , df.file_name                             fname
  , fs.phyrds                                phyrds
  , '<div align="right">' || ROUND((fs.phyrds * 100) / (fst.pr + tst.pr), 2) || '%</div>'   read_pct
  , fs.phywrts                               phywrts
  , '<div align="right">' || ROUND((fs.phywrts * 100) / (fst.pw + tst.pw), 2) || '%</div>'   write_pct
  , (fs.phyrds + fs.phywrts)                 total_io
FROM
    sys.dba_data_files df
  , v$filestat         fs
  , (select sum(f.phyrds) pr, sum(f.phywrts) pw from v$filestat f) fst
  , (select sum(t.phyrds) pr, sum(t.phywrts) pw from v$tempstat t) tst
WHERE
    df.file_id = fs.file#
UNION
SELECT
    '<font color="#336699"><b>' || tf.tablespace_name || '</b></font>'                     tablespace_name
  , tf.file_name                           fname
  , ts.phyrds                              phyrds
  , '<div align="right">' || ROUND((ts.phyrds * 100) / (fst.pr + tst.pr), 2) || '%</div>'  read_pct
  , ts.phywrts                             phywrts
  , '<div align="right">' || ROUND((ts.phywrts * 100) / (fst.pw + tst.pw), 2) || '%</div>' write_pct
  , (ts.phyrds + ts.phywrts)                 total_io
FROM
    sys.dba_temp_files  tf
  , v$tempstat          ts
  , (select sum(f.phyrds) pr, sum(f.phywrts) pw from v$filestat f) fst
  , (select sum(t.phyrds) pr, sum(t.phywrts) pw from v$tempstat t) tst
WHERE
    tf.file_id = ts.file#
ORDER BY phyrds DESC;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                          - INVALID OBJECTS -                               |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Invalid Objects</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN owner           FORMAT a85         HEADING 'Owner'         ENTMAP off
COLUMN object_name     FORMAT a30         HEADING 'Object Name'   ENTMAP off
COLUMN object_type     FORMAT a20         HEADING 'Object Type'   ENTMAP off
COLUMN status          FORMAT a75         HEADING 'Status'        ENTMAP off

BREAK ON report ON owner
COMPUTE count LABEL '<font color="#990000"><b>Grand Total: </b></font>' OF object_name ON report

SELECT
    '<div nowrap align="left"><font color="#336699"><b>' || owner || '</b></font></div>'    owner
  , object_name
  , object_type
  , DECODE(   status
            , 'VALID'
            , '<div align="center"><font color="darkgreen"><b>' || status || '</b></font></div>'
            , '<div align="center"><font color="#990000"><b>'   || status || '</b></font></div>' ) status
FROM dba_objects
WHERE status <> 'VALID'
ORDER BY
    owner
  , object_name;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                      - INITIALIZATION PARAMETERS (OPTIMIZER)-              |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Optimizer</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN pname             FORMAT a55  HEADING 'Parameter Name'    ENTMAP off
COLUMN value             FORMAT a55  HEADING 'Value'             ENTMAP off
COLUMN isdefault         FORMAT a55  HEADING 'Is Default?'       ENTMAP off
COLUMN issys_modifiable  FORMAT a55  HEADING 'Is Dynamic?'       ENTMAP off

SELECT
    DECODE(   isdefault
            , 'FALSE'
            , '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>'
            , '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>' ) pname
  , DECODE(   isdefault
            , 'FALSE'
            , '<font color="#663300"><b>' || SUBSTR(value,0,512) || '</b></font>'
            , SUBSTR(value,0,512) ) value
  , DECODE(   isdefault
            , 'FALSE'
            , '<div align="right"><font color="#663300"><b>' || isdefault || '</b></font></div>'
            , '<div align="right">' || isdefault || '</div>') isdefault
  , DECODE(   isdefault
            , 'FALSE'
            , '<div align="right"><font color="#663300"><b>' || issys_modifiable || '</b></font></div>'
            , '<div align="right">' || issys_modifiable || '</div>') issys_modifiable
FROM
    v$parameter 
WHERE
   name like 'optimizer%'
order by name
;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                      - INITIALIZATION PARAMETERS (PARALLELISM)-            |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Parallelism</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN pname             FORMAT a55  HEADING 'Parameter Name'    ENTMAP off
COLUMN value             FORMAT a55  HEADING 'Value'             ENTMAP off
COLUMN isdefault         FORMAT a55  HEADING 'Is Default?'       ENTMAP off
COLUMN issys_modifiable  FORMAT a55  HEADING 'Is Dynamic?'       ENTMAP off

SELECT
    DECODE(   isdefault
            , 'FALSE'
            , '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>'
            , '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>' ) pname
  , DECODE(   isdefault
            , 'FALSE'
            , '<font color="#663300"><b>' || SUBSTR(value,0,512) || '</b></font>'
            , SUBSTR(value,0,512) ) value
  , DECODE(   isdefault
            , 'FALSE'
            , '<div align="right"><font color="#663300"><b>' || isdefault || '</b></font></div>'
            , '<div align="right">' || isdefault || '</div>') isdefault
  , DECODE(   isdefault
            , 'FALSE'
            , '<div align="right"><font color="#663300"><b>' || issys_modifiable || '</b></font></div>'
            , '<div align="right">' || issys_modifiable || '</div>') issys_modifiable
FROM
    v$parameter 
	WHERE
name like 'parallel%'
order by name
;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                      - INITIALIZATION PARAMETERS (PARALLELISM)-            |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Initialization Parameters</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN pname             FORMAT a55  HEADING 'Parameter Name'    ENTMAP off
COLUMN value             FORMAT a55  HEADING 'Value'             ENTMAP off

SELECT
    DECODE(   isdefault
            , 'FALSE'
            , '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>'
            , '<b><font color="#336699">' || SUBSTR(name,0,512) || '</font></b>' ) pname
  , DECODE(   isdefault
            , 'FALSE'
            , '<font color="#663300"><b>' || SUBSTR(value,0,512) || '</b></font>'
            , SUBSTR(value,0,512) ) value
FROM
    v$parameter 
WHERE name in ('sga_max_size',
	       'shared_pool_size',
	       'shared_pool_reserved_size',
               'db_cache_size',
	       'db_keep_cache_size',
	       'db_recycle_cache_size',
	       'large_pool_size',
	       'java_pool_size',
	       'log_buffer',
               'workarea_size_policy',
               'pga_aggregate_target',
			   'create_bitmap_area_size',
			   'bitmap_merge_area_size')
;




prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>




-- +----------------------------------------------------------------------------+
-- |                - SQL STATEMENTS WITH MOST BUFFER GETS -                    |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SQL Statements With Most Buffer Gets</b></font><hr align="left" width="460">

prompt <b>Top 100 SQL statements with buffer gets greater than 1000</b>

CLEAR COLUMNS BREAKS COMPUTES

COLUMN username        FORMAT a75                   HEADING 'Username'                 ENTMAP off
COLUMN buffer_gets     FORMAT 999,999,999,999,999   HEADING 'Buffer Gets'              ENTMAP off
COLUMN executions      FORMAT 999,999,999,999,999   HEADING 'Executions'               ENTMAP off
COLUMN gets_per_exec   FORMAT 999,999,999,999,999   HEADING 'Buffer Gets / Execution'  ENTMAP off
COLUMN sql_text                                     HEADING 'SQL Text'                 ENTMAP off

SELECT 
    '<font color="#336699"><b>' || UPPER(b.username) || '</b></font>' username
  , a.buffer_gets              buffer_gets
  , a.executions               executions
  , (a.buffer_gets / decode(a.executions, 0, 1, a.executions))  gets_per_exec
  , a.sql_text                 sql_text
FROM 
    (SELECT ai.buffer_gets, ai.executions, ai.sql_text, ai.parsing_user_id
     FROM sys.v_$sqlarea ai
     ORDER BY ai.buffer_gets
    ) a
  , dba_users b
WHERE
      a.parsing_user_id = b.user_id 
  AND a.buffer_gets > 1000
  AND b.username NOT IN ('SYS','SYSTEM')
  AND rownum < 101
ORDER BY
    a.buffer_gets DESC;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>




-- +----------------------------------------------------------------------------+
-- |                 - SQL STATEMENTS WITH MOST DISK READS -                    |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>SQL Statements With Most Disk Reads</b></font><hr align="left" width="460">

prompt <b>Top 100 SQL statements with disk reads greater than 1000</b>

CLEAR COLUMNS BREAKS COMPUTES

COLUMN username        FORMAT a75                   HEADING 'Username'           ENTMAP off
COLUMN disk_reads      FORMAT 999,999,999,999,999   HEADING 'Disk Reads'         ENTMAP off
COLUMN executions      FORMAT 999,999,999,999,999   HEADING 'Executions'         ENTMAP off
COLUMN reads_per_exec  FORMAT 999,999,999,999,999   HEADING 'Reads / Execution'  ENTMAP off
COLUMN sql_text                                     HEADING 'SQL Text'           ENTMAP off

SELECT 
    '<font color="#336699"><b>' || UPPER(b.username) || '</b></font>' username
  , a.disk_reads       disk_reads
  , a.executions       executions
  , (a.disk_reads / decode(a.executions, 0, 1, a.executions))  reads_per_exec
  , a.sql_text         sql_text
FROM 
    (SELECT ai.disk_reads, ai.executions, ai.sql_text, ai.parsing_user_id
     FROM sys.v_$sqlarea ai
     ORDER BY ai.buffer_gets
    ) a
  , dba_users b
WHERE
      a.parsing_user_id = b.user_id 
  AND a.disk_reads > 1000
  AND b.username NOT IN ('SYS','SYSTEM')
  AND rownum < 101
ORDER BY
    a.disk_reads DESC;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                          - ONLINE REDO LOGS -                              |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Online Redo Logs</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN instance_name_print  FORMAT a95                HEADING 'Instance Name'    ENTMAP off
COLUMN thread_number_print  FORMAT a95                HEADING 'Thread Number'    ENTMAP off
COLUMN groupno                                        HEADING 'Group Number'     ENTMAP off
COLUMN member                                         HEADING 'Member'           ENTMAP off
COLUMN redo_file_type       FORMAT a75                HEADING 'Redo Type'        ENTMAP off
COLUMN log_status           FORMAT a75                HEADING 'Log Status'       ENTMAP off
COLUMN bytes                FORMAT 999,999,999,999    HEADING 'Bytes'            ENTMAP off
COLUMN archived             FORMAT a75                HEADING 'Archived?'        ENTMAP off

BREAK ON report ON instance_name_print ON thread_number_print

SELECT
    '<div align="center"><font color="#336699"><b>' || i.instance_name || '</b></font></div>'        instance_name_print
  , '<div align="center">' || i.thread# || '</div>'                                                  thread_number_print
  , f.group#                                                                                         groupno
  , '<tt>' || f.member || '</tt>'                                                                    member
  , f.type                                                                                           redo_file_type
  , DECODE(   l.status
            , 'CURRENT'
            , '<div align="center"><b><font color="darkgreen">' || l.status || '</font></b></div>'
            , '<div align="center"><b><font color="#990000">'   || l.status || '</font></b></div>')  log_status
  , l.bytes                                                                                          bytes
  , '<div align="center">'  || l.archived || '</div>'                                                archived
FROM
    gv$logfile  f
  , gv$log      l
  , gv$instance i
WHERE
      f.group#  = l.group#
  AND l.thread# = i.thread#
  AND i.inst_id = f.inst_id
  AND f.inst_id = l.inst_id
ORDER BY
    i.instance_name
  , f.group#
  , f.member;


prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>


-- +----------------------------------------------------------------------------+
-- |                         - REDO LOG SWITCHES -                              |
-- +----------------------------------------------------------------------------+

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Redo Log Switches</b></font><hr align="left" width="460">

CLEAR COLUMNS BREAKS COMPUTES

COLUMN DAY   FORMAT a75              HEADING 'Day / Time'  ENTMAP off
COLUMN H00   FORMAT 999,999B         HEADING '00'          ENTMAP off
COLUMN H01   FORMAT 999,999B         HEADING '01'          ENTMAP off
COLUMN H02   FORMAT 999,999B         HEADING '02'          ENTMAP off
COLUMN H03   FORMAT 999,999B         HEADING '03'          ENTMAP off
COLUMN H04   FORMAT 999,999B         HEADING '04'          ENTMAP off
COLUMN H05   FORMAT 999,999B         HEADING '05'          ENTMAP off
COLUMN H06   FORMAT 999,999B         HEADING '06'          ENTMAP off
COLUMN H07   FORMAT 999,999B         HEADING '07'          ENTMAP off
COLUMN H08   FORMAT 999,999B         HEADING '08'          ENTMAP off
COLUMN H09   FORMAT 999,999B         HEADING '09'          ENTMAP off
COLUMN H10   FORMAT 999,999B         HEADING '10'          ENTMAP off
COLUMN H11   FORMAT 999,999B         HEADING '11'          ENTMAP off
COLUMN H12   FORMAT 999,999B         HEADING '12'          ENTMAP off
COLUMN H13   FORMAT 999,999B         HEADING '13'          ENTMAP off
COLUMN H14   FORMAT 999,999B         HEADING '14'          ENTMAP off
COLUMN H15   FORMAT 999,999B         HEADING '15'          ENTMAP off
COLUMN H16   FORMAT 999,999B         HEADING '16'          ENTMAP off
COLUMN H17   FORMAT 999,999B         HEADING '17'          ENTMAP off
COLUMN H18   FORMAT 999,999B         HEADING '18'          ENTMAP off
COLUMN H19   FORMAT 999,999B         HEADING '19'          ENTMAP off
COLUMN H20   FORMAT 999,999B         HEADING '20'          ENTMAP off
COLUMN H21   FORMAT 999,999B         HEADING '21'          ENTMAP off
COLUMN H22   FORMAT 999,999B         HEADING '22'          ENTMAP off
COLUMN H23   FORMAT 999,999B         HEADING '23'          ENTMAP off
COLUMN TOTAL FORMAT 999,999,999      HEADING 'Total'       ENTMAP off

BREAK ON report
COMPUTE sum LABEL '<font color="#990000"><b>Total:</b></font>' avg label '<font color="#990000"><b>Average:</b></font>' OF total ON report

SELECT
    '<div align="center"><font color="#336699"><b>' || SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH:MI:SS'),1,5)  || '</b></font></div>'  DAY
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'00',1,0)) H00
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'01',1,0)) H01
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'02',1,0)) H02
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'03',1,0)) H03
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'04',1,0)) H04
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'05',1,0)) H05
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'06',1,0)) H06
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'07',1,0)) H07
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'08',1,0)) H08
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'09',1,0)) H09
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'10',1,0)) H10
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'11',1,0)) H11
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'12',1,0)) H12
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'13',1,0)) H13
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'14',1,0)) H14
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'15',1,0)) H15
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'16',1,0)) H16
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'17',1,0)) H17
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'18',1,0)) H18
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'19',1,0)) H19
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'20',1,0)) H20
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'21',1,0)) H21
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'22',1,0)) H22
  , SUM(DECODE(SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH24:MI:SS'),10,2),'23',1,0)) H23
  , COUNT(*)                                                                      TOTAL
FROM
  v$log_history  a
GROUP BY SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH:MI:SS'),1,5)
ORDER BY SUBSTR(TO_CHAR(first_time, 'MM/DD/RR HH:MI:SS'),1,5)
/

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>Performance review</b></font><hr align="left" width="460">


create table KODOK$BUNCIT (SEKSI VARCHAR2(50), NILAI VARCHAR2(5), WARNING VARCHAR2(1024));

--LIBRARY CACHE RELOADS RATIO
INSERT INTO KODOK$BUNCIT
SELECT 'Library Cache Reloads Ratio',
       ROUND((SUM(reloads) / SUM(pins)) * 100, 2),
       'Above 1 %    Recommendation :    The library cache contains shared SQL and PL/SQL areas.    The library cache reload is the number of library cache misses on the execution step, causing implicit reparsing of the statement and block.    If ratio of  the library cache reloads is greater than 1%, increase the value of the  SGA_TARGET parameter.'
FROM v$librarycache
WHERE LOWER(namespace) IN ('sql area', 
                           'table/procedure', 
               'body', 
               'trigger')
;
--Data Dictionary Cache Miss

INSERT INTO KODOK$BUNCIT
SELECT 'Data Dictionary Cache Miss',
       ROUND(SUM(getmisses) / SUM(gets), 2) * 100,
       'Above 15 %  Recommendation :    The data dictionary cache holds definitions of dictionary objects in memory.    If ratio of  the data dictionary cache miss is greater than 15%, increase the value of the SGA_TARGET parameter.'
FROM v$rowcache
;

--Shared Pool Execution Miss
INSERT INTO KODOK$BUNCIT
select 
'Shared Pool Execution Miss',
ROUND((sum(reloads)/sum(pins)*100),2) ,
'Above 1 %  Recommendation :    If ratio of the shared pool execution miss is greater than 1%, increase the value of the SGA_TARGET parameter.'
from v$librarycache;

--Shared Pool Size (Dictionary Gets) 
INSERT INTO KODOK$BUNCIT
select 'Shared Pool Dictionary Gets',
       ROUND(100*(sum(getmisses)/sum(gets)),2) ,
       'Above 12 % Recommendation :    If ratio of  the shared pool dictionary gets is greater than 12%, increase the value of the SGA_TARGET parameter.'       
from v$rowcache;

--Buffer Cache Hit Ratio
INSERT INTO KODOK$BUNCIT
SELECT 
'Buffer Cache Hit Ratio',
ROUND((1 - (phy.value - lob.value - dir.value) / ses.value) * 100, 2) ,
'Below 80 % (OLTP)  Recommendation :    The buffer cache hold copies of the data block from the data files.  The server processes read data from the data files into the buffer cache.  If ratio of the buffer cache hit is smaller than 80%, increase the memory of the DB_CACHE_SIZE.'       
FROM v$sysstat ses,
     v$sysstat lob,
     v$sysstat dir,
     v$sysstat phy
WHERE ses.name = 'session logical reads'
AND dir.name = 'physical reads direct'
AND lob.name = 'physical reads direct (lob)'
AND phy.name = 'physical reads'
;

--Redo Buffer Retry Ratio Percentage
INSERT INTO KODOK$BUNCIT
SELECT 'Redo Buffer Retry Ratio Percentage',
       ROUND((r.value / e.value) * 100, 2),
       'Above 1 %   Recommendation :    The redo buffer allocation retries reflects the number of times a user process waits for space in the redo log buffer to copy new entries over the entries that have been written to disk.  If ratio of the redo buffer retry is greater than 1%, increase the value of the LOG_BUFFER parameter.   Alternatively, improve the checkpointing or archiving process.'       
FROM v$sysstat r,
     v$sysstat e
WHERE r.name = 'redo buffer allocation retries'
AND e.name   = 'redo entries'
;


-- PGA CACHE HIT PERCENTAGE
INSERT INTO KODOK$BUNCIT
SELECT 
'PGA cache hit ratio',
value,
'Below 60 % Recommendation :    PGA as a private memory region containing data and control information for a server process, like to process SQL statements.    If the ratio of PGA cache hit ratio is smaller than 60 %, increase the value of the pga_aggregate_target parameter,  or  this might indicate missing indexes on specific tables.'
FROM v$pgastat
where name IN ('cache hit percentage')
;

--Ratio Disk to Memory  
INSERT INTO KODOK$BUNCIT
SELECT 'Sorting ratio disk to memory',
       ROUND((disk.value/mem.value) * 100, 2),
       'Above 5% (OLTP) Recommendation :    An area of sort_area_size is for the active sort. The good performance is if high number of sorts going to memory than to disk. If the ratio of sorts (disk) to sorts (memory) is greater than 5%, increase the value of the SORT_AREA_SIZE parameter.'
FROM v$sysstat disk, v$sysstat mem
WHERE mem.name = 'sorts (memory)'
AND disk.name = 'sorts (disk)'
;
COMMIT;
--SEKSI VARCHAR2(30), NILAI VARCHAR2(5), WARNING VARCHAR2(1024)
COLUMN SEKSI	FORMAT a45					HEADING 'Section'				ENTMAP off
COLUMN NILAI	FORMAT 999,999,999,999		HEADING 'Value'					ENTMAP off
COLUMN WARNING	FORMAT a25					HEADING 'Warning Threshold'		ENTMAP off

select * from KODOK$BUNCIT;
DROP TABLE KODOK$BUNCIT PURGE;

prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

prompt <font size="+2" face="Arial,Helvetica,Geneva,sans-serif" color="#336699"><b>audit</b></font><hr align="left" width="460">

select db_user,os_user,userhost,object_name,timestamp,sql_text from dba_fga_audit_trail
where policy_name='PL_PS_AUDIT'
;

select db_user,os_user,userhost,object_name,timestamp,sql_text from dba_fga_audit_trail
where policy_name='PL_KK_AUDIT'
;

select db_user,os_user,userhost,object_name,timestamp,sql_text from dba_fga_audit_trail
where policy_name='PL_PES_AUDIT'
;

select db_user,os_user,userhost,object_name,timestamp,sql_text from dba_fga_audit_trail
where policy_name='PL_DK_AUDIT'
;

select db_user,os_user,userhost,object_name,timestamp,sql_text from dba_fga_audit_trail
where policy_name='PL_AK_AUDIT'
;
prompt <center>[<a class="noLink" href="#top">Top</a>]</center><p>

-- +----------------------------------------------------------------------------+
-- |                            - END OF REPORT -                               |
-- +----------------------------------------------------------------------------+

SPOOL OFF

SET MARKUP HTML OFF

SET TERMOUT ON

prompt 
prompt Output written to: &FileName._&_dbname._&_spool_time..html

EXIT;




