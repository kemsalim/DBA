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
• [Install DBEaver](https://drive.google.com/file/d/12fuefHljD_Y-fqjm6NxH-iBeP1mkveVM/view?usp=sharing)
• Install PostgreSQL
• Sudah Memahami DDL (Data Definition Language)
• DML (Data Manipulation Language)