# How to Check Gap DC DRC PostgreSQL

Untuk memeriksa Gap pada PostgreSQL, Anda dapat menggunakan berbagai metode. Salah satu cara yang umum digunakan adalah dengan menggunakan utilitas pg_stat_replication untuk melihat status replikasi dan menentukan jika ada perbedaan antara master dan replica.

Berikut langkah-langkah umumnya:

1. Buka klien psql pada server replica atau masuk saja ke psql
```bash
sudo -u postgres psql
```

2. Lalu jalankan perintah berikut pada server replika atau standby
```bash
SELECT * FROM pg_stat_replication;
```

3. Kita dapat membandingkan nilai sent_lsn dan write_lsn dengan nilai pg_current_wal_lsn() di server master. Ini akan memberikan informasi tentang apakah ada "gap" (perbedaan) antara log transaksi yang telah dikirim dan yang telah ditulis oleh replica.
```bash
SELECT pg_current_wal_lsn();
```



