# How to Stop and Start DB DEV MNC

## Stop
1. Sebelum dilakukan shutdown lakukan pengecekan dibawah ini terlebih dahulu, lalu screenshoot.
Jangan lupa masuk terlebih dahulu ke env nya jika belum. 
```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
lsnrctl status
```
```bash
date
```

#### SCREENSHOOT


```bash
sqlplus / as sysdba
```
```bash
select name, open_mode, database_role from v$database;
```
```bash
!date
```
```bash
!hostname
```

#### SCREENSHOOT

2. Lanjut kita bisa stop service DB nya.

```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
lsnrctl status
```
```bash
lsnrctl stop
```
```bash
lsnrctl status
```
```bash
date
```

#### SCREENSHOOT

```bash
shutdown immediate
```
```bash
!ps -ef | grep pmon
```
```bash
!ps -ef | grep lsnr
```
```bash
!date
```

## Start
Untuk start, kita bisa langsung dengan command berikut.

```bash
ps -ef | grep pmon
```
```bash
ps -ef | grep lsnr
```
```bash
lsnrctl status
```
```bash
lsnrctl start
```
```bash
lsnrctl status
```
```bash
date
```
	
#### SCREENSHOOT

```bash
sqlplus / as sysdba
```
```bash
startup
```
```bash
!ps -ef | grep pmon
```
```bash
!ps -ef | grep lsnr
```
```bash
!lsnrctl status
```
```bash
date
```

#### SCREENSHOOT
