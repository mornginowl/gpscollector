### GRP COLLECTOR

VirtualBox 6.1.4
https://www.virtualbox.org/wiki/Downloads

To Test ViruatBox and DockerToolbox
docker run --name=nginx -d -p 80:80 nginx
Will donwload Nginx
Run: docker-machine ip 
type in ip address in webbrowser address bar. Should see "Welcome to nginx" message.

>---------------------------
docker stop nginx
to stop nginx webserver 

docker ps -a  
verify status is excited

rocker rm nginx
to remove container

docker ps -a  
verify container is gone
>--------------------------

docker pull kartoza/postgis
>Pull postgis from repository


>Before we create the database we need to think about how our database info will be stored within Docker. Normally when you create a Docker container, you are not meant to be able to enter the containers filesystem to copy or modify data. This means that unless we specify what’s called a volume in Docker, our database data will be saved inside the container, making it difficult or impossible to perform backups or upgrades to the database software without losing all your data.

docker volume create pg_data

Create Database Connector
docker run --name=postgis -d -e POSTGRES_USER=alex -e POSTGRES_PASS=password -e POSTGRES_DBNAME=gis -e ALLOW_IP_RANGE=0.0.0.0/0 -p 5432:5432 -v pg_data:/var/lib/postgresql --restart=always kartoza/postgis:9.6-2.4

>This will download the image an setup postgres with postgis extension for spatial data.

>-------------------------
docker ps 
>To confirm the container has started

>To view the logs from the container
docker logs postgis


Run Sequel Migration
Database name:gis
sequel -m db/migrations postgres://alex:password@192.168.99.100:5432/gis



