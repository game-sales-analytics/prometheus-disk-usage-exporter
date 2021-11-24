FROM docker.io/library/ubuntu:21.10 AS download

RUN groupadd --gid 1001 downloaders && useradd --create-home --gid 1001 --uid 1001 dl

RUN apt-get update -q && apt-get upgrade -yq && apt-get install -yq wget

USER dl

WORKDIR /home/dl

RUN wget https://github.com/dundee/disk_usage_exporter/releases/download/v0.1.0/disk_usage_exporter_linux_amd64.tgz

RUN tar -xvzf disk_usage_exporter_linux_amd64.tgz

FROM gcr.io/distroless/base-debian11

COPY --from=download /home/dl/disk_usage_exporter_linux_amd64 /bin/disk_usage_exporter

EXPOSE 9100

ENTRYPOINT  [ "disk_usage_exporter" ]
