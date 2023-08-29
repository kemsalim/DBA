## Software Detail
Oracle Oracle Database 19c Enterprise Edition Release 19.17.0.0.0 - Production

## Problem Identification
-	RAC, database downed and Server suddenly restarted on  node 1
-	Slow performance server and failure failover on node 2

## Analysis Result
-   RAC, database downed and Server suddenly restarted on  node 1
    
    
- 15-04-2023 04:46:59  Database is still running normal
    -   2023-04-15T04:46:59.778208+07:00
        Thread 1 advanced to log sequence 30658 (LGWR switch),  current SCN: 21960424776
        Current log# 3 seq# 30658 mem# 0: +NEW_RECO/bsdionpay/onlinelog/group_3.289.983271403
        Current log# 3 seq# 30658 mem# 1: +NEW_DATA/bsdionpay/onlinelog/group_3.343.983271405

-   15-04-2023 05:37:59 until 15-04-23 05:47:18 
    -   Aborted command ‘check’ for all resource
```bash
2023-04-15 05:37:59.078 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:0:2} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:38:01.463 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:38:33.609 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:38:35.903 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:39:08.860 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:39:09.326 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:38:26.749 [SCRIPTAGENT(23546)]CRS-5818: Aborted command 'check' for resource 'ora.qosmserver'. Details at (:CRSAGF00113:) {2:28302:2878} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_scriptagent_oracle.trc.
2023-04-15 05:39:41.290 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:39:42.257 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:40:14.224 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:40:14.832 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:40:24.447 [SCRIPTAGENT(23546)]CRS-5818: Aborted command 'check' for resource 'ora.qosmserver'. Details at (:CRSAGF00113:) {2:28302:2878} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_scriptagent_oracle.trc.
2023-04-15 05:40:46.794 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:40:48.937 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:41:10.467 [ORAAGENT(4773)]CRS-5818: Aborted command 'check' for resource 'ora.ons'. Details at (:CRSAGF00113:) {1:54199:2} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc.
2023-04-15 05:41:11.264 [ORAAGENT(4773)]CRS-5014: Agent "ORAAGENT" timed out starting process "/oracle/grid/19.0.0/opmn/bin/onsctli" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc"
2023-04-15 05:41:23.854 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:41:27.622 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:42:01.625 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:42:05.111 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:42:24.430 [SCRIPTAGENT(23546)]CRS-5818: Aborted command 'check' for resource 'ora.qosmserver'. Details at (:CRSAGF00113:) {2:28302:2878} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_scriptagent_oracle.trc.
2023-04-15 05:42:38.105 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:42:40.074 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:43:10.417 [ORAAGENT(4773)]CRS-5818: Aborted command 'check' for resource 'ora.ons'. Details at (:CRSAGF00113:) {1:54199:2} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc.
2023-04-15 05:43:12.010 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:43:11.956 [ORAAGENT(4773)]CRS-5014: Agent "ORAAGENT" timed out starting process "/oracle/grid/19.0.0/opmn/bin/onsctli" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc"
2023-04-15 05:43:14.292 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:43:17.756 [ORAAGENT(4773)]CRS-5818: Aborted command 'check' for resource 'ora.LISTENER_SCAN1.lsnr'. Details at (:CRSAGF00113:) {2:28302:2878} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc.
2023-04-15 05:43:47.226 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:43:48.588 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:44:20.490 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:44:24.439 [SCRIPTAGENT(23546)]CRS-5818: Aborted command 'check' for resource 'ora.qosmserver'. Details at (:CRSAGF00113:) {2:28302:2878} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_scriptagent_oracle.trc.
2023-04-15 05:44:22.037 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:44:55.980 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:44:57.618 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:45:07.568 [ORAAGENT(4773)]CRS-5818: Aborted command 'check' for resource 'ora.LISTENER.lsnr'. Details at (:CRSAGF00113:) {1:54199:2} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc.
2023-04-15 05:45:08.097 [ORAAGENT(4773)]CRS-5014: Agent "ORAAGENT" timed out starting process "/oracle/grid/19.0.0/bin/lsnrctl" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc"
2023-04-15 05:45:10.418 [ORAAGENT(4773)]CRS-5818: Aborted command 'check' for resource 'ora.ons'. Details at (:CRSAGF00113:) {1:54199:2} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc.
2023-04-15 05:45:11.748 [ORAAGENT(4773)]CRS-5014: Agent "ORAAGENT" timed out starting process "/oracle/grid/19.0.0/opmn/bin/onsctli" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc"
2023-04-15 05:45:31.545 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:45:32.087 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:46:05.087 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
2023-04-15 05:46:24.425 [SCRIPTAGENT(23546)]CRS-5818: Aborted command 'check' for resource 'ora.qosmserver'. Details at (:CRSAGF00113:) {2:28302:2878} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_scriptagent_oracle.trc.
2023-04-15 05:46:11.317 [ORAROOTAGENT(3654)]CRS-5014: Agent "ORAROOTAGENT" timed out starting process "/oracle/grid/19.0.0/bin/acfsload" for action "check": details at "(:CLSN00009:)" in "/oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc"
2023-04-15 05:47:10.482 [ORAAGENT(4773)]CRS-5818: Aborted command 'check' for resource 'ora.ons'. Details at (:CRSAGF00113:) {1:54199:2} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsd_oraagent_oracle.trc.
2023-04-15 05:47:18.344 [ORAROOTAGENT(3654)]CRS-5818: Aborted command 'check' for resource 'ora.drivers.acfs'. Details at (:CRSAGF00113:) {0:1:10} in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ohasd_orarootagent_root.trc.
```

-    15-04-2023 05:42:17 until 15-04-2023 05:47:45  
    -   all the incidents appeared on alert log concurrently with crs log on the previous point

```bash
2023-04-15T05:42:17.172111+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 26 secs.
2023-04-15T05:42:24.308240+07:00
  Version 19.17.0.0.0
2023-04-15T05:42:24.308302+07:00
    
2023-04-15T05:42:26.155398+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 26 secs.
2023-04-15T05:42:27.982860+07:00
IPC0 (ospid: 5589) is hung in an acceptable location (inwait|latch-get 0x5.ffff).
2023-04-15T05:42:27.983423+07:00
  Time: 15-APR-2023 05:42:25
2023-04-15T05:42:30.500312+07:00
TNS-12537: TNS:connection closed

2023-04-15T05:43:56.344526+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_rms0_5660.trc  (incident=1593396):
ORA-00240: control file enqueue held for more than 120 seconds
2023-04-15T05:44:04.082383+07:00
    nt OS err code: 0
2023-04-15T05:44:11.270302+07:00
opiodr aborting process unknown ospid (214160) as a result of ORA-609
2023-04-15T05:44:28.191785+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 28 secs.
2023-04-15T05:44:31.249069+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1593396/BSDIONPAY1_rms0_5660_i1593396.trc
2023-04-15T05:44:35.636412+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 28 secs.
2023-04-15T05:44:40.989540+07:00
IPC0 (ospid: 5589) is hung in an acceptable location (inwait|latch-get 0x5.ffff).
2023-04-15T05:44:57.278993+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_mmon_5723.trc  (incident=1593556):
ORA-00445: background process "M000" did not start after 120 seconds
2023-04-15T05:45:17.988428+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1593556/BSDIONPAY1_mmon_5723_i1593556.trc
2023-04-15T05:47:04.089924+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 69 secs.
2023-04-15T05:47:45.917440+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 69 secs.

```

-   15-04-2023 05:47:45 until 15-04-2023 05:56:03
    -   Server is in the process of restarting
    
```bash
2023-04-15 05:56:03.115 [CRSCTL(289351)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_289351.trc.
2023-04-15 05:56:13.447 [CRSCTL(304033)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_304033.trc.
2023-04-15 05:56:22.770 [OCRCONFIG(316309)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ocrconfig_316309.trc.
2023-04-15 05:56:37.692 [OCRDUMP(336519)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/ocrdump_336519.trc.
2023-04-15 05:56:48.445 [CRSCTL(350671)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_350671.trc.
2023-04-15 05:56:57.744 [CRSCTL(359291)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_359291.trc.
2023-04-15 05:57:08.896 [CRSCTL(372515)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_372515.trc.
2023-04-15 06:01:36.389 [CRSCTL(275692)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_275692.trc.
2023-04-15 06:18:29.564 [CRSCTL(213852)]CRS-1013: The OCR location in an ASM disk group is inaccessible. Details in /oracle/db/diag/crs/bsd-pg-db-01/crs/trace/crsctl_213852.trc.

```

-   15-04-2023 06:34:34
    -   ASM is trying to starting up
```bash
2023-04-15T06:34:34.577560+07:00
* instance_number obtained from CSS = 1, checking for the existence of node 0... 
* node 0 does not exist. instance_number = 1 
Starting ORACLE instance (normal) (OS id: 227876)
```

-   15-04-2023 06:34:59 
    -   Database is trying to starting up
```bash
2023-04-15T06:34:59.706568+07:00
Starting ORACLE instance (normal) (OS id: 228545)
```

- 15-04-2023 07:56 
    -   same incidents happen again
```bash
2023-04-15T07:56:58.931130+07:00
CLMN: clean deferred state objects - failed
2023-04-15T07:58:18.909869+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_rms0_228873.trc  (incident=1609408):
ORA-00240: control file enqueue held for more than 120 seconds
2023-04-15T07:58:50.096063+07:00
IPC0 (ospid: 228784) waits for event 'latch: MGA shared context latch' for 86 secs.
2023-04-15T07:59:22.790038+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_pxmn_228918.trc  (incident=1609536):
ORA-00445: background process "PPA6" did not start after 120 seconds
2023-04-15T07:59:35.967227+07:00
IPC0 (ospid: 228784) waits for latch 'MGA shared context latch' for 86 secs.
2023-04-15T08:00:02.798944+07:00
IPC0 (ospid: 228784) is hung in an acceptable location (inwait|latch-get 0x5.ffff).
2023-04-15T08:00:55.872277+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1609408/BSDIONPAY1_rms0_228873_i1609408.trc
2023-04-15T08:01:07.758047+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1609536/BSDIONPAY1_pxmn_228918_i1609536.trc

```

## Findings : (Node 1)

```bash
The alert.log symptoms indicates for the high load.
The TNS errors are due to high load.
------------
2023-04-15T05:17:32.096793+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_ppa6_87498.trc:
2023-04-15T05:41:13.311946+07:00


***********************************************************************
2023-04-15T05:41:18.485727+07:00

Fatal NI connect error 12537, connecting to:
(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.110.50)(PORT=52502))
2023-04-15T05:41:30.242981+07:00

VERSION INFORMATION:
TNS for Linux: Version 19.0.0.0.0 - Production
Oracle Bequeath NT Protocol Adapter for Linux: Version 19.0.0.0.0 - Production
TCP/IP NT Protocol Adapter for Linux: Version 19.0.0.0.0 - Production
2023-04-15T05:41:40.958265+07:00
Version 19.17.0.0.0
2023-04-15T05:41:43.753709+07:00
kkjcre1p: unable to spawn jobq slave process
2023-04-15T05:41:47.683938+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_cjq0_5983.trc:
2023-04-15T05:41:47.684014+07:00
Time: 15-APR-2023 05:41:42
2023-04-15T05:41:50.514473+07:00


***********************************************************************
2023-04-15T05:41:50.514533+07:00
Tracing not turned on.
2023-04-15T05:42:00.382296+07:00

Fatal NI connect error 12537, connecting to:
(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.110.50)(PORT=53388))
2023-04-15T05:42:00.382409+07:00
Tns error struct:
2023-04-15T05:42:12.714833+07:00

VERSION INFORMATION:
TNS for Linux: Version 19.0.0.0.0 - Production
Oracle Bequeath NT Protocol Adapter for Linux: Version 19.0.0.0.0 - Production
TCP/IP NT Protocol Adapter for Linux: Version 19.0.0.0.0 - Production
2023-04-15T05:42:12.714910+07:00
ns main err code: 12537
2023-04-15T05:42:17.172111+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 26 secs.
2023-04-15T05:42:24.308240+07:00
Version 19.17.0.0.0
2023-04-15T05:42:24.308302+07:00

2023-04-15T05:42:26.155398+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 26 secs.
2023-04-15T05:42:27.982860+07:00
IPC0 (ospid: 5589) is hung in an acceptable location (inwait|latch-get 0x5.ffff). <<<<<<<<<<<<<<<<<<<<<<
2023-04-15T05:42:27.983423+07:00
Time: 15-APR-2023 05:42:25
2023-04-15T05:42:30.500312+07:00
TNS-12537: TNS:connection closed
2023-04-15T05:42:34.950488+07:00
Tracing not turned on.
2023-04-15T05:42:37.844384+07:00
ns secondary err code: 12560
2023-04-15T05:42:44.616810+07:00
Tns error struct:
2023-04-15T05:42:47.944545+07:00
nt main err code: 507
2023-04-15T05:42:52.764849+07:00
ns main err code: 12537
2023-04-15T05:42:54.189277+07:00

2023-04-15T05:42:58.844866+07:00

2023-04-15T05:43:01.516440+07:00
TNS-00507: Connection closed
2023-04-15T05:43:11.646912+07:00
TNS-12537: TNS:connection closed
2023-04-15T05:43:14.443969+07:00
nt secondary err code: 0
2023-04-15T05:43:20.272174+07:00
ns secondary err code: 12560
2023-04-15T05:43:25.132374+07:00
nt OS err code: 0
2023-04-15T05:43:32.742504+07:00
opiodr aborting process unknown ospid (213913) as a result of ORA-609
2023-04-15T05:43:32.742568+07:00
nt main err code: 507
2023-04-15T05:43:40.516330+07:00

2023-04-15T05:43:49.224107+07:00
TNS-00507: Connection closed
2023-04-15T05:43:56.344375+07:00
nt secondary err code: 0
2023-04-15T05:43:56.344526+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_rms0_5660.trc (incident=1593396):
ORA-00240: control file enqueue held for more than 120 seconds
2023-04-15T05:44:04.082383+07:00
nt OS err code: 0
2023-04-15T05:44:11.270302+07:00
opiodr aborting process unknown ospid (214160) as a result of ORA-609
2023-04-15T05:44:28.191785+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 28 secs.
2023-04-15T05:44:31.249069+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1593396/BSDIONPAY1_rms0_5660_i1593396.trc
2023-04-15T05:44:35.636412+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 28 secs.
2023-04-15T05:44:40.989540+07:00
IPC0 (ospid: 5589) is hung in an acceptable location (inwait|latch-get 0x5.ffff).
2023-04-15T05:44:57.278993+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_mmon_5723.trc (incident=1593556):
ORA-00445: background process "M000" did not start after 120 seconds <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Which confirms for the high memory load



The CPU was 100% which we have already seen from the OS statistics.
-----------
zzz ***Sat Apr 15 05:43:39 WIB 2023
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
r b swpd free buff cache si so bi bo in cs us sy id wa st
58 2 7878064 1906808 1644 44518008 0 0 6333 295 0 0 18 5 69 9 0
50 1 7878040 1862036 1644 44558296 0 0 40987 135 29094 19290 98 2 0 0 0
66 1 7878040 1845888 1644 44563108 8 0 27571 212 13294 15037 97 3 0 0 0
66 1 7878040 1845888 1644 44563108 8 0 27571 212 13294 15037 97 3 0 0 0
zzz ***Sat Apr 15 05:47:09 WIB 2023
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
r b swpd free buff cache si so bi bo in cs us sy id wa st
45 0 7872180 1850644 1644 44544412 0 0 6333 295 0 0 18 5 69 9 0
57 0 7872172 1848312 1644 44544428 8 0 78 35 26432 19702 98 2 0 0 0 <<<<<<<<<<<<<<<<<<<
59 0 7872124 1847764 1644 44544488 112 0 139 35 26538 22092 98 2 0 0 0 <<<<<<<<<<<<<<<<<<<<<<
.
.
zzz ***Sat Apr 15 06:28:12 WIB 2023
procs -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
r b swpd free buff cache si so bi bo in cs us sy id wa st
7 0 156 1770360 4020 49558012 0 0 3090 101 1122 494 20 18 60 1 0
1 0 156 1731884 3368 49676184 0 0 450336 220 12898 14500 16 11 72 1 0
2 0 168 1689812 3180 49802276 32 12 465576 220 12293 13653 15 9 73 2 0
-----------

-	Findings : (Node 1)

The issue caused on node-1 around "5:45" on April 15th.
----------
####### alert_BSDIONPAY1.log #######

2023-04-15T03:25:18.558368+07:00
ARC3 (PID:5892): Archived Log entry 88243 added for T-1.S-30656 ID 0x4c6ba4c5 LAD:1
2023-04-15T04:19:29.531688+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_ppa6_87498.trc:
2023-04-15T04:46:59.778208+07:00
Thread 1 advanced to log sequence 30658 (LGWR switch), current SCN: 21960424776
Current log# 3 seq# 30658 mem# 0: +NEW_RECO/bsdionpay/onlinelog/group_3.289.983271403
Current log# 3 seq# 30658 mem# 1: +NEW_DATA/bsdionpay/onlinelog/group_3.343.983271405
2023-04-15T04:47:07.253867+07:00
ARC4 (PID:5894): Archived Log entry 88247 added for T-1.S-30657 ID 0x4c6ba4c5 LAD:1
2023-04-15T05:17:32.096793+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_ppa6_87498.trc:
2023-04-15T05:41:13.311946+07:00


***********************************************************************
2023-04-15T05:41:18.485727+07:00

Fatal NI connect error 12537, connecting to:
(ADDRESS=(PROTOCOL=tcp)(HOST=192.168.110.50)(PORT=52502))
2023-04-15T05:41:30.242981+07:00

VERSION INFORMATION:
TNS for Linux: Version 19.0.0.0.0 - Production
Oracle Bequeath NT Protocol Adapter for Linux: Version 19.0.0.0.0 - Production
TCP/IP NT Protocol Adapter for Linux: Version 19.0.0.0.0 - Production
2023-04-15T05:41:40.958265+07:00
Version 19.17.0.0.0
2023-04-15T05:41:43.753709+07:00
kkjcre1p: unable to spawn jobq slave process
2023-04-15T05:41:47.683938+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_cjq0_5983.trc:
2023-04-15T05:41:47.684014+07:00
Time: 15-APR-2023 05:41:42
2023-04-15T05:41:50.514473+07:00


***********************************************************************
.
.

2023-04-15T05:43:49.224107+07:00
TNS-00507: Connection closed
2023-04-15T05:43:56.344375+07:00
nt secondary err code: 0
2023-04-15T05:43:56.344526+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_rms0_5660.trc (incident=1593396):
ORA-00240: control file enqueue held for more than 120 seconds
2023-04-15T05:44:04.082383+07:00
nt OS err code: 0
2023-04-15T05:44:11.270302+07:00
opiodr aborting process unknown ospid (214160) as a result of ORA-609
2023-04-15T05:44:28.191785+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 28 secs.
2023-04-15T05:44:31.249069+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1593396/BSDIONPAY1_rms0_5660_i1593396.trc
2023-04-15T05:44:35.636412+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 28 secs.
2023-04-15T05:44:40.989540+07:00
IPC0 (ospid: 5589) is hung in an acceptable location (inwait|latch-get 0x5.ffff).
2023-04-15T05:44:57.278993+07:00
Errors in file /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/trace/BSDIONPAY1_mmon_5723.trc (incident=1593556):
ORA-00445: background process "M000" did not start after 120 seconds
2023-04-15T05:45:17.988428+07:00
Incident details in: /oracle/db/diag/rdbms/bsdionpay/BSDIONPAY1/incident/incdir_1593556/BSDIONPAY1_mmon_5723_i1593556.trc
2023-04-15T05:47:04.089924+07:00
IPC0 (ospid: 5589) waits for event 'latch: MGA shared context latch' for 69 secs.
2023-04-15T05:47:45.917440+07:00
IPC0 (ospid: 5589) waits for latch 'MGA shared context latch' for 69 secs.
2023-04-15T06:34:59.706568+07:00
Starting ORACLE instance (normal) (OS id: 228545)
----------

But the TOP command output stuck at "5:37".
----------
zzz ***Sat Apr 15 05:37:08 WIB 2023
Tasks: 1077 total, 37 running, 1039 sleeping, 0 stopped, 1 zombie
%Cpu(s): 96.2 us, 3.5 sy, 0.0 ni, 0.0 id, 0.0 wa, 0.0 hi, 0.3 si, 0.0 st
KiB Mem : 65172132 total, 1975420 free, 18957412 used, 44239300 buff/cache
KiB Swap: 16777212 total, 8726140 free, 8051072 used. 30933588 avail Mem

PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
212185 oracle 20 0 16.7g 270164 264912 R 83.3 0.4 0:36.86 oracle_21+
209592 oracle 20 0 16.7g 354012 347868 R 78.3 0.5 2:04.06 oracle_20+
211947 oracle 20 0 16.7g 266316 261356 R 76.3 0.4 0:37.27 oracle_21+
212182 oracle 20 0 16.7g 266048 260796 R 73.7 0.4 0:36.21 oracle_21+
212442 oracle 20 0 16.7g 260156 254904 R 73.2 0.4 0:29.78 oracle_21+
210456 oracle 20 0 16.7g 322840 316732 R 71.7 0.5 1:24.47 oracle_21+
202579 oracle 20 0 16.7g 489388 483168 R 71.2 0.8 4:20.02 oracle_20+
198561 oracle 20 0 16.7g 490420 484808 R 70.7 0.8 5:24.93 oracle_19+
203288 oracle 20 0 16.7g 564872 559372 R 70.7 0.9 5:48.62 oracle_20+
.
.
25945 gdm 20 0 921688 112220 5524 S 5.6 0.2 9055:40 gsd-color
185844 oracle 20 0 16.8g 159000 128564 R 5.6 0.2 1:51.06 oracle_18+
213324 oracle 20 0 6040 3368 1616 R 4.5 0.0 0:00.35 pidstat
295349 oracle 20 0 16.7g 9.7g 9.7g S 4.5 15.7 36:21.80 oracle_29+
45974 root 20 0 1377244 244672 104896 S 3.0 0.4 932:58.97 ologgerd
213381 oracle 20 0 59276 4984 3352 R 3.0 0.0 0:00.13 top
378876 oracle 20 0 16.7g 9.8g 9.8g S 3.0 15.7 21:04.49 oracle_37+
5593 oracle -2 0 15.7g 57684 57432 S 2.5 0.1 633:09.66 ora_vktm_+
90823 oracle 20 0 16.7g 9.9g 9.9g S 2.5 15.9 50:56.23 oracle_90+
213451 root 20 0 156948 3932 3512 R 2.5 0.0 0:00.07 ps
213468 root 20 0 51760 3596 3184 R 2.5 0.0 0:00.05 ps
4430 root 20 0 4613636 137368 48704 S 2.0 0.2 952:58.13 crsd.bin
280394 root 20 0 5908840 516808 2660 S 2.0 0.8 553:24.17 java
4587 root 20 0 1551376 44376 37320 S 1.5 0.1 1340:57 orarootag+
4773 oracle 20 0 3043904 66752 47756 S 1.5 0.1 1321:59 oraagent.+
----------

Hence no OS statistics of TOP between "5:37" to "6:34" no vmcore generated.


```

## Finding : (Node 2)

```bash
Linux OSWbb v22.1.0AHF bsd-pg-db-02
zzz ***Sat Apr 15 05:00:09 WIB 2023


zzz ***Sat Apr 15 05:43:08 WIB 2023
top - 05:43:09 up 139 days, 9:56, 1 user, load average: 79.77, 69.85, 49.34 <<<<<<<<<< Node is up and running from 139 days and load avg is very high
Tasks: 1010 total, 1 running, 1009 sleeping, 0 stopped, 0 zombie
%Cpu(s): 16.4 us, 11.2 sy, 0.0 ni, 71.5 id, 0.7 wa, 0.0 hi, 0.1 si, 0.0 st
KiB Mem : 65172132 total, 1581324 free, 14824920 used, 48765888 buff/cache
KiB Swap: 16777212 total, 11357828 free, 5419384 used. 32606304 avail Mem

PID USER PR NI VIRT RES SHR S %CPU %MEM TIME+ COMMAND
20303 root 20 0 331600 298220 3292 S 401.0 0.5 87052:17 rtvscand <<<<<<<<<<< many root processes using High CPU
36259 root 20 0 321820 34584 29208 S 28.6 0.1 1:09.58 bpbkar <<<<<<<<<<<
19908 root 20 0 1034680 19612 13076 S 27.6 0.0 862:38.63 nbftclnt <<<<<<<<<<<
78 root 20 0 0 0 0 S 13.3 0.0 247:16.99 kswapd0:0 <<<<<<<<<<< Heavy swapping is happening
66181 oracle 20 0 5968 3156 1528 S 9.5 0.0 0:00.19 pidstat
66185 oracle 20 0 5968 3104 1472 S 9.5 0.0 0:00.19 pidstat
66216 oracle 20 0 59280 5032 3468 R 4.8 0.0 0:00.11 top
398538 oracle 20 0 15.9g 11.4g 11.4g S 4.8 18.4 1301:32 ora_scmn_+
5349 oracle 20 0 16.5g 5.7g 5.7g S 2.9 9.1 3:23.71 oracle_53+
66158 oracle 20 0 4420 1628 1460 S 2.9 0.0 0:00.08 iostat
62362 oracle 20 0 16.5g 288152 246844 S 1.9 0.4 0:01.50 ora_m002_+
250443 root 20 0 5973588 432188 3492 S 1.9 0.7 390:42.13 java <<<<<<<<<<<
396705 oracle 20 0 947748 46192 26268 S 1.9 0.1 477:47.39 gipcd.bin
397570 root 20 0 1416380 42676 36660 S 1.9 0.1 1045:55 orarootag+
397715 oracle 20 0 2910636 57328 46336 S 1.9 0.1 1162:19 oraagent.+

```

## Summary
-	RAC, database downed and Server suddenly restarted on  node 1
    -   System resource is 100% utilized (High CPU) 
    -   Since there is no vmcore collected  between "5:37" to "6:34". There is no information regarding the root cause of reboot server node 1. The vmcore was not generated because of crash dump is not issue yet as root on all nodes.
-	Slow performance server and failure failover on node 2
    -   rtvscand running as root processes consume High CPU

## Next Action
Based on Doc ID 2825579.1 “Crash Dump generation by Grid Infrastructure(GI) in Linux”

*) To generate a crash dump on all cases when CSS (CSSD agent) reboots a node, first ensure Linux kdump is enabled as mentioned in the section 1) above and then issue the following as root on all nodes:

crsctl modify type ora.cssd.type -attr "ATTRIBUTE=REBOOT_OPTS, TYPE=string, DEFAULT_VALUE=,FLAGS=CONFIG" -init
crsctl modify type ora.cssdmonitor.type -attr "ATTRIBUTE=REBOOT_OPTS, TYPE=string, DEFAULT_VALUE=,FLAGS=CONFIG" -init
crsctl modify res ora.cssd -attr "REBOOT_OPTS=CRASHDUMP" -init
crsctl modify res ora.cssdmonitor -attr "REBOOT_OPTS=CRASHDUMP" -init



