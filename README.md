# kirchenro

### Prerequisites
* [Docker](https://hub.docker.com/?overlay=onboarding)
* [Git](https://git-scm.com/downloads)

### Download
```
git clone https://github.com/Noooil/kirchenro.git
```

### Compilation
```
docker build -t build-image .
docker create --name build-container build-image
docker cp build-container:/app/build .
```
at this time you can copy everything you need from the `build-container` like sql-files, db, maps, npcs

delete `build-container` for clean up (optional)  
```
docker rm -v build-container
```

if you copied the `build` folder into your current directory you can explore it and see that there are 3 folders with a structure like this:
```bash
─── char
    ├── Dockerfile
    ├── char-server
    ├── lib
    │   └── x86_64-linux-gnu
    │       ├── libc.so.6
    │       ├── libdl.so.2
    │       ├── libm.so.6
    │       ├── libpcre.so.3
    │       ├── libpthread.so.0
    │       └── libz.so.1
    ├── lib64
    │   └── ld-linux-x86-64.so.2
    └── usr
        └── lib
            └── x86_64-linux-gnu
                ├── libffi.so.6
                ├── libgmp.so.10
                ├── libgnutls.so.30
                ├── libhogweed.so.4
                ├── libidn2.so.0
                ├── libmariadb.so.3
                ├── libnettle.so.6
                ├── libp11-kit.so.0
                ├── libtasn1.so.6
                └── libunistring.so.2
```
This is a minimal docker template of the binary and the shared libraries which can each be built by docker with  
```
docker build -t <binary> .
```

Resulting in a docker image for each binary
You can look at the images and their respective checksum with  
```
docker images --no-trunc
```

If you change a compilation flag or the sources the checksum will change mere configs that are loaded at runtime will not affect the checksum

These images can be exported with
```
docker save -o <filename> <image>
```
and be loaded with
```
docker load -i <filename>
```

### Database

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
