# How to Patching DB Single Instance on Windows

### 1. Lakukan set profile terlebih dahulu
```bash
C:\Users\Administrator>set ORACLE_SID=EAM

C:\Users\Administrator>echo %ORACLE_SID%
EAM

C:\Users\Administrator>
C:\Users\Administrator>
```

### 2. Lakukan pengecekan version OPatch (Memastikan denegan DOC Read Me bahwa sudah sesuai)
```bash
C:\Users\Administrator>cd ..

C:\Users>D:

D:\>
D:\>
D:\>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\

06/21/2023  02:55 AM    <DIR>          Amel
05/19/2023  09:27 PM    <DIR>          app
05/12/2023  04:55 PM    <DIR>          bddab6deb688c466fcf420235048
05/12/2023  04:56 PM    <DIR>          bsi
08/19/2019  10:52 PM                42 credential sharefolder backup rman ora 102.txt
02/13/2023  07:31 PM       482,320,377 EAMPROD_13FEB23.zip
10/28/2023  11:02 AM    <DIR>          Installer
05/19/2023  10:17 PM            17,117 listdatafile.txt
12/02/2006  01:37 AM           904,704 msdia80.dll
11/19/2023  11:00 PM    <DIR>          OPENPO
11/20/2023  06:38 PM    <DIR>          p33575656_190000_MSWIN-x86-64
10/30/2023  12:09 PM     1,285,680,445 p33575656_190000_MSWIN-x86-64.zip
05/16/2023  12:12 PM             1,163 PFILE_16052023.ORA
07/26/2023  08:55 PM    <DIR>          RDL scripts
06/29/2019  03:01 PM               916 restoreEAM.sql
05/19/2023  09:59 PM               661 rman_backup.txt
11/20/2023  04:50 AM    <DIR>          scripts
05/23/2023  08:14 AM    <DIR>          Sisindokom
11/15/2023  10:15 PM    <DIR>          sqldeveloper
05/20/2023  08:59 AM    <DIR>          Task Scheduler
05/23/2023  08:19 AM    <DIR>          TITIP_WCS
05/22/2023  07:03 AM    <DIR>          tmp
12/09/2022  11:23 PM               679 tnsnames.ora
05/12/2023  04:55 PM    <DIR>          xampplite
               9 File(s)  1,768,926,104 bytes
              15 Dir(s)  127,977,287,680 bytes free

D:\>app
'app' is not recognized as an internal or external command,
operable program or batch file.

D:\>cd app

D:\app>
D:\app>
D:\app>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\app

05/19/2023  09:27 PM    <DIR>          .
05/19/2023  09:27 PM    <DIR>          ..
05/12/2023  04:58 PM    <DIR>          Administrator
05/19/2023  09:23 PM             5,772 CTL_ORI.TXT
05/19/2023  08:15 PM    <DIR>          oraadm
05/19/2023  10:13 PM             1,207 PFILE_MIG.TXT
05/19/2023  09:25 PM             1,207 PFILE_ORI.TXT
               3 File(s)          8,186 bytes
               4 Dir(s)  127,977,287,680 bytes free

D:\app>
D:\app>
D:\app>cd oraadm

D:\app\oraadm>
D:\app\oraadm>
D:\app\oraadm>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\app\oraadm

05/19/2023  08:15 PM    <DIR>          .
05/19/2023  08:15 PM    <DIR>          ..
05/19/2023  08:15 PM    <DIR>          admin
05/19/2023  08:20 PM    <DIR>          audit
05/19/2023  08:15 PM    <DIR>          cfgtoollogs
05/16/2023  01:05 PM    <DIR>          checkpoints
05/16/2023  01:05 PM    <DIR>          diag
05/19/2023  08:15 PM    <DIR>          fast_recovery_area
05/19/2023  10:11 PM    <DIR>          oradata
05/16/2023  11:46 AM    <DIR>          product
               0 File(s)              0 bytes
              10 Dir(s)  127,977,287,680 bytes free

D:\app\oraadm>cd product

D:\app\oraadm\product>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\app\oraadm\product

05/16/2023  11:46 AM    <DIR>          .
05/16/2023  11:46 AM    <DIR>          ..
05/16/2023  01:09 PM    <DIR>          19.0.0
               0 File(s)              0 bytes
               3 Dir(s)  127,977,287,680 bytes free

D:\app\oraadm\product>cd 19.0.0

D:\app\oraadm\product\19.0.0>
D:\app\oraadm\product\19.0.0>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\app\oraadm\product\19.0.0

05/16/2023  01:09 PM    <DIR>          .
05/16/2023  01:09 PM    <DIR>          ..
05/19/2023  08:09 PM    <DIR>          db_home
05/16/2023  01:15 PM     5,809,077,746 db_home.rar
               1 File(s)  5,809,077,746 bytes
               3 Dir(s)  127,977,287,680 bytes free

D:\app\oraadm\product\19.0.0>
D:\app\oraadm\product\19.0.0>
D:\app\oraadm\product\19.0.0>cd db_home

D:\app\oraadm\product\19.0.0\db_home>
D:\app\oraadm\product\19.0.0\db_home>
D:\app\oraadm\product\19.0.0\db_home>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\app\oraadm\product\19.0.0\db_home

05/19/2023  08:09 PM    <DIR>          .
05/19/2023  08:09 PM    <DIR>          ..
11/18/2023  03:11 AM    <DIR>          .patch_storage
05/16/2023  01:06 PM    <DIR>          addnode
05/30/2019  11:03 PM    <DIR>          admin
05/30/2019  11:05 PM    <DIR>          apex
05/30/2019  11:03 PM    <DIR>          ASP.NET
05/30/2019  11:03 PM    <DIR>          assistants
05/16/2023  01:40 PM    <DIR>          bin
05/16/2023  01:16 PM    <DIR>          cfgtoollogs
05/16/2023  01:06 PM    <DIR>          clone
05/30/2019  11:03 PM    <DIR>          crs
05/30/2019  11:03 PM    <DIR>          css
05/30/2019  11:03 PM    <DIR>          ctx
05/30/2019  11:03 PM    <DIR>          cv
05/30/2019  11:03 PM    <DIR>          data
07/04/2023  10:40 AM    <DIR>          database
05/30/2019  11:03 PM    <DIR>          dbs
05/16/2023  01:06 PM    <DIR>          deinstall
05/30/2019  11:03 PM    <DIR>          demo
05/30/2019  11:03 PM    <DIR>          diagnostics
05/30/2019  11:03 PM    <DIR>          dmu
05/30/2019  11:03 PM    <DIR>          dv
08/26/2015  10:26 AM               882 env.ora
05/30/2019  11:03 PM    <DIR>          has
05/30/2019  11:03 PM    <DIR>          hs
05/16/2023  01:05 PM    <DIR>          install
05/30/2019  11:05 PM    <DIR>          instantclient
05/16/2023  01:40 PM    <DIR>          inventory
05/30/2019  11:03 PM    <DIR>          javavm
05/30/2019  11:03 PM    <DIR>          jdbc
05/30/2019  11:06 PM    <DIR>          jdk
05/16/2023  01:40 PM    <DIR>          jlib
05/30/2019  11:03 PM    <DIR>          ldap
05/30/2019  11:06 PM    <DIR>          lib
05/19/2023  08:16 PM    <DIR>          log
05/30/2019  11:03 PM    <DIR>          md
05/30/2019  11:03 PM    <DIR>          mgw
05/30/2019  11:03 PM    <DIR>          MMC Snap-Ins
05/30/2019  11:03 PM    <DIR>          network
05/30/2019  11:03 PM    <DIR>          nls
05/30/2019  11:03 PM    <DIR>          oci
05/30/2019  11:03 PM    <DIR>          odbc
05/30/2019  11:03 PM    <DIR>          ODE.NET
05/16/2023  01:06 PM    <DIR>          ODP.NET
05/30/2019  11:03 PM    <DIR>          olap
05/30/2019  11:03 PM    <DIR>          oledb
05/30/2019  11:03 PM    <DIR>          oledbolap
05/16/2023  01:21 PM    <DIR>          OPatch
05/30/2019  11:04 PM    <DIR>          OPatch_Ori
05/30/2019  11:03 PM    <DIR>          opmn
10/29/2020  06:54 PM            43,008 orabase.exe
05/30/2019  11:03 PM    <DIR>          oracore
05/30/2019  11:03 PM    <DIR>          oradata
05/30/2019  11:03 PM    <DIR>          oramts
05/30/2019  11:03 PM    <DIR>          ord
05/30/2019  11:03 PM    <DIR>          ords
05/16/2023  01:06 PM    <DIR>          oui
05/30/2019  11:03 PM    <DIR>          owm
05/30/2019  11:03 PM    <DIR>          perl
05/30/2019  11:03 PM    <DIR>          plsql
05/30/2019  11:03 PM    <DIR>          precomp
05/30/2019  11:03 PM    <DIR>          QOpatch
05/30/2019  11:03 PM    <DIR>          R
05/30/2019  11:03 PM    <DIR>          racg
05/16/2023  01:40 PM    <DIR>          rdbms
05/30/2019  11:03 PM    <DIR>          relnotes
10/14/2016  06:50 PM             2,997 schagent.conf
09/29/2018  02:05 AM             1,090 setup.bat
11/14/2018  11:42 PM           288,608 setup.exe
05/30/2019  11:03 PM    <DIR>          slax
05/30/2019  11:04 PM    <DIR>          sqldeveloper
05/30/2019  11:03 PM    <DIR>          sqlj
05/16/2023  01:40 PM    <DIR>          sqlpatch
05/30/2019  11:03 PM    <DIR>          sqlplus
05/30/2019  11:03 PM    <DIR>          srvm
05/30/2019  11:03 PM    <DIR>          suptools
05/30/2019  11:03 PM    <DIR>          ucp
05/30/2019  11:03 PM    <DIR>          usm
05/30/2019  11:04 PM    <DIR>          utl
05/15/2023  02:47 PM     3,105,763,999 WINDOWS.X64_193000_db_home.zip
05/30/2019  11:03 PM    <DIR>          wwg
05/30/2019  11:03 PM    <DIR>          xdk
               6 File(s)  3,106,100,584 bytes
              77 Dir(s)  127,977,287,680 bytes free

D:\app\oraadm\product\19.0.0\db_home>cd OPatch

D:\app\oraadm\product\19.0.0\db_home\OPatch>dir
 Volume in drive D is New Volume
 Volume Serial Number is 2AC6-EB38

 Directory of D:\app\oraadm\product\19.0.0\db_home\OPatch

05/16/2023  01:21 PM    <DIR>          .
05/16/2023  01:21 PM    <DIR>          ..
05/16/2023  01:21 PM    <DIR>          auto
05/16/2023  01:21 PM    <DIR>          config
04/18/2023  11:36 PM               589 datapatch
04/18/2023  11:36 PM               627 datapatch.bat
05/16/2023  01:21 PM    <DIR>          docs
04/18/2023  11:36 PM            23,550 emdpatch.pl
05/16/2023  01:21 PM    <DIR>          jlib
05/16/2023  01:21 PM    <DIR>          jre
05/16/2023  01:21 PM    <DIR>          modules
05/16/2023  01:21 PM    <DIR>          ocm
04/18/2023  11:36 PM            49,873 opatch
04/18/2023  11:36 PM            16,556 opatch.bat
04/18/2023  11:36 PM             2,551 opatch.pl
04/18/2023  11:43 PM             1,763 opatchauto
04/18/2023  11:43 PM               393 opatchauto.cmd
05/16/2023  01:21 PM    <DIR>          opatchprereqs
04/18/2023  11:36 PM             4,290 opatch_env.sh
04/18/2023  11:36 PM             3,159 operr
04/18/2023  11:36 PM             4,218 operr.bat
04/18/2023  11:36 PM             3,177 operr_readme.txt
05/16/2023  01:21 PM    <DIR>          oplan
05/16/2023  01:21 PM    <DIR>          oracle_common
05/16/2023  01:21 PM    <DIR>          plugins
05/16/2023  01:21 PM    <DIR>          private
04/18/2023  11:36 PM             2,977 README.txt
05/16/2023  01:21 PM    <DIR>          scripts
04/18/2023  11:36 PM                27 version.txt
              14 File(s)        113,750 bytes
              15 Dir(s)  127,977,287,680 bytes free

D:\app\oraadm\product\19.0.0\db_home\OPatch>opatch version
OPatch Version: 12.2.0.1.37

OPatch succeeded.
```
### 3. Lakukan pengecekan konflik 
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>opatch prereq CheckConflictAgainstOHWithDetail -ph D:\p33575656_190000_MSWIN-x86-64\33575656
Oracle Interim Patch Installer version 12.2.0.1.37
Copyright (c) 2023, Oracle Corporation.  All rights reserved.

PREREQ session

Oracle Home       : D:\app\oraadm\product\19.0.0\db_home
Central Inventory : C:\Program Files\Oracle\Inventory
   from           :
OPatch version    : 12.2.0.1.37
OUI version       : 12.2.0.7.0
Log file location : D:\app\oraadm\product\19.0.0\db_home\cfgtoollogs\opatch\opatch2023-11-20_18-46-11PM_1.log

Invoking prereq "checkconflictagainstohwithdetail"

Prereq "checkConflictAgainstOHWithDetail" passed.

OPatch succeeded.
```
### 4. Stop Listener, supaya tidak ada aplikasi yang bisa akses ketika dilakukan patching. 
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>lsnrctl status

LSNRCTL for 64-bit Windows: Version 19.0.0.0.0 - Production on 20-NOV-2023 18:46:54

Copyright (c) 1991, 2020, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for 64-bit Windows: Version 19.0.0.0.0 - Production
Start Date                18-NOV-2023 03:09:52
Uptime                    2 days 15 hr. 37 min. 2 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   D:\app\oraadm\product\19.0.0\db_home\network\admin\listener.ora
Listener Log File         D:\app\oraadm\diag\tnslsnr\DSSVORA104\listener\alert\log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(PIPENAME=\\.\pipe\EXTPROC1521ipc)))
Services Summary...
Service "CLRExtProc" has 1 instance(s).
  Instance "CLRExtProc", status UNKNOWN, has 1 handler(s) for this service...
Service "EAM" has 1 instance(s).
  Instance "EAM", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully

D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>lsnrctl stop

LSNRCTL for 64-bit Windows: Version 19.0.0.0.0 - Production on 20-NOV-2023 18:47:05

Copyright (c) 1991, 2020, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
The command completed successfully

D:\app\oraadm\product\19.0.0\db_home\OPatch>lsnrctl status

LSNRCTL for 64-bit Windows: Version 19.0.0.0.0 - Production on 20-NOV-2023 18:47:15

Copyright (c) 1991, 2020, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   64-bit Windows Error: 61: Unknown error
Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=EXTPROC1521)))
TNS-12541: TNS:no listener
 TNS-12560: TNS:protocol adapter error
  TNS-00511: No listener
   64-bit Windows Error: 2: No such file or directory
```

### 5. Masuk ke SQLPLUS dan lakukan shut pada Instance DB.
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 20 18:47:25 2023
Version 19.9.0.0.0

Copyright (c) 1982, 2020, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0

SQL>
SQL>
SQL> select name, open_mode from v$database;

NAME      OPEN_MODE
--------- --------------------
EAM       READ WRITE

SQL>
SQL>
SQL> shut immediate;
Database closed.
Database dismounted.
ORACLE instance shut down.
SQL>
SQL>
SQL>
SQL> exit
ERROR:
ORA-03113: end-of-file on communication channel
Process ID: 0
Session ID: 0 Serial number: 0


Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.9.0.0.0 (with complications)
```

### 6. Sesuai dengan READ ME doc Patching, set PERL5LIB=
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>set PERL5LIB=
```

### 7. Lakukan stop service msdtc
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>net stop msdtc
The Distributed Transaction Coordinator service is stopping.
The Distributed Transaction Coordinator service was stopped successfully.

```

### 8. Lakukan dan mulai patching
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>opatch apply D:\p33575656_190000_MSWIN-x86-64\33575656
Oracle Interim Patch Installer version 12.2.0.1.37
Copyright (c) 2023, Oracle Corporation.  All rights reserved.


Oracle Home       : D:\app\oraadm\product\19.0.0\db_home
Central Inventory : C:\Program Files\Oracle\Inventory
   from           :
OPatch version    : 12.2.0.1.37
OUI version       : 12.2.0.7.0
Log file location : D:\app\oraadm\product\19.0.0\db_home\cfgtoollogs\opatch\opatch2023-11-20_19-09-37PM_1.log

Verifying environment and performing prerequisite checks...
OPatch continues with these patches:   33575656

Do you want to proceed? [y|n]
y
User Responded with: Y
All checks passed.

Please shutdown Oracle instances running out of this ORACLE_HOME on the local system.
(Oracle Home = 'D:\app\oraadm\product\19.0.0\db_home')


Is the local system ready for patching? [y|n]
y
User Responded with: Y
Backing up files...
Applying interim patch '33575656' to OH 'D:\app\oraadm\product\19.0.0\db_home'
ApplySession: Optional component(s) [ oracle.tomcat.crs, 19.0.0.0.0 ] , [ oracle.swd.oui.core.min, 19.0.0.0.0 ] , [ oracle.has.cfs, 19.0.0.0.0 ] , [ oracle.rdbms.tg4msql, 19.0.0.0.0 ] , [ oracle.rdbms.ic, 19.0.0.0.0 ] , [ oracle.rdbms.tg4ifmx, 19.0.0.0.0 ] , [ oracle.network.cman, 19.0.0.0.0 ] , [ oracle.has.deconfig, 19.0.0.0.0 ] , [ oracle.network.gsm, 19.0.0.0.0 ] , [ oracle.assistants.asm, 19.0.0.0.0 ] , [ oracle.has.cvu, 19.0.0.0.0 ] , [ oracle.tfa, 19.0.0.0.0 ] , [ oracle.rdbms.tg4sybs, 19.0.0.0.0 ] , [ oracle.usm, 19.0.0.0.0 ] , [ oracle.rdbms.tg4tera, 19.0.0.0.0 ] , [ oracle.ons.daemon, 19.0.0.0.0 ] , [ oracle.options.olap, 19.0.0.0.0 ] , [ oracle.swd.oui, 19.0.0.0.0 ] , [ oracle.assistants.usm, 19.0.0.0.0 ] , [ oracle.rdbms.tg4db2, 19.0.0.0.0 ] , [ oracle.options.olap.awm, 19.0.0.0.0 ] , [ oracle.has.crs, 19.0.0.0.0 ]  not present in the Oracle Home or a higher version is found.

Patching component oracle.has.common.cvu, 19.0.0.0.0...

Patching component oracle.has.rsf, 19.0.0.0.0...

Patching component oracle.ons, 19.0.0.0.0...

Patching component oracle.has.common, 19.0.0.0.0...

Patching component oracle.rdbms.util, 19.0.0.0.0...

Patching component oracle.sdo.locator.jrf, 19.0.0.0.0...

Patching component oracle.assistants.server, 19.0.0.0.0...

Patching component oracle.sqlplus, 19.0.0.0.0...

Patching component oracle.dbjava.jdbc, 19.0.0.0.0...

Patching component oracle.network.listener, 19.0.0.0.0...

Patching component oracle.odbc.ic, 19.0.0.0.0...

Patching component oracle.rdbms.rman, 19.0.0.0.0...

Patching component oracle.dbjava.ucp, 19.0.0.0.0...

Patching component oracle.precomp.common.core, 19.0.0.0.0...

Patching component oracle.oracore.rsf, 19.0.0.0.0...

Patching component oracle.ntoledb.odp_net_2, 19.0.0.0.0...

Patching component oracle.has.db, 19.0.0.0.0...

Patching component oracle.ntoramts, 19.0.0.0.0...

Patching component oracle.xdk.parser.java, 19.0.0.0.0...

Patching component oracle.network.client, 19.0.0.0.0...

Patching component oracle.blaslapack, 19.0.0.0.0...

Patching component oracle.tfa.db, 19.0.0.0.0...

Patching component oracle.ctx, 19.0.0.0.0...

Patching component oracle.rdbms.hsodbc, 19.0.0.0.0...

Patching component oracle.ldap.rsf, 19.0.0.0.0...

Patching component oracle.assistants.deconfig, 19.0.0.0.0...

Patching component oracle.ldap.owm, 19.0.0.0.0...

Patching component oracle.duma, 19.0.0.0.0...

Patching component oracle.precomp.lang, 19.0.0.0.0...

Patching component oracle.rdbms.rsf, 19.0.0.0.0...

Patching component oracle.rdbms.install.common, 19.0.0.0.0...

Patching component oracle.ldap.security.osdt, 19.0.0.0.0...

Patching component oracle.sdo, 19.0.0.0.0...

Patching component oracle.rdbms.rsf.ic, 19.0.0.0.0...

Patching component oracle.sqlplus.ic, 19.0.0.0.0...

Patching component oracle.rdbms.lbac, 19.0.0.0.0...

Patching component oracle.oraolap, 19.0.0.0.0...

Patching component oracle.precomp.rsf, 19.0.0.0.0...

Patching component oracle.assistants.acf, 19.0.0.0.0...

Patching component oracle.ntoledb, 19.0.0.0.0...

Patching component oracle.javavm.server, 19.0.0.0.0...

Patching component oracle.precomp.common, 19.0.0.0.0...

Patching component oracle.network.rsf, 19.0.0.0.0...

Patching component oracle.ovm, 19.0.0.0.0...

Patching component oracle.install.deinstalltool, 19.0.0.0.0...

Patching component oracle.rdbms.oci, 19.0.0.0.0...

Patching component oracle.rsf, 19.0.0.0.0...

Patching component oracle.clrintg.ode_net_2, 19.0.0.0.0...

Patching component oracle.nlsrtl.rsf, 19.0.0.0.0...

Patching component oracle.rdbms.install.plugins, 19.0.0.0.0...

Patching component oracle.javavm.client, 19.0.0.0.0...

Patching component oracle.rdbms.deconfig, 19.0.0.0.0...

Patching component oracle.dbjava.ic, 19.0.0.0.0...

Patching component oracle.rdbms.dv, 19.0.0.0.0...

Patching component oracle.aspnet_2, 19.0.0.0.0...

Patching component oracle.usm.deconfig, 19.0.0.0.0...

Patching component oracle.dbdev, 19.0.0.0.0...

Patching component oracle.ons.ic, 19.0.0.0.0...

Patching component oracle.mgw.common, 19.0.0.0.0...

Patching component oracle.xdk, 19.0.0.0.0...

Patching component oracle.rdbms.plsql, 19.0.0.0.0...

Patching component oracle.xdk.rsf, 19.0.0.0.0...

Patching component oracle.ctx.atg, 19.0.0.0.0...

Patching component oracle.rdbms.dbscripts, 19.0.0.0.0...

Patching component oracle.rdbms.olap, 19.0.0.0.0...

Patching component oracle.rdbms, 19.0.0.0.0...

Patching component oracle.sdo.locator, 19.0.0.0.0...

Patching component oracle.rdbms.scheduler, 19.0.0.0.0...

Patching component oracle.xdk.xquery, 19.0.0.0.0...

Patching component oracle.ntoledbolap, 19.0.0.0.0...
Patch 33575656 successfully applied.
Sub-set patch [31719903] has become inactive due to the application of a super-set patch [33575656].
Please refer to Doc ID 2161861.1 for any possible further required actions.
Log file location: D:\app\oraadm\product\19.0.0\db_home\cfgtoollogs\opatch\opatch2023-11-20_19-09-37PM_1.log

OPatch succeeded.

```

### 9. Lakukan pengecekan version terlebih dahulu bahwa patching sudah berhasil.
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 20 19:15:00 2023
Version 19.14.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.
```

### 10. Nyalakan kembali listener
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>lsnrctl start

LSNRCTL for 64-bit Windows: Version 19.0.0.0.0 - Production on 20-NOV-2023 19:15:22

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Starting tnslsnr: please wait...

TNSLSNR for 64-bit Windows: Version 19.0.0.0.0 - Production
System parameter file is D:\app\oraadm\product\19.0.0\db_home\network\admin\listener.ora
Log messages written to D:\app\oraadm\diag\tnslsnr\DSSVORA104\listener\alert\log.xml
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
Listening on: (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(PIPENAME=\\.\pipe\EXTPROC1521ipc)))

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for 64-bit Windows: Version 19.0.0.0.0 - Production
Start Date                20-NOV-2023 19:15:27
Uptime                    0 days 0 hr. 0 min. 8 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   D:\app\oraadm\product\19.0.0\db_home\network\admin\listener.ora
Listener Log File         D:\app\oraadm\diag\tnslsnr\DSSVORA104\listener\alert\log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(PIPENAME=\\.\pipe\EXTPROC1521ipc)))
Services Summary...
Service "CLRExtProc" has 1 instance(s).
  Instance "CLRExtProc", status UNKNOWN, has 1 handler(s) for this service...
Service "EAM" has 1 instance(s).
  Instance "EAM", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully

D:\app\oraadm\product\19.0.0\db_home\OPatch>lsnrctl status

LSNRCTL for 64-bit Windows: Version 19.0.0.0.0 - Production on 20-NOV-2023 19:15:38

Copyright (c) 1991, 2021, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for 64-bit Windows: Version 19.0.0.0.0 - Production
Start Date                20-NOV-2023 19:15:27
Uptime                    0 days 0 hr. 0 min. 14 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   D:\app\oraadm\product\19.0.0\db_home\network\admin\listener.ora
Listener Log File         D:\app\oraadm\diag\tnslsnr\DSSVORA104\listener\alert\log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=DSSVORA104.donggi-senoro.com)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(PIPENAME=\\.\pipe\EXTPROC1521ipc)))
Services Summary...
Service "CLRExtProc" has 1 instance(s).
  Instance "CLRExtProc", status UNKNOWN, has 1 handler(s) for this service...
Service "EAM" has 1 instance(s).
  Instance "EAM", status UNKNOWN, has 1 handler(s) for this service...
The command completed successfully

```

### 11. Start Instance Database kembali
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 20 19:17:23 2023
Version 19.14.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.14.0.0.0

SQL> select name, open_mode from v$database;

NAME      OPEN_MODE
--------- --------------------
EAM       READ WRITE

SQL>
SQL>
SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.14.0.0.0

D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
```

### 12. Check datapatch
```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>datapatch -verbose
SQL Patching tool version 19.14.0.0.0 Production on Mon Nov 20 19:18:31 2023
Copyright (c) 2012, 2021, Oracle.  All rights reserved.

Log file for this invocation: D:\app\oraadm\product\19.0.0\db_home\cfgtoollogs\sqlpatch\sqlpatch_884_2023_11_20_19_18_31\sqlpatch_invocation.log

Connecting to database...OK
Gathering database info...done
Bootstrapping registry and package to current versions...done
Determining current state...done

Current state of interim SQL patches:
  No interim patches found

Current state of release update SQL patches:
  Binary registry:
    19.14.0.0.0 Release_Update 211229195225: Installed
  SQL registry:
    Applied 19.9.0.0.0 Release_Update 201020093047 successfully on 09-DEC-22 10.24.57.755000 PM

Adding patches to installation queue and performing prereq checks...done
Installation queue:
  No interim patches need to be rolled back
  Patch 33575656 (Windows Database Bundle Patch : 19.14.0.0.220118 (33575656)):
    Apply from 19.9.0.0.0 Release_Update 201020093047 to 19.14.0.0.0 Release_Update 211229195225
  No interim patches need to be applied

Installing patches...
Patch installation complete.  Total patches installed: 1

Validating logfiles...done
Patch 33575656 apply: SUCCESS
  logfile: D:\app\oraadm\product\19.0.0\db_home\cfgtoollogs\sqlpatch\33575656\24640244/33575656_apply_EAM_2023Nov20_19_19_39.log (no errors)
SQL Patching tool complete on Mon Nov 20 19:22:18 2023
D:\app\oraadm\product\19.0.0\db_home\OPatch>
D:\app\oraadm\product\19.0.0\db_home\OPatch>
```

### 13. Masuk ke RDBMS Direktori dan lakukan utlrp

```bash
D:\app\oraadm\product\19.0.0\db_home\OPatch>cd
D:\app\oraadm\product\19.0.0\db_home\OPatch

D:\app\oraadm\product\19.0.0\db_home\OPatch>cd ..

D:\app\oraadm\product\19.0.0\db_home>
D:\app\oraadm\product\19.0.0\db_home>
D:\app\oraadm\product\19.0.0\db_home>cd rdbms/admin/

D:\app\oraadm\product\19.0.0\db_home\rdbms\admin>
D:\app\oraadm\product\19.0.0\db_home\rdbms\admin>
D:\app\oraadm\product\19.0.0\db_home\rdbms\admin>sqlplus / as sysdba

SQL*Plus: Release 19.0.0.0.0 - Production on Mon Nov 20 19:24:40 2023
Version 19.14.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.14.0.0.0

SQL> @utlrp.sql

Session altered.


TIMESTAMP
--------------------------------------------------------------------------------
COMP_TIMESTAMP UTLRP_BGN              2023-11-20 19:24:56

DOC>   The following PL/SQL block invokes UTL_RECOMP to recompile invalid
DOC>   objects in the database. Recompilation time is proportional to the
DOC>   number of invalid objects in the database, so this command may take
DOC>   a long time to execute on a database with a large number of invalid
DOC>   objects.
DOC>
DOC>   Use the following queries to track recompilation progress:
DOC>
DOC>   1. Query returning the number of invalid objects remaining. This
DOC>      number should decrease with time.
DOC>         SELECT COUNT(*) FROM obj$ WHERE status IN (4, 5, 6);
DOC>
DOC>   2. Query returning the number of objects compiled so far. This number
DOC>      should increase with time.
DOC>         SELECT COUNT(*) FROM UTL_RECOMP_COMPILED;
DOC>
DOC>   This script automatically chooses serial or parallel recompilation
DOC>   based on the number of CPUs available (parameter cpu_count) multiplied
DOC>   by the number of threads per CPU (parameter parallel_threads_per_cpu).
DOC>   On RAC, this number is added across all RAC nodes.
DOC>
DOC>   UTL_RECOMP uses DBMS_SCHEDULER to create jobs for parallel
```
