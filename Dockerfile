FROM ghcr.io/birdhimself/base-proton:latest

RUN apt-get update
RUN apt-get install -y python3-pip python3-venv git gnutls-bin iproute2
RUN useradd -d /home/container -m container

WORKDIR /home/container

EXPOSE 7777/udp

COPY --chmod=0755 ./entrypoint.sh /entrypoint.sh

# Cleanup
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

ENV DISABLE_ENCRYPTION=false
ENV FORCE_CHOWN=false
ENV DEBUG=false

CMD [ "/bin/bash", "/entrypoint.sh" ]
