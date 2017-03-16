FROM debian:jessie

RUN dpkg --add-architecture i386
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -qy install --no-install-recommends python python-pip ca-certificates git libpq5:i386 libgcc1:i386 libtinfo5:i386 libncurses5:i386 lib32stdc++6 libcurl3-gnutls:i386 wget build-essential libffi-dev python-dev libssl-dev zip rsync
RUN pip install --upgrade pip setuptools wheel && pip install https://github.com/jsza/getoverhere/zipball/master
RUN pip install pyyaml
RUN adduser --uid 5000 --disabled-password --gecos "" steam

USER steam
ENV HOME /home/steam
ENV STEAMCMD $HOME/steamcmd

RUN mkdir $STEAMCMD && wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMCMD -xvz
RUN $STEAMCMD/steamcmd.sh +quit
