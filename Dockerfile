FROM docker.io/library/ubuntu:21.10 AS download

RUN groupadd --gid 1001 downloaders && useradd --create-home --gid 1001 --uid 1001 dl

RUN apt-get update -q && apt-get upgrade -yq && apt-get install -yq wget

USER dl

WORKDIR /home/dl

RUN wget https://github.com/dundee/disk_usage_exporter/releases/download/v0.1.0/disk_usage_exporter_linux_amd64.tgz

RUN echo dedfae73dd6346bf04f8093b555bef75e74585f0fe2e48cb71e19b446ecaaa5a  disk_usage_exporter_linux_amd64.tgz > sha256sum.txt

RUN sha256sum --check sha256sum.txt

RUN tar -xvzf disk_usage_exporter_linux_amd64.tgz

FROM docker.io/library/busybox:glibc

COPY --from=download /home/dl/disk_usage_exporter_linux_amd64 /bin/disk_usage_exporter

ENTRYPOINT  [ "disk_usage_exporter" ]
