FROM teeks99/clang-ubuntu

ENV sha256 0edf2360b185f0e1c68bb6ddbbbe3720af5651b3

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    zlib1g-dev \
    libpcre3-dev \
    libmysqlclient-dev

RUN curl -fSL "https://github.com/HerculesWS/Hercules/tarball/$sha256" | tar -xz --strip-components=1
# get rid of 60 seconds warning because we run as root
RUN sed -i 's/"$euid"/"1"/' configure
RUN ./configure
RUN make