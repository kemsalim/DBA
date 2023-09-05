# How to Set Up a PostgreSQL Database with Docker

1. Download Docker
2. Set up an account on Docker Hub
3. Run Docker and Download Image
4. Start PostgreSQL Image
5. Connect to database and run SQL!

## How to start a postgres instance
```bash
docker run --name primary_db -p 5432:5432 -e POSTGRES_PASSWORD=adminpass -d postgres
```

## How to check user and database are on available
```bash
psql -U postgres
```

```bash
\du
```

and then you can try to connect on third app database like DBeaver

