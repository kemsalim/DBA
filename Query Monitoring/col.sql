set pages 10000 lines 180
col column_name for a35
col data_type for a35

select column_name, data_type, num_distinct, density, num_nulls, num_buckets, histogram,
	sample_size, last_analyzed
from dba_tab_columns
where table_name='&1'
;
