# kirchenro

```
docker build -t build-image .
docker create --name build-container build-image
docker cp build-container:/app/build .
docker rm -v build-container
```
