# How to Restart PostgreSQL

Untuk melakukan shutdown dan restart pada primary dan replica dalam konteks PostgreSQL, kita dapat mengikuti langkah-langkah berikut:

## Shutdown

ALUR SHUTDOWN DIMULAI DARI REPLICA -> PRIMARY

Pada server replica, kita dapat menjalankan perintah pg_ctl atau systemctl (tergantung pada sistem operasi kita) untuk menghentikan layanan PostgreSQL:

Cek GAP terlebih dahulu:

Masuk ke psql dengan command
```bash
sudo -u postgres psql
```

Pada Standby
```bash
SELECT * FROM pg_stat_replication;
```
![](Gambar/2.png)

Pada Primary
Cek Streaming berjalan dengan baik
```bash
SELECT client_addr, state
FROM pg_stat_replication;
```
![](Gambar/3.png)

```bash
SELECT pg_current_wal_lsn();
```
![](Gambar/4.png)

Lalu mulai stop service dari STANDBY -> PRIMARY :

STANDBY :
```bash
systemctl status postgresql
```
![](Gambar/5.png)
```bash
date
```

```bash
systemctl stop postgresql
```
```bash
systemctl status postgresql
```
```bash
date
```
![](Gambar/6.png)

PRIMARY:
```bash
systemctl status postgresql
```
```bash
date
```
![](Gambar/7.png)

```bash
systemctl stop postgresql
```
```bash
systemctl status postgresql
```
```bash
date
```
![](Gambar/8.png)

## Restart

ALUR RESTART DIMULAI DARI PRIMARY -> REPLICA

Lalu start service:

```bash
systemctl status postgresql
```

```bash
date
```

```bash
systemctl start postgresql
```

```bash
SELECT client_addr, state
FROM pg_stat_replication;
```

```bash
date
```

Cek GAP terlebih dahulu:

```bash
sudo -u postgres psql
```

Pada Standby
```bash
SELECT * FROM pg_stat_replication;
```

Pada Primary
```bash
SELECT pg_current_wal_lsn();
```

Cek Streaming berjalan dengan baik
```bash
SELECT client_addr, state
FROM pg_stat_replication;
```