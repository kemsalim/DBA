## Software Detail
Oracle Oracle Database 19c Enterprise Edition Release 19.17.0.0.0 - Production

## Problem Identification
-	RAC, database downed and Server suddenly restarted on  node 1
-	Slow performance server and failure failover on node 2

## Analysis Result
-   RAC, database downed and Server suddenly restarted on  node 1
    
    
    - 15-04-2023 04:46:59  Database is still running normal
        2023-04-15T04:46:59.778208+07:00
        Thread 1 advanced to log sequence 30658 (LGWR switch),  current SCN: 21960424776
        Current log# 3 seq# 30658 mem# 0: +NEW_RECO/bsdionpay/onlinelog/group_3.289.983271403
        Current log# 3 seq# 30658 mem# 1: +NEW_DATA/bsdionpay/onlinelog/group_3.343.983271405

    -   15-04-2023 05:37:59 until 15-04-23 05:47:18 
        Aborted command ‘check’ for all resource
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

    -   15-04-2023 05:42:17 until 15-04-2023 05:47:45  
        all the incidents appeared on alert log concurrently with crs log on the previous point

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
