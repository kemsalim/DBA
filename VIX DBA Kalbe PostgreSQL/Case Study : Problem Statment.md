# Case Study: Problem Statement
Kalbe Nutritionals adalah salah satu perusahan terbesar di indonesia. Untuk menunjang kemampuan karyawan mereka, maka Kalbe Nutritionals ingin memberikan training kepada semua karyawan mereka berbasis online.

Oleh karena itu anda diminta untuk membuat aplikasi Training karyawan untuk Kalbe Nutritionals tersebut. Pada Sprint ini, kamu hanya diberikan task pada tabel Karyawan. Diketahui ERD Karyawan seperti berikut.

1. Buatlah Store Prosedure : Insert Karyawan jika diketahui :
```bash
Savekaryawan(INOUT nama varchar,
INPUT jk varchar,
INPUT dob date,
INPUT alamat text,
INPUT status varchar,
INPUT eror_desc varchar,
INPUT eror_code integer);
```

2. Buatlah Function : Tampilkan Semua Data Karyawan, dapat filter like berdasarkan nama karyawan.

## Persyaratan 
Sebelum mengerjakan task, maka sebaiknya menginstall dan mempelajari materi dibawah ini:
- [Install DBEaver](https://drive.google.com/file/d/12fuefHljD_Y-fqjm6NxH-iBeP1mkveVM/view?usp=sharing)
- [Install PostgreSQL](https://drive.google.com/file/d/12fuefHljD_Y-fqjm6NxH-iBeP1mkveVM/view?usp=sharing)
- [Sudah Memahami DDL (Data Definition Language)](https://drive.google.com/file/d/12fuefHljD_Y-fqjm6NxH-iBeP1mkveVM/view?usp=sharing)
- DML (Data Manipulation Language)

## Solusi
1. Buka DBEaver, Buat Koneksi Ke PostgreSql
2. Buka Editor
3. Membuat Table Karyawan 
```bash
create table karyawan (
	id serial not null,
	nama varchar(100) not null,
	jk varchar(20) not null,
	dob date null,
	status varchar(20) not null,
	alamat text,
	constraint karyawan_pkey
primary key(id));
```
4. Membuat Store Prosedure : Insert Karyawan
```bash
CREATE OR REPLACE PROCEDURE public.savekaryawan(INOUT nama VARCHAR, jk VARCHAR, dob DATE, status VARCHAR, alamat VARCHAR) LANGUAGE plpgsql AS $procedure$
DECLARE
    error_desc VARCHAR;
    error_code INT;
    vid INT;
BEGIN
    IF nama IS NULL OR jk IS NULL THEN
        RAISE NOTICE 'Data is null';
        error_desc = 'Data is null';
        error_code = 404;
        RETURN;
    ELSE
        RAISE NOTICE 'Insert successfully';
    END IF;

    INSERT INTO karyawan
    (id, nama, jk, dob, status, alamat)
    SELECT nextval('karyawan_id_seq'),
           nama,
           jk,
           dob,
           status,
           alamat
    RETURNING id INTO vid;

    error_desc = 'data berhasil disimpan';
    error_code = 200;

    COMMIT;
END;
$procedure$;
```

```bash
call savekaryawan('Satria','Pria','1993-10-26','Bandar Lampung','Aktif');
```

```bash
SELECT routine_name
FROM information_schema.routines
WHERE routine_type = 'PROCEDURE';
```

5. Membuat Function : Menampilkan Data Karyawan
```bash
CREATE OR REPLACE FUNCTION getlistkaryawan(rqnama character varying)
RETURNS TABLE (resid integer, resnama character varying, resjk character varying, redob date, restatus character varying, resalamat text)
LANGUAGE plpgsql
AS $function$
DECLARE
    var_r record;
BEGIN
    FOR var_r IN (SELECT
                      id,
                      nama,
                      jk,
                      dob,
                      status,
                      alamat
                  FROM karyawan
                  WHERE nama ILIKE rqnama)
    LOOP
        resid := var_r.id;
        resnama := var_r.nama;
        resjk := var_r.jk;
        redob := var_r.dob;
        restatus := var_r.status;
        resalamat := var_r.alamat;
        RETURN NEXT;
    END LOOP;
END;
$function$;
```

```bash
select * from getlistkaryawan('%Satria%');
```

## Exam HW1

1. Berikut ini, manakah yang bukan sebuah RDBMS?

A. Cassandra ---

B. Oracle Database

C. Microsoft Access

D. MariaDB

2. Ketika kita menginginkan biaya pengembangan sistem menjadi lebih murah, salah satu caranya adalah dengan mengurangi biaya lisensi RDBMS yang kita gunakan. Apa RDBMS yang sebaiknya digunakan dalam kondisi tersebut?

A. Oracle Database

B. Microsoft SQL Server

C. MariaDB ---

D. IBM DB2

3. Sebuah teknik yang digunakan untuk mengurangi beban server database dari jumlah request yang tinggi atau query yang kompleks adalah dengan cara memecah dan menduplikasi data ke beberapa server, lalu mengarahkan request ke beberapa server disebut ....

A. Backup

B. Replication ---

C. Restore

D. Log Shipping

4. Seorang data analis ditugaskan untuk melakukan analisa data penjualan dalam sebuah aplikasi penjualan. Data analis tersebut meminta akses untuk melakukan query ke dalam database aplikasi penjualan tersebut untuk mendapatkan hasil yang akurat dan realtime. Sebagai seorang Database Adminstrator, apa yang Anda lakukan agar kebutuhan data analis tersebut terpenuhi, namun integritas data, keamanan, serta performa aplikasi penjualan tetap tinggi?

A. Memberikan akses user root kepada data analis

B. Membuatkan akun baru dengan akses read only

C. Melakukan mirroring database, dan memberikan akses ke database mirror tersebut

D. Melakukan export data, kemudian diberikan ke data analis secara berkala

5. Apa kepanjangan dari T-SQL?

A. Task-SQL

B. Transfer-SQL

C. True-SQL

D. Transact-SQL ---

6. Kemampuan yang digunakan untuk menjalankan beberapa query secara bersamaan, dan membatalkan atau melanjutkan query ketika memenuhi suatu kondisi, disebut sebagai...

A. Transaction Control ---

B. Task Control

C. Control Flow

D. Transaction Flow 

7. Salah satu RDBMS open source dan gratis untuk digunakan adalah ....

A. MongoDB

B. SQL Server

C. PostgreSQL

D. Microsoft Access

8. Yang menjadi keuntungan menggunakan PostgreSQL dibandingkan menggunakan SQL Server adalah....

A. Biaya lebih rendah

B. Dapat diinstall di Server Linux

C. PostgreSQL didukung oleh perusahaan besar

D. Memiliki fitur stored procedure, function, hingga trigger

9. Berikut ini adalah kelebihan menggunakan TSQL dibandingkan dengan SQL kecuali....

A. Dalam T-SQL, pengguna dapat melakukan operasi logika & aritmatika di dalam query

B. Performa query ketika menggunakan T-SQL menjadi lebih baik

C. Dengan menggunakan T-SQL, nama kolom / field di dalam table tidak terekspos kepada programmer

D. Dengan menggunakan T-SQL, cara menjalankan query menjadi lebih ringkas

10. BEGIN;

INSERT INTO karyawan (nama, alamat) VALUES ('Dian Saputra', 'Yogyakarta');

ROLLBACK;


Dari query di atas, perubahan data apakah yang terjadi di dalam tabel karyawan?

A. Menambahkan satu data baru ke dalam table karyawan dengan data nama: 'Dian Saputra', dan alamat: 'Yogyakarta'

B. Tidak terjadi perubahan apa pun

C. Menambahkan dua data baru ke dalam table karyawan dengan data nama: 'Dian Saputra', dan alamat: 'Yogyakarta'

D. Memperbarui data alamat karyawan dengan nama: 'Dian Saputra' menjadi 'Yogyakarta'

11. Salah satu alasan mengapa dibutuhkan ETL (Extract, Transform, and Load) dalam proses analisa data adalah....

A. Data yang akan diolah memiliki bentuk / format yang berbeda dibandingkan bentuk / format yang didukung oleh database tujuan

B. Data yang akan diolah sangat besar

C. Data yang akan diolah / dianalisis berada di server yang berbeda dengan software data analis

D. Jumlah kolom dalam satu table sangat banyak

12. Berikut ini yang bukan merupakan software ETL adalah....

A. Pgloader

B. Pentaho Data Integration

C. CloverETL

D. DBeaver

13. Basic clause yang menentukan tabel atau query yang akan diakses dalam SQL adalah.....

A. SELECT

B. FROM

C. WHERE

D. TABLE

14. Data Definition Language (DDL), Data Manipulation Language (DML), dan Data Control Language (DCL) merupakan 3 jenis perintah SQL. Kategori manakah sebuah perintah SQL yang digunakan untuk membangun RDBMS?

A. Data Control Language (DCL)

B. Data Manipulation Language (DML)

C. Data Definition Language (DDL)

D. Semua Benar


