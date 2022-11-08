FROM ubuntu:18.04

RUN apt-get clean && apt-get update && apt-get install -y locales
run locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8
RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install gnupg2

RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb
RUN dpkg -i erlang-solutions_2.0_all.deb
RUN apt-get update

RUN apt-get -y install esl-erlang
RUN apt-get -y install elixir

RUN apt-get install libssl-dev

RUN mix local.hex --force
RUN mix local.rebar --force

COPY prod /bulletz/prod
COPY ./docker/builder/assets .

CMD /bin/bash
