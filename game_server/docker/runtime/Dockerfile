FROM ubuntu:18.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
      openssl \
    && apt-get clean

COPY socket_server/_build /bulletz/_build
COPY prod /bulletz/prod

EXPOSE 8000

CMD /bulletz/_build/prod/rel/socket_server/bin/socket_server start
