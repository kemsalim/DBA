## COMMON COMMAND POSTGRESQL

| Command  | Level  | Keterangan  |
| -------- | -------- | -------- |
| ``` docker container ls -a``` | - | list container |
| ``` docker login``` | - | Login ke Docker |
| ``` docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password123 postgres``` | - | Membuat DB baru |
| ``` docker container rm CONTAINER ID``` | - | Delete container aktif |
| ``` docker images``` | - | Listing images docker yang ada (tersedia) |
| ``` docker create --subnet=10.5.0.0/16 mynet``` | - | Membuat IP Static |
| ``` docker ps``` | - | List docker yang sudah dibuat atau tersedia |
| ``` docker connect bridge postgres-dc``` | - | Koneksinya supaya bridge |
| ``` container exec -t postgres-dc bash``` | - | Untuk masuk ke PLSQL |
| ``` docker container stop postgres-dc``` | - | Untuk stop service postgres |
| ``` docker container start postgres-dc``` | - | Untuk start service postgres |
| ``` nc -v ip port``` | - | Untuk test koneksi |
| ``` CREATE USER replica REPLICATION LOGIN ENCRYPTED PASSWORD 'replica123';``` | - | Untuk membuat replica |
| ``` vim pg_hba.conf``` | - | Memulai konfigurasi replika |
| ``` psql -d postgres``` | - | Masuk ke postgresql |
| ``` select pg_is_in_recovery();``` | - | Memeriksa status replikasi true atau false |
| ``` pg_config --version``` | - | Cek versi dari PostgreSQL |




