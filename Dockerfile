FROM ubuntu:jammy
ADD --chmod=0775 "https://github.com/QW-Group/mvdsv/releases/download/v1.00/mvdsv_linux_amd64" /usr/bin/mvdsv
RUN mkdir -v /painkeep && \
    useradd -u 2001 -M -s /bin/false painkeep && \
    chmod -v +x /usr/bin/mvdsv

# hadolint ignore=DL3008, DL3015
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        libcurl4-openssl-dev && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /painkeep
WORKDIR /painkeep
USER painkeep:painkeep
EXPOSE 27500/udp
ENTRYPOINT ["/usr/bin/mvdsv", "-mem", "128", "+gamedir", "Painkeep", "-port", "27500", "+exec", "server.cfg", "-nopriority", "-noerrormsgbox", "+logrcon", "+logplayers", "+logerrors"]
