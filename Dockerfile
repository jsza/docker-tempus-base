FROM i386/debian:buster

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive \
        apt-get -qy install --no-install-recommends \
        python \
        python-pip \
        ca-certificates \
        gcc \
        git \
        libpq5 \
        libgcc1 \
        libtinfo5 \
        libncurses5 \
        libstdc++6 \
        libcurl3-gnutls \
        wget \
        libffi-dev \
        python-dev \
        libssl-dev \
        zip \
        rsync \
    && python -m pip install --upgrade pip setuptools \
    && python -m pip install virtualenv \
    && python -m virtualenv /venv \
    && /venv/bin/pip install --no-cache-dir \
        https://github.com/jsza/getoverhere/zipball/master \
        pyyaml \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy remove libffi-dev libssl-dev python-dev gcc \
    && DEBIAN_FRONTEND=noninteractive apt-get -qy autoremove

RUN adduser --uid 5000 --disabled-password --gecos "" steam

USER steam
ENV HOME /home/steam
ENV STEAMCMD $HOME/steamcmd

RUN mkdir $STEAMCMD && wget -O - http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $STEAMCMD -xvz
RUN $STEAMCMD/steamcmd.sh +quit

USER root
RUN apt-get -qy install --no-install-recommends sudo

# SRCDS is the nicest
ENTRYPOINT ["/usr/bin/nice", "-n", "-20", \
            "/usr/bin/ionice", "-c", "1", \
            "/usr/bin/sudo", "--user", "steam", "/srv/srcds/srcds_run"]
