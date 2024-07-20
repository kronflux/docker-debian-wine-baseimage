# Set base debian image
FROM debian:bookworm-slim

# Set noninteractive mode for apt, configure locales, and install prerequisite packages
ARG DEBIAN_FRONTEND=noninteractive

RUN echo "" > /etc/apt/sources.list && \
    rm -f /etc/apt/sources.list.d/* && \
    echo "deb http://deb.debian.org/debian bookworm contrib main non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates contrib main non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian-security bookworm-security contrib main non-free non-free-firmware" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install --no-install-recommends locales && \
    echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=en_US.UTF-8 && \
    apt-get -y install --reinstall ca-certificates && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
        cabextract curl cron gettext gnupg \
        iproute2 jq lib32gcc-s1 \
        libntlm0 libsdl2-2.0-0 \
        locales numactl procps \
        screen tzdata unzip wget winbind xauth xvfb && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -qO- https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key && \
    echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.key] https://dl.winehq.org/wine-builds/debian/ bookworm main" > /etc/apt/sources.list.d/winehq.list && \
    apt-get update && \
    apt-get -y install --no-install-recommends winehq-stable && \
    apt-get -y autoremove --purge gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Download and install Winetricks
RUN wget -q -O /usr/sbin/winetricks https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x /usr/sbin/winetricks

# Set locale environment variables
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
