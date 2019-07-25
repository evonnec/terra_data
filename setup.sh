#!/bin/bash

#set up virtual environment
sudo apt install virtualenv -y
python3 -m pip install --user --upgrade pip
python3 -m pip install --user virtualenv
sudo apt-get install python3-venv
python3 -m venv env
source env/bin/activate

#boto3 and other packages installed inside virtual env with python3
pip install boto3
pip install matplotlib
pip install pandas

sudo passwd
#enter a UNIX password

#create some users, permissions and the database
echo "CREATE USER ${POSTGRES_USER} PASSWORD '${POSTGRES_PWD}'; CREATE DATABASE ${DB_NAME}; GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${POSTGRES_USER};" | sudo -u postgres psql

#.pgpass set up is host:port:database_name:user:password
touch ~/.pgpass
chmod 700 .pgpass #give permissions
echo "*:5432:"${DB_NAME}":"${POSTGRES_USER}":"${POSTGRES_PWD} > .pgpass

#change the config files
sudo -u postgres sed -i "s|listen_addresses = 'localhost'|listen_addresses = '*'|" /etc/postgresql/[0-9][0-9]/main/postgresql.conf
sudo -u postgres sed -i "s|127.0.0.1/32|0.0.0.0/0|" /etc/postgresql/[0-9][0-9]/main/pg_hba.conf
sudo -u postgres sed -i "s|::1/128|::/0|" /etc/postgresql/[0-9][0-9]/main/pg_hba.conf
sudo -u postgres sed -i "s|    peer|    md5|g" /etc/postgresql/[0-9][0-9]/main/pg_hba.conf

#restart postgresql
sudo service postgresql restart

sudo -u postgres psql
#in postgres now
#postgres=#
\du #creates super user
\q

#out of postgres
sudo service postgresql reload

# aws configure
# resource key pair provided via terraform
aws s3 ls
aws s3 sync s3://${BUCKET_NAME} .

echo "Run Schema Writer"
#run python to write up schema
sudo chmod u+x create_schema_with_csv.py
./create_schema_with_csv.py

echo "Load schema of table"
#load schemas of tables
psql -f schemas/schema_readin_csv.sql -p ${POSTGRES_PORT} -U ${POSTGRES_USER} ${DB_NAME}

echo "Pipe in csv to Postgres"
#move s3 csv to postgres, table name should be argument for env
psql -p ${POSTGRES_PORT} -d ${DB_NAME} -U ${POSTGRES_USER} -c 'COPY public.raw_lending_club_loan_data FROM STDIN with (format csv, header true, delimiter ",");' < loan.csv




