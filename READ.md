docker container ls -a
//list container

docker container rm CONTAINER ID
//delete container aktif

docker images
//listing images docker yang ada (tersedia)

docker pull postgres:10.21

docker create --subnet=10.5.0.0/16 mynet

docker network ls

docker run --net mynet --ip 10.5.0.2 -p 5433:5432 -d -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root123 -e POSTGRES_DB=postgres --name postgres-dc postgres:10.21

docker ps 
//list service docker

docker connect bridge postgres-dc

container exec -t postgres-dc bash
//untuk masuk ke postgres

docker container stop postgres-dc
//untuk turnoff

apt -get upgrade

dir
//cek direktory

nc -v ip port
//test koneksi 

CREATE USER replica REPLICATION LOGIN ENCRYPTED PASSWORD 'replica123';

vim pg_hba.conf

more postgresql.conf | grep wal_level

psql -d postgres
// masuk ke psql

select pg_is_in_recovery();
//memeriksa status replikasi true atau false



