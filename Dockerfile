# Set base debian image
FROM debian:bookworm-slim

# Set noninteractive mode for apt, configure locales, install prerequisite packages
ARG DEBIAN_FRONTEND=noninteractive
RUN echo "deb http://deb.debian.org/debian bookworm contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends wget locales procps cron && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get -y install --reinstall ca-certificates && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
        curl gnupg2 iproute2 lib32gcc-s1 libncurses5:i386 \
        libncurses6:i386 libntlm0 libsdl2-2.0-0 libsdl2-2.0-0:i386 \
        numactl tzdata unzip winbind xauth xvfb && \
    wget -qO- https://dl.winehq.org/wine-builds/winehq.key | apt-key add - && \
    echo "deb https://dl.winehq.org/wine-builds/debian/ bookworm main" > /etc/apt/sources.list.d/wine.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends winehq-stable && \
    apt-get -y autoremove --purge gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Download and install Winetricks
RUN wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/sbin/winetricks

# Set locale environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
