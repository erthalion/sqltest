FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev git

RUN groupadd -r postgres --gid=999 && useradd -ms /bin/bash -r -g postgres --uid=999 postgres
USER postgres

RUN git clone -b sqljson https://github.com/postgrespro/sqljson.git /home/postgres/sqljson --depth=1

WORKDIR /home/postgres/sqljson
RUN ./configure --prefix=/home/postgres/postgres_sqljson
RUN make
RUN make install

WORKDIR /home/postgres/postgres_sqljson
RUN mkdir data
RUN ./bin/initdb -D data

EXPOSE 5432
ENV PGUSER postgres
CMD su postgres -c './bin/postgres -D data'
