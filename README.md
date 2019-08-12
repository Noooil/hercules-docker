# kirchenro

## Build Image

```
docker build -t build-image .
docker create --name build-container build-image
docker cp build-container:/app/build .
docker rm -v build-container
```

## Database

```
docker run \
    --name mariadb \
    -e MYSQL_DATABASE=hercules \
    -e MYSQL_USER=hercules \
    -e MYSQL_ALLOW_EMPTY_PASSWORD=yes \
    -v $(pwd)/sql-files:/docker-entrypoint-initdb.d \
    -v $(pwd)/data:/var/lib/mysql \
    -p 127.0.0.1:3306:3306 \
    -it mariadb:latest
```

```
docker run -it --network host --rm mariadb mysql -h127.0.0.1 -uroot
```
