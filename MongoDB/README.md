## Learn My Self About MongoDB

## How to Install MongoDB on Mac
1. Go To brew.sh, and install it
2. On terminal Mac, you can run and follow the command :

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)
```

```bash
brew install mongodb-enterprise@4.4
```
For another version you can follow this :
- mongodb-atlas-cli                                      
- mongodb/brew/libmongocrypt                             
- mongodb/brew/mongodb-community                         
- mongodb/brew/mongodb-community-shell                   
- mongodb/brew/mongodb-community-shell@4.4               
- mongodb/brew/mongodb-community@4.4                     
- mongodb/brew/mongodb-community@5.0                     
- mongodb/brew/mongodb-csfle                             
- mongodb/brew/mongodb-database-tools
- mongodb/brew/mongodb-enterprise
- mongodb/brew/mongodb-enterprise@4.4
- mongodb/brew/mongodb-enterprise@5.0
- mongodb/brew/mongodb-mongocryptd
- mongodb/brew/mongodb-mongocryptd@4.4
- mongodb/brew/mongodb-mongocryptd@5.0

3. And then you can enter the Mongo command :
```bash
mongosh
```

4. You can make sure, the Database is installed :
```bash
show dbs
```

## How to Install VBox (Full Screen) on VM CentOS
```bash
yum -y install gcc
```
```bash
yum install make perl
```
```bash
yum y install kernel-devel-$(uname -r)
```
```bash
yum install elfutils-libelf-devel
```
```bash
/run/media/admin/VBox_GAs_7.0.10/VBoxLinuxAdditions.run
```

## How to Install MongoDB on Linux/Red Hat
1. Create an ```/etc/yum.repos.d/mongodb-enterprise-6.0.repo``` file so that you can install MongoDB enterprise directly using yum:
```bash
[mongodb-enterprise-6.0]
name=MongoDB Enterprise Repository
baseurl=https://repo.mongodb.com/yum/redhat/$releasever/mongodb-enterprise/6.0/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc
```

2. Install the MongoDB Enterprise packages
Issue the following command:
```bash
yum install -y mongodb-enterprise
```

3. To make sure MongoDB well Installed 
```bash
mongod
```

4. To Start, Stop, and See Stat of MongoDB
```bash
systemctl start mongod
```
```bash
systemctl start mongod
```
```bash
systemctl enable mongod
```
```bash
netstat -ntpl
```
```bash
systemctl status mongod
```

## How to Create Database on MongoDB

- To create database, MongoDB use "use"
```bash
use database_name
```
- To see dbs
```bash
show dbs
```
- To see db
```bash
db
```
- To create table on DB 
```bash
db.createCollection("movienames")
```
- To see Collection or Table
```bash
show collection
```


