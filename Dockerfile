FROM gcc:latest

ENV sha256 0edf2360b185f0e1c68bb6ddbbbe3720af5651b3
ENV CPPFLAGS \
    -DI_AM_AWARE_OF_THE_RISK_AND_STILL_WANT_TO_RUN_HERCULES_AS_ROOT \
    -DPACKETVER=20180621

WORKDIR /app
COPY run.dockerfile .

RUN curl -fSL "https://github.com/HerculesWS/Hercules/tarball/$sha256" | tar -xz --strip-components=1

# get rid of 60 seconds warning because we run as root
RUN sed -i 's/"$euid"/"1"/' configure

RUN ./configure 
RUN make

RUN mkdir -p build/login
RUN mkdir -p build/char
RUN mkdir -p build/map

# LOGIN
# copy shared libraries
RUN cp -LR --parents `ldd login-server | grep -o -P '(?<==> ).*(?=\()'` ./build/login
# copy linux dynamic runtime loader
RUN cp -LR --parents `readelf -p .interp login-server | tail -2 | cut -f2 -d"]"` ./build/login
# copy actual binary
RUN cp ./login-server ./build/login
RUN sed 's/entrypoint/login-server/' run.dockerfile > ./build/login/Dockerfile

# CHAR
# copy shared libraries
RUN cp -LR --parents `ldd char-server | grep -o -P '(?<==> ).*(?=\()'` ./build/char
# copy linux dynamic runtime loader
RUN cp -LR --parents `readelf -p .interp char-server | tail -2 | cut -f2 -d"]"` ./build/char
# copy actual binary
RUN cp ./char-server ./build/char
RUN sed 's/entrypoint/char-server/' run.dockerfile > ./build/char/Dockerfile

# MAP
# copy shared libraries
RUN cp -LR --parents `ldd map-server | grep -o -P '(?<==> ).*(?=\()'` ./build/map
# copy linux dynamic runtime loader
RUN cp -LR --parents `readelf -p .interp map-server | tail -2 | cut -f2 -d"]"` ./build/map
# copy actual binary
RUN cp ./map-server ./build/map
RUN sed 's/entrypoint/map-server/' run.dockerfile > ./build/map/Dockerfile
