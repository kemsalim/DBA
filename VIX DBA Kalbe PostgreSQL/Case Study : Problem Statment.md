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