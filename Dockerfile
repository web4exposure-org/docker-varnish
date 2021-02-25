FROM debian:stretch
MAINTAINER Fabrizio Balliano <fabrizio@fabrizioballiano.com>

# install https for bionic https influx/telegraf repo
RUN apt-get update && apt-get install -y apt-transport-https

# install varnish, procps, curl
RUN apt-get update && apt-get install -y varnish vim  && apt-get install -y gnupg2 && apt install -y curl && apt-get install -y procps
ADD ./configure_telegraf_install.sh /configure_telegraf_install.sh
RUN chmod +x /configure_telegraf_install.sh
RUN ./configure_telegraf_install.sh
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y telegraf &&  usermod -a -G varnish telegraf && apt-get clean
ADD ./start.sh /start.sh
RUN chmod +x /start.sh

ENV VCL_CONFIG      /etc/varnish/default.vcl
ENV CACHE_SIZE      256M
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600 -T 0.0.0.0:6082 -S /etc/varnish/secret

EXPOSE 80 6082

CMD /start.sh

