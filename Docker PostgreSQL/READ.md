## COMMON COMMAND POSTGRESQL

| Command  | Level  | Keterangan  |
| -------- | -------- | -------- |
| ```bash docker container ls -a``` | - | list container |
| ```bash docker login``` | - | Login ke Docker |
| ```bash docker run -d --name postgres -p 5432:5432 -e POSTGRES_PASSWORD=password123 postgres``` | - | Membuat DB baru |
| ```bash docker container rm CONTAINER ID``` | - | Delete container aktif |
| ```bash docker images``` | - | Listing images docker yang ada (tersedia) |
| ```bash docker create --subnet=10.5.0.0/16 mynet``` | - | Membuat IP Static |
| ```bash docker ps``` | - | List docker yang sudah dibuat atau tersedia |
| ```bash docker connect bridge postgres-dc``` | - | Koneksinya supaya bridge |
| ```bash container exec -t postgres-dc bash``` | - | Untuk masuk ke PLSQL |
| ```bash docker container stop postgres-dc``` | - | Untuk stop service postgres |
| ```bash docker container start postgres-dc``` | - | Untuk start service postgres |
| ```bash nc -v ip port``` | - | Untuk test koneksi |
| ```bash CREATE USER replica REPLICATION LOGIN ENCRYPTED PASSWORD 'replica123';``` | - | Untuk membuat replica |
| ```bash vim pg_hba.conf``` | - | Memulai konfigurasi replika |
| ```bash psql -d postgres``` | - | Masuk ke postgresql |
| ```bash select pg_is_in_recovery();``` | - | Memeriksa status replikasi true atau false |




