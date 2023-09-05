# How to Restart PostgreSQL

Untuk melakukan shutdown dan restart pada primary dan replica dalam konteks PostgreSQL, kita dapat mengikuti langkah-langkah berikut:

## Shutdown

ALUR SHUTDOWN DIMULAI DARI REPLICA -> PRIMARY

Pada server replica, kita dapat menjalankan perintah pg_ctl atau systemctl (tergantung pada sistem operasi kita) untuk menghentikan layanan PostgreSQL:

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

Lalu stop service:

```bash
systemctl status postgresql
```

```bash
date
```

```bash
systemctl stop postgresql
```

```bash
date
```

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