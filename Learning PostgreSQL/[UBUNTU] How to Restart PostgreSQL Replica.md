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
![](Gambar/2.jpeg)

Pada Primary
Cek Streaming berjalan dengan baik
```bash
SELECT client_addr, state
FROM pg_stat_replication;
```
![](Gambar/3.jpeg)

```bash
SELECT pg_current_wal_lsn();
```
![](Gambar/4.jpeg)

Lalu mulai stop service dari STANDBY -> PRIMARY :

STANDBY :
```bash
systemctl status postgresql
```
![](Gambar/5.jpeg)
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
![](Gambar/6.jpeg)

PRIMARY:
```bash
systemctl status postgresql
```
```bash
date
```
![](Gambar/7.jpeg)

```bash
systemctl stop postgresql
```
```bash
systemctl status postgresql
```
```bash
date
```
![](Gambar/8.jpeg)

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