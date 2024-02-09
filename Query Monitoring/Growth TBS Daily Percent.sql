SET LINESIZE 120
COLUMN name FORMAT A15
COLUMN variance FORMAT A20
ALTER SESSION SET NLS_DATE_FORMAT='yyyy-mm-dd';

WITH t AS (
  SELECT
    ss.run_time,
    ts.name,
    ROUND(su.tablespace_size * dt.block_size / 1024 / 1024 / 1024, 2) alloc_size_gb,
    ROUND(su.tablespace_usedsize * dt.block_size / 1024 / 1024 / 1024, 2) used_size_gb
  FROM
    dba_hist_tbspc_space_usage su,
    (SELECT TRUNC(BEGIN_INTERVAL_TIME) run_time, MAX(snap_id) snap_id FROM dba_hist_snapshot GROUP BY TRUNC(BEGIN_INTERVAL_TIME)) ss,
    v$tablespace ts,
    dba_tablespaces dt
  WHERE
    su.snap_id = ss.snap_id
    AND su.tablespace_id = ts.ts#
    AND ts.name = UPPER('&TABLESPACE_NAME')
    AND ts.name = dt.tablespace_name
)
SELECT
  e.run_time,
  e.name,
  b.used_size_gb prev_used_size_gb,
  e.used_size_gb curr_used_size_gb,
  e.alloc_size_gb,
  CASE
    WHEN e.used_size_gb > b.used_size_gb THEN TO_CHAR(e.used_size_gb - b.used_size_gb)
    WHEN e.used_size_gb = b.used_size_gb THEN 'NO DATA GROWTH'
    WHEN e.used_size_gb < b.used_size_gb THEN '***DATA PURGED'
  END variance,
  ((e.used_size_gb - b.used_size_gb) / b.used_size_gb) * 100 AS percent_growth
FROM
  t e,
  t b
WHERE
  e.run_time = b.run_time + 1
ORDER BY 1;
